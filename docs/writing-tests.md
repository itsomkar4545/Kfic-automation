# KFIC Automation Framework - Writing Tests Guide

## Framework Architecture

### Page Object Model
The framework follows Page Object Model (POM) pattern:
- **Pages**: Web page representations with locators and actions
- **Keywords**: Business logic and reusable functions
- **Tests**: Test cases that use keywords and pages
- **Data**: Test data separated from test logic

### Directory Structure
```
tests/
├── los/                    # LOS specific tests
├── lms/                    # LMS specific tests
├── api/                    # API tests
└── integration/            # Integration tests

keywords/
├── lead_workflow.robot     # Business workflows
├── user_management.robot   # User related keywords
└── common.robot           # Common utilities

pages/
├── base_page.robot        # Base page with common elements
├── login_page.robot       # Login page object
└── lead_management_page.robot  # Lead management page
```

## Writing Test Cases

### Basic Test Structure
```robot
*** Settings ***
Documentation    Test Suite Description
Resource         ../../keywords/lead_workflow.robot
Suite Setup      Open Application
Suite Teardown   Close Application
Test Tags        smoke    regression

*** Test Cases ***
TC001_Test_Name
    [Documentation]    Test case description
    [Tags]    critical    los
    [Setup]    Test Setup Actions
    [Teardown]    Test Teardown Actions
    
    # Test steps
    Login As User    ${user_data}
    Complete Credit Approval    ${lead_id}    ${user_data}
    Verify Success Message    Credit approved successfully
```

### Test Case Naming Convention
- **Format**: `TC###_Descriptive_Name`
- **Examples**:
  - `TC001_Create_Individual_Lead_Complete_Workflow`
  - `TC002_Verify_Credit_Approval_Process`
  - `TC003_API_Create_Lead_Validation`

### Tags Usage
Use tags for test categorization and execution:
```robot
[Tags]    smoke    critical    los    individual_lead
```

**Standard Tags**:
- **Priority**: `critical`, `high`, `medium`, `low`
- **Type**: `smoke`, `regression`, `integration`
- **Module**: `los`, `lms`, `api`
- **Feature**: `lead_creation`, `credit_approval`, `disbursement`

## Creating Page Objects

### Base Page Template
```robot
*** Settings ***
Documentation    Page Object for [Page Name]
Resource         base_page.robot

*** Variables ***
# Page Locators
${ELEMENT_LOCATOR}    id=elementId
${BUTTON_LOCATOR}     xpath=//button[text()='Click Me']

*** Keywords ***
Page Action Keyword
    [Documentation]    Description of the action
    [Arguments]    ${parameter}
    Wait For Element And Click    ${ELEMENT_LOCATOR}
    Wait For Element And Input Text    ${INPUT_LOCATOR}    ${parameter}
```

### Locator Best Practices
1. **Priority Order**: `id` > `name` > `css` > `xpath`
2. **Stable Locators**: Use data attributes when available
3. **Descriptive Names**: Use meaningful variable names

```robot
# Good
${LOGIN_BUTTON}           id=loginBtn
${USERNAME_FIELD}         name=username
${ERROR_MESSAGE}          css=.error-message

# Avoid
${BUTTON1}                xpath=//button[1]
${DIV}                    css=div
```

## Creating Keywords

### Business Keywords
```robot
*** Keywords ***
Complete Lead Workflow
    [Documentation]    Completes entire lead workflow
    [Arguments]    ${lead_data}    ${users_data}
    
    Login As User    ${users_data['credit_approver']}
    Complete Credit Approval    ${lead_data['IDNumber']}
    Switch User    ${users_data['offer_manager']}
    Complete Offer Process    ${lead_data['IDNumber']}
    # Continue workflow...
```

### Utility Keywords
```robot
*** Keywords ***
Wait For Element And Perform Action
    [Documentation]    Generic keyword for element interaction
    [Arguments]    ${locator}    ${action}    ${value}=${EMPTY}
    
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Run Keyword If    '${action}' == 'click'    Click Element    ${locator}
    ...    ELSE IF    '${action}' == 'input'    Input Text    ${locator}    ${value}
    ...    ELSE    Fail    Unsupported action: ${action}
```

## Data Management

### JSON Data Files
```json
{
  "individual_lead": {
    "IDNumber": "LD20241201001",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com"
  }
}
```

### Excel Data Files
| Test_ID | Lead_Type | First_Name | Last_Name | Email |
|---------|-----------|------------|-----------|-------|
| TC001   | Individual| John       | Doe       | john@example.com |

