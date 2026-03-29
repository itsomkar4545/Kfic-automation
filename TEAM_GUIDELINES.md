# KFIC Automation Framework - Team Guidelines

## 🎯 Framework Overview
This is a comprehensive test automation framework for KFIC LOS & LMS applications built with Robot Framework.

## 📋 Team Guidelines

### 1. **Getting Started**
```bash
# Clone and setup
git clone <repository-url>
cd kfic-automation-framework

# Install dependencies
pip install -r requirements.txt

# Run sample test
robot tests/reliable_login_test.robot
```

### 2. **Framework Structure**
```
kfic-automation-framework/
├── config/                 # Configuration files
│   ├── environment.robot   # Basic environment config
│   └── framework_config.robot # Enhanced framework config
├── data/                   # Test data files
│   ├── users.json         # Basic user data
│   ├── users_enhanced.json # Environment-specific users
│   └── leads.json         # Lead test data
├── pages/                  # Page Object Model
│   ├── base_page.robot    # Common page utilities
│   ├── login_page.robot   # Login page objects
│   └── *.robot           # Other page objects
├── keywords/              # Reusable business keywords
├── tests/                 # Test suites
│   ├── template_test.robot # Template for new tests
│   └── */                 # Organized by module
├── utils/                 # Utility functions
├── results/               # Test results (auto-generated)
└── scripts/               # Execution scripts
```

### 3. **Naming Conventions**

#### Test Files
- `*_test.robot` - Test suites
- `TC###_Descriptive_Name` - Test cases
- Use snake_case for files and keywords

#### Variables
- `${UPPER_CASE}` - Global constants
- `${Title_Case}` - Local variables
- `&{DICTIONARY_NAME}` - Dictionaries
- `@{LIST_NAME}` - Lists

### 4. **Creating New Tests**

#### Step 1: Copy Template
```bash
cp tests/template_test.robot tests/your_module/your_test.robot
```

#### Step 2: Update Test Information
```robot
*** Settings ***
Documentation    Your test description
[Tags]    module_name    test_type    priority
```

#### Step 3: Follow Test Structure
```robot
TC001_Descriptive_Test_Name
    [Documentation]    Clear test description
    [Tags]    smoke    regression    critical
    
    # Step 1: Setup
    Login To Application    admin    password
    
    # Step 2: Test Actions
    Navigate To Module
    Perform Test Actions
    
    # Step 3: Verification
    Verify Expected Results
```

### 5. **Environment Management**

#### Switching Environments
```robot
# In config/framework_config.robot
${ENVIRONMENT}    qc    # Change to: dev, qc, uat, prod
```

#### Environment-Specific Data
```robot
# Use environment-aware data loading
${user_data}=    Get User Data By Environment    admin    qc
```

### 6. **Test Execution**

#### GUI Execution
```bash
# Run GUI executor
python gui_executor.py
# OR
run_gui.bat
```

#### Command Line Execution
```bash
# Single test
robot tests/login_test.robot

# Test suite
robot tests/los/

# All tests
robot tests/

# With specific tags
robot --include smoke tests/

# Parallel execution
pabot --processes 2 tests/

# With custom output directory
robot --outputdir results/run_$(date +%Y%m%d_%H%M%S) tests/
```

### 7. **Best Practices**

#### Test Design
- ✅ One test case = One business scenario
- ✅ Use descriptive test and keyword names
- ✅ Include proper documentation
- ✅ Add appropriate tags for categorization
- ✅ Use Page Object Model for UI interactions

#### Error Handling
- ✅ Always use `Wait For Element` keywords
- ✅ Include proper assertions
- ✅ Take screenshots on failures
- ✅ Use try-catch for optional elements

#### Data Management
- ✅ Use environment-specific test data
- ✅ Generate unique test data for each run
- ✅ Don't hardcode sensitive data in tests
- ✅ Use data-driven testing for multiple scenarios

### 8. **Code Review Checklist**

#### Before Committing
- [ ] Test passes in local environment
- [ ] Follows naming conventions
- [ ] Includes proper documentation
- [ ] Has appropriate tags
- [ ] Uses framework utilities
- [ ] No hardcoded values
- [ ] Proper error handling
- [ ] Screenshots on failure

### 9. **Troubleshooting**

#### Common Issues
1. **Element not found**
   - Check if element locator is correct
   - Increase timeout values
   - Use browser developer tools to inspect

2. **Test fails randomly**
   - Add proper waits
   - Check for loading spinners
   - Use retry mechanisms

3. **Data issues**
   - Verify test data files exist
   - Check JSON syntax
   - Ensure environment-specific data is available

#### Debug Mode
```bash
# Run with debug logging
robot --loglevel DEBUG tests/your_test.robot

# Run single test case
robot --test "TC001_Your_Test_Name" tests/your_test.robot
```

### 10. **Reporting**

#### Generated Reports
- `report.html` - Test execution report
- `log.html` - Detailed execution log
- `output.xml` - Machine-readable results

#### Screenshots
- Automatically captured on failures
- Stored in `results/screenshots/`
- Named with timestamp and test info

### 11. **CI/CD Integration**

#### Jenkins Pipeline
```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                bat 'robot --outputdir results tests/'
            }
        }
    }
    post {
        always {
            publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'results',
                reportFiles: 'report.html',
                reportName: 'Robot Framework Report'
            ])
        }
    }
}
```

### 12. **Support & Contact**

#### Framework Maintainers
- **Primary**: [Your Name] - [email]
- **Secondary**: [Backup Name] - [email]

#### Getting Help
1. Check this documentation first
2. Review existing test examples
3. Check framework logs and screenshots
4. Contact framework maintainers
5. Create issue in repository

---

## 🚀 Quick Start Commands

```bash
# Setup framework
pip install -r requirements.txt

# Run login test
robot tests/reliable_login_test.robot

# Run with GUI
python gui_executor.py

# Run all tests
robot tests/

# Generate reports
robot --outputdir results/$(date +%Y%m%d_%H%M%S) tests/
```

**Happy Testing! 🎉**