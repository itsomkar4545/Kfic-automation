# Jenkins CI/CD Setup Guide for KFIC Framework

## 🚀 Quick Jenkins Setup (15 Minutes)

### Step 1: Install Jenkins
```bash
# Download Jenkins from: https://www.jenkins.io/download/
# Install and start Jenkins on http://localhost:8080
```

### Step 2: Install Required Plugins
Go to **Manage Jenkins > Manage Plugins > Available**
Install these plugins:
- ✅ **Robot Framework Plugin**
- ✅ **Pipeline Plugin** 
- ✅ **Git Plugin**
- ✅ **Email Extension Plugin**
- ✅ **Build Timeout Plugin**

### Step 3: Create New Pipeline Job
1. **New Item** > **Pipeline** > Name: `KFIC-Automation`
2. **Pipeline Definition**: Pipeline script from SCM
3. **SCM**: Git
4. **Repository URL**: Your git repo URL
5. **Script Path**: `Jenkinsfile`

### Step 4: Configure Global Tools
**Manage Jenkins > Global Tool Configuration**
- **Python**: Add Python installation path
- **Git**: Configure git executable

## 📋 Jenkins Job Configuration

### Basic Pipeline Job Setup:
```groovy
// Our Jenkinsfile already handles everything!
// Just point to the Jenkinsfile in your repo
```

### Manual Job Setup (Alternative):
If you prefer manual setup instead of pipeline:

#### Build Steps:
```batch
REM Install dependencies
pip install -r requirements.txt

REM Run tests
robot --variable BROWSER:chrome --variable ENVIRONMENT:qc --outputdir results tests/

REM Parallel execution
pabot --processes 4 --outputdir results/parallel tests/
```

#### Post-build Actions:
- ✅ **Publish Robot Framework test results**
  - Directory: `results`
  - Report filename: `report.html`
  - Log filename: `log.html`

- ✅ **Archive artifacts**: `results/**/*`

- ✅ **Email notification** (optional)

## 🔧 Environment Variables
Set these in Jenkins job configuration:
```
BROWSER = chrome
ENVIRONMENT = qc
PYTHON_PATH = C:\Python313
```

## 📊 Scheduled Execution
**Build Triggers > Build periodically:**
```
# Daily at 2 AM
0 2 * * *

# Every 4 hours
0 */4 * * *

# Monday to Friday at 9 AM
0 9 * * 1-5
```

## 🚨 Notifications Setup
**Post-build Actions > Email Extension:**
```
Subject: KFIC Test Results - Build $BUILD_NUMBER
Recipients: team@kfic.com

Body:
Test execution completed!
Build: $BUILD_NUMBER  
Status: $BUILD_STATUS
Results: $BUILD_URL
```

## 📈 Dashboard Setup
Create Jenkins dashboard view:
1. **New View** > **Dashboard View**
2. Add widgets:
   - **Test Results Trend**
   - **Build History**
   - **Test Statistics Table**

## 🔄 Webhook Integration (Optional)
For automatic builds on code push:
1. **GitHub/GitLab**: Add webhook URL
2. **URL**: `http://jenkins-server:8080/github-webhook/`
3. **Events**: Push events

## 🛠️ Troubleshooting

### Common Issues:
| Issue | Solution |
|-------|----------|
| Python not found | Set PYTHON_PATH in environment |
| Robot command not found | Install robotframework: `pip install robotframework` |
| Browser not found | Install ChromeDriver/GeckoDriver |
| Permission denied | Run Jenkins as administrator |

### Debug Commands:
```batch
REM Check Python
python --version

REM Check Robot Framework
robot --version

REM Check installed packages
pip list
```

## 📱 Mobile Integration (Bonus)
Add Slack/Teams notifications:
```groovy
post {
    always {
        slackSend channel: '#automation',
                  message: "KFIC Tests: ${currentBuild.result} - ${BUILD_URL}"
    }
}
```

## 🎯 Best Practices

### 1. **Parallel Execution**
- Use `pabot --processes 4` for 4x speed
- Separate smoke and regression tests

### 2. **Environment Management**
- Use different Jenkins jobs for different environments
- QC, UAT, Production pipelines

### 3. **Reporting**
- Archive all test artifacts
- Keep test history for trend analysis
- Set up email notifications for failures

### 4. **Security**
- Use Jenkins credentials for sensitive data
- Don't hardcode passwords in scripts

## 🚀 Quick Start Commands

### Start Jenkins:
```bash
# Windows
java -jar jenkins.war

# Linux/Mac
sudo systemctl start jenkins
```

### Access Jenkins:
```
http://localhost:8080
```

### First Time Setup:
1. Get initial admin password from Jenkins logs
2. Install suggested plugins
3. Create admin user
4. Start using Jenkins!

---

**That's it! Your Jenkins CI/CD is ready in 15 minutes! 🎉**

For any issues, check Jenkins logs at: `http://localhost:8080/log/all`