### Using Test Data
```robot
*** Test Cases ***
Data Driven Test
    [Template]    Execute Lead Creation
    # Data from Excel
    ${test_data}=    Load Test Data From Excel    leads.xlsx
    FOR    ${row}    IN    @{test_data}
        Execute Lead Creation    ${row}
    END

Execute Lead Creation
    [Arguments]    ${data}
    ${lead_id}=    Get From Dictionary    ${data}    IDNumber
    Complete Lead Workflow    ${data}
```

## API Testing

### API Test Structure
```robot
*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Test Cases ***
TC001_API_Create_Lead
    [Documentation]    Test lead creation via API
    [Tags]    api    create_lead
    
    Create Session    kfic_api    ${API_BASE_URL}
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${data}=    Create Dictionary    firstName=John    lastName=Doe
    
    ${response}=    POST On Session    kfic_api    /leads    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    
    ${lead_id}=    Get From Dictionary    ${response.json()}    id
    Set Suite Variable    ${CREATED_LEAD_ID}    ${lead_id}
```

## Test Execution

### Single Test Execution
```bash
# Run specific test file
robot tests/los/lead_creation.robot

# Run specific test case
robot --test "TC001_Create_Individual_Lead" tests/los/lead_creation.robot

# Run with specific tags
robot --include smoke tests/
```

### Parallel Execution
```bash
# Run tests in parallel
pabot --processes 4 tests/

# Run specific suite in parallel
pabot --processes 2 --include critical tests/los/
```

### Environment-Specific Execution
```bash
# Run against different environments
robot --variable ENVIRONMENT:dev tests/
robot --variable ENVIRONMENT:uat tests/
robot --variable ENVIRONMENT:prod tests/
```

## Test Reporting

### Built-in Reports
Robot Framework generates three reports:
- **output.xml**: Detailed execution results
- **log.html**: Detailed test log
- **report.html**: High-level test report

### Allure Reports
```bash
# Generate Allure report
allure generate results/allure-results -o results/allure-report

# Serve Allure report
allure serve results/allure-results
```

### Custom Reporting
```robot
*** Keywords ***
Create Custom Report
    [Documentation]    Creates custom test report
    ${report_data}=    Create Dictionary
    ...    suite_name=${SUITE_NAME}
    ...    total_tests=${SUITE_STATISTICS.total}
    ...    passed_tests=${SUITE_STATISTICS.passed}
    ...    failed_tests=${SUITE_STATISTICS.failed}
    
    ${json_string}=    Convert JSON To String    ${report_data}
    Create File    results/custom_report.json    ${json_string}
```

## Best Practices

### Test Design
1. **Independent Tests**: Each test should be independent
2. **Clear Documentation**: Document test purpose and steps
3. **Meaningful Assertions**: Use descriptive assertion messages
4. **Data Separation**: Keep test data separate from test logic

### Code Organization
1. **Modular Design**: Create reusable keywords
2. **Consistent Naming**: Follow naming conventions
3. **Resource Management**: Properly manage browser sessions
4. **Error Handling**: Implement proper error handling

### Performance
1. **Implicit Waits**: Use appropriate wait strategies
2. **Parallel Execution**: Design tests for parallel execution
3. **Resource Cleanup**: Clean up resources after tests
4. **Selective Execution**: Use tags for selective test execution

## Debugging Tests

### Debug Mode
```bash
# Run with debug mode
robot --loglevel DEBUG tests/

# Run with variable logging
robot --variable LOG_LEVEL:DEBUG tests/
```

### Screenshots
```robot
*** Keywords ***
Take Debug Screenshot
    [Documentation]    Takes screenshot for debugging
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    debug_${timestamp}.png
```

### Logging
```robot
*** Keywords ***
Debug Log
    [Arguments]    ${message}
    Log    ${message}    level=DEBUG
    Log To Console    DEBUG: ${message}
```

## Advanced Features

### Custom Libraries
Create Python libraries for complex operations:
```python
# custom_library.py
class CustomLibrary:
    def complex_calculation(self, value1, value2):
        return value1 * value2 + 10
```

### Database Integration
```robot
*** Keywords ***
Verify Database State
    [Arguments]    ${lead_id}    ${expected_status}
    Connect To Database    pymysql    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}
    ${result}=    Query    SELECT status FROM leads WHERE id='${lead_id}'
    Should Be Equal    ${result[0][0]}    ${expected_status}
    Disconnect From Database
```

### Email Integration
```robot
*** Keywords ***
Verify Email Notification
    [Arguments]    ${email_address}    ${subject}
    ${emails}=    Get Emails From IMAP    ${IMAP_SERVER}    ${EMAIL_USER}    ${EMAIL_PASS}
    ${found}=    Check Email Exists    ${emails}    ${email_address}    ${subject}
    Should Be True    ${found}    Email notification not received
```