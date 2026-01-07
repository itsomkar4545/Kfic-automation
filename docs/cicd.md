# KFIC Automation Framework - CI/CD Integration Guide

## Overview

This guide covers integrating the KFIC automation framework with various CI/CD platforms for continuous testing and deployment.

## GitHub Actions Integration

### Workflow Configuration
The framework includes a pre-configured GitHub Actions workflow (`.github/workflows/ci.yml`) that provides:

- **Multi-environment testing** (Python 3.9, 3.10, 3.11)
- **Cross-browser testing** (Chrome, Firefox)
- **Parallel execution** for faster feedback
- **Automated reporting** with Allure
- **Artifact management** for test results

### Workflow Triggers
```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM
```

### Custom Workflow Variables
Set these secrets in your GitHub repository:
```
KFIC_DEV_URL=http://dev.kfic.com
KFIC_UAT_URL=http://uat.kfic.com
KFIC_PROD_URL=http://prod.kfic.com
DB_PASSWORD=your_db_password
API_TOKEN=your_api_token
```

## Jenkins Integration

### Jenkinsfile
Create a `Jenkinsfile` in your repository root:

```groovy
pipeline {
    agent any
    
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'uat', 'prod'],
            description: 'Target environment'
        )
        choice(
            name: 'BROWSER',
            choices: ['chrome', 'firefox', 'edge'],
            description: 'Browser for testing'
        )
        choice(
            name: 'TEST_SUITE',
            choices: ['smoke', 'regression', 'full'],
            description: 'Test suite to execute'
        )
    }
    
    environment {
        PYTHON_VERSION = '3.11'
        VIRTUAL_ENV = 'venv'
    }
    
    stages {
        stage('Setup') {
            steps {
                script {
                    // Create virtual environment
                    sh '''
                        python3 -m venv ${VIRTUAL_ENV}
                        source ${VIRTUAL_ENV}/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt
                    '''
                }
            }
        }
        
        stage('Smoke Tests') {
            when {
                anyOf {
                    params.TEST_SUITE == 'smoke'
                    params.TEST_SUITE == 'full'
                }
            }
            steps {
                script {
                    sh '''
                        source ${VIRTUAL_ENV}/bin/activate
                        robot --variable ENVIRONMENT:${ENVIRONMENT} \
                              --variable BROWSER:${BROWSER} \
                              --include smoke \
                              --outputdir results/smoke \
                              tests/
                    '''
                }
            }
        }
        
        stage('Regression Tests') {
            when {
                anyOf {
                    params.TEST_SUITE == 'regression'
                    params.TEST_SUITE == 'full'
                }
            }
            steps {
                script {
                    sh '''
                        source ${VIRTUAL_ENV}/bin/activate
                        pabot --processes 4 \
                              --variable ENVIRONMENT:${ENVIRONMENT} \
                              --variable BROWSER:${BROWSER} \
                              --include regression \
                              --outputdir results/regression \
                              tests/
                    '''
                }
            }
        }
        
        stage('API Tests') {
            steps {
                script {
                    sh '''
                        source ${VIRTUAL_ENV}/bin/activate
                        robot --variable ENVIRONMENT:${ENVIRONMENT} \
                              --include api \
                              --outputdir results/api \
                              tests/api/
                    '''
                }
            }
        }
    }
    
    post {
        always {
            // Archive test results
            archiveArtifacts artifacts: 'results/**/*', fingerprint: true
            
            // Publish Robot Framework results
            robot outputPath: 'results', 
                  reportFileName: 'report.html',
                  logFileName: 'log.html',
                  outputFileName: 'output.xml'
            
            // Generate and publish Allure report
            allure([
                includeProperties: false,
                jdk: '',
                properties: [],
                reportBuildPolicy: 'ALWAYS',
                results: [[path: 'results/allure-results']]
            ])
            
            // Send notifications
            script {
                def status = currentBuild.currentResult
                def color = status == 'SUCCESS' ? 'good' : 'danger'
                
                slackSend(
                    channel: '#automation-results',
                    color: color,
                    message: "KFIC Automation Tests - ${status}\nEnvironment: ${params.ENVIRONMENT}\nBrowser: ${params.BROWSER}\nSuite: ${params.TEST_SUITE}"
                )
            }
        }
        
        cleanup {
            // Clean workspace
            cleanWs()
        }
    }
}
```

### Jenkins Setup
1. Install required plugins:
   - Robot Framework Plugin
   - Allure Plugin
   - Pipeline Plugin
   - Slack Notification Plugin

2. Configure global tools:
   - Python 3.11
   - Allure Commandline

