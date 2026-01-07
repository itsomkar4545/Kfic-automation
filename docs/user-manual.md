# KFIC Automation Framework - User Manual

## Table of Contents
1. [Getting Started](#getting-started)
2. [Framework Overview](#framework-overview)
3. [Running Tests](#running-tests)
4. [Creating New Tests](#creating-new-tests)
5. [Managing Test Data](#managing-test-data)
6. [Viewing Reports](#viewing-reports)
7. [Troubleshooting](#troubleshooting)
8. [Advanced Usage](#advanced-usage)

## Getting Started

### Prerequisites Check
Before using the framework, ensure you have:
- ✅ Python 3.9+ installed
- ✅ Framework dependencies installed (`pip install -r requirements.txt`)
- ✅ Chrome/Firefox browser installed
- ✅ Access to KFIC test environments

### Quick Start
1. **Open Terminal/Command Prompt**
2. **Navigate to framework directory**
   ```bash
   cd kfic-automation-framework
   ```
3. **Run your first test**
   ```bash
   # Windows
   scripts\run_tests.bat smoke
   
   # Linux/Mac
   ./scripts/run_tests.sh smoke
   ```

## Framework Overview

### Directory Structure
```
kfic-automation-framework/
├── 📁 config/          # Environment configurations
├── 📁 data/            # Test data files (JSON, Excel)
├── 📁 keywords/        # Business logic keywords
├── 📁 pages/           # Page objects for web elements
├── 📁 tests/           # Test suites organized by module
│   ├── 📁 los/         # LOS (Loan Origination System) tests
│   ├── 📁 lms/         # LMS (Loan Management System) tests
│   └── 📁 api/         # API tests
├── 📁 results/         # Test execution results
├── 📁 scripts/         # Execution scripts
└── 📁 docs/            # Documentation
```

### Key Components
- **Page Objects**: Represent web pages with their elements and actions
- **Keywords**: Reusable business functions (e.g., "Complete Credit Approval")
- **Test Cases**: Actual test scenarios that use keywords
- **Test Data**: JSON/Excel files containing test inputs

## Running Tests

### Using Execution Scripts (Recommended)

#### Windows Users
```batch
# Run smoke tests
scripts\run_tests.bat smoke

# Run full test suite
scripts\run_tests.bat full

# Run tests in parallel (faster)
scripts\run_tests.bat parallel

# Run specific module tests
scripts\run_tests.bat los
scripts\run_tests.bat api

# Run tests with specific tag
scripts\run_tests.bat tag critical
```

#### Linux/Mac Users
```bash
# Run smoke tests
./scripts/run_tests.sh smoke

# Run full test suite
./scripts/run_tests.sh full

# Run tests in parallel
./scripts/run_tests.sh parallel

# Run specific module tests
./scripts/run_tests.sh los
./scripts/run_tests.sh api

# Run tests with specific tag
./scripts/run_tests.sh tag critical
```

### Direct Robot Framework Commands

#### Basic Execution
```bash
# Run all tests
robot tests/

# Run specific test file
robot tests/los/lead_creation.robot

# Run specific test case
robot --test "TC001_Create_Individual_Lead" tests/los/lead_creation.robot
```

#### Environment-Specific Execution
```bash
# Run against development environment
robot --variable ENVIRONMENT:dev tests/

# Run against UAT environment
robot --variable ENVIRONMENT:uat tests/

# Run against production environment (be careful!)
robot --variable ENVIRONMENT:prod tests/
```

#### Browser-Specific Execution
```bash
# Run with Chrome (default)
robot --variable BROWSER:chrome tests/

# Run with Firefox
robot --variable BROWSER:firefox tests/

# Run in headless mode (no browser window)
robot --variable HEADLESS:True tests/
```

#### Tag-Based Execution
```bash
# Run only smoke tests
robot --include smoke tests/

# Run critical tests
robot --include critical tests/

# Run LOS module tests
robot --include los tests/

# Exclude slow tests
robot --exclude slow tests/

# Combine tags (smoke AND critical)
robot --include smokeANDcritical tests/
```

### Parallel Execution
For faster test execution, use parallel execution:

```bash
# Run with 4 parallel processes
pabot --processes 4 tests/

# Run with custom process count
pabot --processes 8 --include regression tests/
```

## Creating New Tests

### Step 1: Plan Your Test
Before writing code, define:
- **What are you testing?** (Feature/functionality)
- **What are the test steps?** (User actions)
- **What should be verified?** (Expected results)
- **What test data is needed?** (Input values)

### Step 2: Create Test File
Create a new `.robot` file in the appropriate directory:

```robot
*** Settings ***
Documentation    Description of your test suite
Resource         ../../keywords/lead_workflow.robot
Resource         ../../utils/data_utils.robot
Suite Setup      Open Application
Suite Teardown   Close Application
Test Tags        your_module    your_feature

*** Test Cases ***
TC001_Your_Test_Name
    [Documentation]    Detailed description of what this test does
    [Tags]    smoke    critical
    
    # Test steps
    ${user_data}=    Get User Data    credit_approver
    ${lead_data}=    Get Lead Data    individual
    
    Login As User    ${user_data}
    Complete Credit Approval    ${lead_data['IDNumber']}    ${user_data}
    Verify Success Message    Credit approved successfully
```

### Step 3: Add Test Data
Add your test data to appropriate JSON files:

```json
// data/your_test_data.json
{
  "test_scenario_1": {
    "input_field_1": "value1",
    "input_field_2": "value2",
    "expected_result": "expected_value"
  }
}
```

### Step 4: Run and Debug
```bash
# Run your new test
robot tests/your_module/your_test_file.robot

# Run with debug logging
robot --loglevel DEBUG tests/your_module/your_test_file.robot
```

## Managing Test Data

### JSON Data Files
Located in `data/` directory:

#### users.json - User Credentials
```json
{
  "credit_approver": {
    "username": "credit_user1",
    "password": "password123",
    "role": "Credit Approver"
  }
}
```

#### leads.json - Lead Information
```json
{
  "individual": {
    "IDNumber": "LD20241201001",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com"
  }
}
```

### Excel Data Files
For complex data sets, use Excel files:

| Test_ID | Lead_Type | First_Name | Last_Name | Email | Expected_Result |
|---------|-----------|------------|-----------|-------|-----------------|
| TC001   | Individual| John       | Doe       | john@example.com | SUCCESS |
| TC002   | Corporate | ABC Corp   | -         | info@abc.com | SUCCESS |

### Using Test Data in Tests
```robot
*** Test Cases ***
Data Driven Test Example
    ${lead_data}=    Load Test Data From JSON    leads.json
    ${individual_lead}=    Get From Dictionary    ${lead_data}    individual
    
    # Use the data
    Complete Lead Creation    ${individual_lead}
```

## Viewing Reports

### Built-in Robot Framework Reports
After test execution, three reports are generated in `results/` directory:

1. **report.html** - High-level summary
   - Test suite statistics
   - Pass/fail overview
   - Execution timeline

2. **log.html** - Detailed execution log
   - Step-by-step execution details
   - Screenshots (on failures)
   - Variable values
   - Timing information

3. **output.xml** - Machine-readable results
   - Used by CI/CD systems
   - Contains all execution data

### Allure Reports (Advanced)
Generate enhanced reports with Allure:

```bash
# Generate Allure report
scripts\run_tests.bat reports

# Or manually
allure generate results/allure-results -o results/allure-report
allure serve results/allure-results
```

Allure reports provide:
- 📊 Interactive dashboards
- 📈 Trend analysis
- 🔍 Detailed test breakdown
- 📱 Mobile-friendly interface

### Viewing Reports
1. **Open in Browser**: Double-click `report.html` or `log.html`
2. **Navigate Results**: Use browser navigation to explore
3. **Filter Results**: Use built-in filters to find specific tests
4. **Screenshots**: Click on failed tests to see screenshots

## Troubleshooting

### Common Issues and Solutions

#### 1. "WebDriver not found" Error
**Problem**: Browser driver not installed or not in PATH
**Solution**:
```bash
# Reinstall webdriver-manager
pip install --upgrade webdriver-manager

# Or manually install
python -c "from webdriver_manager.chrome import ChromeDriverManager; ChromeDriverManager().install()"
```

#### 2. "Element not found" Error
**Problem**: Web element locator is incorrect or element not loaded
**Solution**:
- Check if element exists on the page
- Verify locator syntax
- Add explicit waits
- Check for iframe context

#### 3. "Permission Denied" Error
**Problem**: Insufficient permissions to write files
**Solution**:
- Run command prompt as Administrator (Windows)
- Check file/directory permissions
- Ensure results directory is writable

#### 4. Tests Running Slowly
**Problem**: Tests taking too long to execute
**Solutions**:
- Use parallel execution: `pabot --processes 4 tests/`
- Run specific test tags: `--include smoke`
- Use headless browser: `--variable HEADLESS:True`
- Optimize wait times in test code

#### 5. "Module not found" Error
**Problem**: Python dependencies not installed
**Solution**:
```bash
# Reinstall dependencies
pip install -r requirements.txt

# Check virtual environment is activated
# Windows: venv\Scripts\activate
# Linux/Mac: source venv/bin/activate
```

### Debug Mode
Run tests with detailed logging:
```bash
robot --loglevel DEBUG --variable LOG_LEVEL:DEBUG tests/
```

### Getting Help
1. **Check Documentation**: Review `docs/` directory
2. **Check Logs**: Look at `log.html` for detailed error information
3. **Check Screenshots**: Failed tests automatically capture screenshots
4. **Contact Team**: Reach out to automation team with specific error details

## Advanced Usage

### Environment Configuration
Modify `config/environment.robot` for different environments:

```robot
*** Variables ***
${ENVIRONMENT}    dev    # Change to: dev, uat, prod

&{URLS}
...    dev=http://dev.kfic.com
...    uat=http://uat.kfic.com
...    prod=http://prod.kfic.com
```

### Custom Keywords
Create reusable keywords in `keywords/` directory:

```robot
*** Keywords ***
My Custom Workflow
    [Documentation]    Custom business workflow
    [Arguments]    ${parameter1}    ${parameter2}
    
    # Your custom logic here
    Log    Executing custom workflow with ${parameter1}
    # ... more steps
```

### Database Integration
Query database for verification:

```robot
*** Keywords ***
Verify Lead In Database
    [Arguments]    ${lead_id}    ${expected_status}
    ${result}=    Execute Database Query    SELECT status FROM leads WHERE id='${lead_id}'
    Should Be Equal    ${result[0][0]}    ${expected_status}
```

### API Testing
Test REST APIs:

```robot
*** Test Cases ***
TC001_API_Create_Lead
    Create Session    kfic_api    ${API_BASE_URL}
    ${data}=    Create Dictionary    firstName=John    lastName=Doe
    ${response}=    POST On Session    kfic_api    /leads    json=${data}
    Should Be Equal As Strings    ${response.status_code}    201
```

### Continuous Integration
The framework supports various CI/CD platforms:
- **GitHub Actions**: `.github/workflows/ci.yml`
- **Jenkins**: Use provided Jenkinsfile
- **Azure DevOps**: Use `azure-pipelines.yml`
- **GitLab CI**: Use `.gitlab-ci.yml`

### Docker Execution
Run tests in Docker containers:

```bash
# Build Docker image
docker build -t kfic-automation -f docker/Dockerfile .

# Run tests in container
docker run --rm -v $(pwd)/results:/app/results kfic-automation

# Use Docker Compose for complex setups
docker-compose -f docker/docker-compose.yml up --build
```

## Best Practices

### Test Organization
- ✅ Group related tests in same file
- ✅ Use descriptive test names
- ✅ Add proper documentation
- ✅ Use appropriate tags

### Test Data Management
- ✅ Keep test data separate from test logic
- ✅ Use meaningful data values
- ✅ Avoid hardcoded values in tests
- ✅ Use data-driven testing for multiple scenarios

### Execution Strategy
- ✅ Run smoke tests first
- ✅ Use parallel execution for large suites
- ✅ Run tests against appropriate environments
- ✅ Monitor test execution regularly

### Maintenance
- ✅ Update test data regularly
- ✅ Review and update locators when UI changes
- ✅ Keep framework dependencies updated
- ✅ Archive old test results periodically

## Support and Resources

### Documentation
- **Setup Guide**: `docs/setup.md`
- **Writing Tests**: `docs/writing-tests.md`
- **CI/CD Integration**: `docs/cicd.md`
- **Best Practices**: `docs/best-practices.md`

### External Resources
- **Robot Framework User Guide**: https://robotframework.org/robotframework/
- **Selenium Documentation**: https://selenium-python.readthedocs.io/
- **Allure Reports**: https://docs.qameta.io/allure/

### Getting Support
For technical support or questions:
1. Check this documentation first
2. Review test execution logs
3. Contact the automation team
4. Create issue in project repository