3. Set up credentials:
   - Database passwords
   - API tokens
   - Slack webhook URLs

## Azure DevOps Integration

### Azure Pipelines YAML
Create `azure-pipelines.yml`:

```yaml
trigger:
  branches:
    include:
    - main
    - develop

pr:
  branches:
    include:
    - main

variables:
  pythonVersion: '3.11'
  vmImage: 'ubuntu-latest'

stages:
- stage: Test
  displayName: 'Run Tests'
  jobs:
  - job: SmokeTests
    displayName: 'Smoke Tests'
    pool:
      vmImage: $(vmImage)
    strategy:
      matrix:
        Chrome:
          browser: 'chrome'
        Firefox:
          browser: 'firefox'
    steps:
    - task: UsePythonVersion@0
      inputs:
        versionSpec: $(pythonVersion)
        displayName: 'Use Python $(pythonVersion)'
    
    - script: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
      displayName: 'Install dependencies'
    
    - script: |
        robot --variable ENVIRONMENT:dev \
              --variable BROWSER:$(browser) \
              --include smoke \
              --outputdir $(Agent.TempDirectory)/results \
              tests/
      displayName: 'Run Smoke Tests'
    
    - task: PublishTestResults@2
      condition: always()
      inputs:
        testResultsFiles: '$(Agent.TempDirectory)/results/output.xml'
        testRunTitle: 'Robot Framework Tests - $(browser)'
    
    - task: PublishHtmlReport@1
      condition: always()
      inputs:
        reportDir: '$(Agent.TempDirectory)/results'
        tabName: 'Robot Framework Report'

  - job: APITests
    displayName: 'API Tests'
    pool:
      vmImage: $(vmImage)
    steps:
    - task: UsePythonVersion@0
      inputs:
        versionSpec: $(pythonVersion)
    
    - script: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
      displayName: 'Install dependencies'
    
    - script: |
        robot --variable ENVIRONMENT:dev \
              --include api \
              --outputdir $(Agent.TempDirectory)/api-results \
              tests/api/
      displayName: 'Run API Tests'
    
    - task: PublishTestResults@2
      condition: always()
      inputs:
        testResultsFiles: '$(Agent.TempDirectory)/api-results/output.xml'
        testRunTitle: 'API Tests'

- stage: ParallelTests
  displayName: 'Parallel Regression Tests'
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
  jobs:
  - job: RegressionTests
    displayName: 'Regression Tests'
    pool:
      vmImage: $(vmImage)
    steps:
    - task: UsePythonVersion@0
      inputs:
        versionSpec: $(pythonVersion)
    
    - script: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
      displayName: 'Install dependencies'
    
    - script: |
        pabot --processes 4 \
              --variable ENVIRONMENT:dev \
              --variable BROWSER:chrome \
              --include regression \
              --outputdir $(Agent.TempDirectory)/regression-results \
              tests/
      displayName: 'Run Regression Tests in Parallel'
    
    - task: PublishTestResults@2
      condition: always()
      inputs:
        testResultsFiles: '$(Agent.TempDirectory)/regression-results/output.xml'
        testRunTitle: 'Regression Tests'
```

## GitLab CI Integration

### .gitlab-ci.yml
```yaml
stages:
  - test
  - report

variables:
  PIP_CACHE_DIR: "$CI_PROJECT_DIR/.cache/pip"
  PYTHON_VERSION: "3.11"

cache:
  paths:
    - .cache/pip/
    - venv/

before_script:
  - python -V
  - pip install virtualenv
  - virtualenv venv
  - source venv/bin/activate
  - pip install -r requirements.txt

smoke_tests:
  stage: test
  parallel:
    matrix:
      - BROWSER: [chrome, firefox]
  script:
    - robot --variable ENVIRONMENT:dev 
            --variable BROWSER:$BROWSER 
            --include smoke 
            --outputdir results/smoke-$BROWSER 
            tests/
  artifacts:
    when: always
    paths:
      - results/
    reports:
      junit: results/*/output.xml
    expire_in: 1 week

api_tests:
  stage: test
  script:
    - robot --variable ENVIRONMENT:dev 
            --include api 
            --outputdir results/api 
            tests/api/
  artifacts:
    when: always
    paths:
      - results/api/
    reports:
      junit: results/api/output.xml

regression_tests:
  stage: test
  only:
    - main
    - develop
  script:
    - pabot --processes 4 
            --variable ENVIRONMENT:dev 
            --variable BROWSER:chrome 
            --include regression 
            --outputdir results/regression 
            tests/
  artifacts:
    when: always
    paths:
      - results/regression/
    reports:
      junit: results/regression/output.xml

generate_report:
  stage: report
  dependencies:
    - smoke_tests
    - api_tests
    - regression_tests
  script:
    - allure generate results/*/allure-results -o public/allure-report
  artifacts:
    paths:
      - public/
  only:
    - main
```

## Docker Integration

### Multi-stage Dockerfile
```dockerfile
# Build stage
FROM python:3.11-slim as builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Runtime stage
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget gnupg unzip curl xvfb \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get install -y google-chrome-stable

# Copy Python packages from builder
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

WORKDIR /app
COPY . .

# Create results directory
RUN mkdir -p results

# Set environment variables
ENV PYTHONPATH=/app
ENV DISPLAY=:99

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import robot; print('Framework ready')" || exit 1

# Default command
CMD ["robot", "--outputdir", "results", "tests/"]
```

### Docker Compose for CI
```yaml
version: '3.8'

services:
  test-runner:
    build: .
    volumes:
      - ./results:/app/results
      - ./data:/app/data
    environment:
      - ENVIRONMENT=dev
      - BROWSER=chrome
      - HEADLESS=true
    depends_on:
      - selenium-hub
    networks:
      - test-network

  selenium-hub:
    image: selenium/hub:4.15.0
    ports:
      - "4444:4444"
    environment:
      - GRID_MAX_SESSION=16
    networks:
      - test-network

  chrome:
    image: selenium/node-chrome:4.15.0
    shm_size: 2gb
    depends_on:
      - selenium-hub
    environment:
      - HUB_HOST=selenium-hub
      - NODE_MAX_INSTANCES=4
    networks:
      - test-network
    scale: 2

networks:
  test-network:
    driver: bridge
```

## Monitoring and Notifications

### Slack Integration
```python
# utils/notifications.py
import requests
import json

def send_slack_notification(webhook_url, test_results):
    payload = {
        "text": f"KFIC Automation Results",
        "attachments": [
            {
                "color": "good" if test_results['passed'] > test_results['failed'] else "danger",
                "fields": [
                    {"title": "Total Tests", "value": test_results['total'], "short": True},
                    {"title": "Passed", "value": test_results['passed'], "short": True},
                    {"title": "Failed", "value": test_results['failed'], "short": True},
                    {"title": "Environment", "value": test_results['environment'], "short": True}
                ]
            }
        ]
    }
    
    requests.post(webhook_url, data=json.dumps(payload))
```

### Email Reports
```python
# utils/email_reports.py
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

def send_email_report(smtp_server, port, username, password, recipients, results_path):
    msg = MIMEMultipart()
    msg['From'] = username
    msg['To'] = ", ".join(recipients)
    msg['Subject'] = "KFIC Automation Test Results"
    
    body = f"""
    Test execution completed.
    
    Results summary:
    - Total Tests: {results['total']}
    - Passed: {results['passed']}
    - Failed: {results['failed']}
    
    Please find detailed report attached.
    """
    
    msg.attach(MIMEText(body, 'plain'))
    
    # Attach report
    with open(f"{results_path}/report.html", "rb") as attachment:
        part = MIMEBase('application', 'octet-stream')
        part.set_payload(attachment.read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="report.html"')
        msg.attach(part)
    
    server = smtplib.SMTP(smtp_server, port)
    server.starttls()
    server.login(username, password)
    server.send_message(msg)
    server.quit()
```

## Best Practices

### CI/CD Pipeline Design
1. **Fast Feedback**: Run smoke tests first
2. **Parallel Execution**: Use parallel jobs for faster execution
3. **Environment Isolation**: Use separate environments for different branches
4. **Artifact Management**: Store test results and reports
5. **Failure Analysis**: Implement failure categorization

### Security Considerations
1. **Secrets Management**: Use CI/CD platform secret management
2. **Environment Variables**: Don't hardcode sensitive data
3. **Access Control**: Limit pipeline access to authorized users
4. **Audit Logging**: Enable audit logs for pipeline executions

### Performance Optimization
1. **Caching**: Cache dependencies and virtual environments
2. **Resource Allocation**: Optimize resource usage for parallel execution
3. **Test Selection**: Use tags for selective test execution
4. **Infrastructure**: Use appropriate CI/CD infrastructure

### Monitoring and Alerting
1. **Test Metrics**: Track test execution metrics
2. **Failure Trends**: Monitor failure patterns
3. **Performance Metrics**: Track execution time trends
4. **Alert Configuration**: Set up alerts for critical failures