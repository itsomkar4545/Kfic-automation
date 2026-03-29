*** Settings ***
Documentation    Enhanced Data Utilities for Test Data Management
Library          Collections
Library          OperatingSystem
Library          String
Library          DateTime
Resource         ../config/framework_config.robot

*** Variables ***
${TEST_DATA_PATH}    ${CURDIR}/../data

*** Keywords ***
Load Test Data From JSON
    [Documentation]    Loads test data from JSON file with error handling
    [Arguments]    ${file_name}
    
    ${file_path}=    Join Path    ${TEST_DATA_PATH}    ${file_name}
    
    # Check if file exists
    File Should Exist    ${file_path}    Test data file not found: ${file_path}
    
    ${json_string}=    Get File    ${file_path}
    ${json_data}=    Evaluate    json.loads('''${json_string}''')    json
    
    Log    Loaded test data from: ${file_name}
    RETURN    ${json_data}

Get User Data By Environment
    [Documentation]    Gets user data based on current environment
    [Arguments]    ${role}    ${environment}=${ENVIRONMENT}
    
    ${users_data}=    Load Test Data From JSON    users.json
    ${user_data}=    Get From Dictionary    ${users_data}    ${role}
    
    Log    Retrieved user data for role: ${role}
    RETURN    ${user_data}

Get Lead Data
    [Documentation]    Gets lead data by type with dynamic ID generation
    [Arguments]    ${lead_type}=individual
    
    ${leads_data}=    Load Test Data From JSON    leads.json
    ${lead_data}=    Get From Dictionary    ${leads_data}    ${lead_type}
    
    # Generate unique ID for this test run
    ${unique_id}=    Generate Random Lead ID
    Set To Dictionary    ${lead_data}    IDNumber    ${unique_id}
    
    Log    Generated lead data for type: ${lead_type} with ID: ${unique_id}
    RETURN    ${lead_data}

Generate Random Lead ID
    [Documentation]    Generates unique lead ID with timestamp
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${random_number}=    Evaluate    random.randint(100, 999)    random
    ${lead_id}=    Set Variable    LD${timestamp}${random_number}
    RETURN    ${lead_id}

Generate Test Data
    [Documentation]    Generates dynamic test data
    [Arguments]    ${data_type}    ${format}=${EMPTY}
    
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    
    Run Keyword If    '${data_type}' == 'email'
    ...    RETURN    test_${timestamp}@kfic.com
    ...    ELSE IF    '${data_type}' == 'phone'
    ...    RETURN    +965${timestamp[-8:]}
    ...    ELSE IF    '${data_type}' == 'name'
    ...    RETURN    Test_User_${timestamp}
    ...    ELSE IF    '${data_type}' == 'id'
    ...    RETURN    ID${timestamp}
    ...    ELSE
    ...    RETURN    TestData_${timestamp}

Validate Lead Status In Database
    [Documentation]    Mock database validation - replace with actual DB query
    [Arguments]    ${lead_id}    ${expected_status}
    
    Log    Mock DB Validation: Lead ${lead_id} status should be ${expected_status}
    
    # TODO: Replace with actual database query when DB access is available
    # Example:
    # ${query}=    Set Variable    SELECT status FROM leads WHERE lead_id = '${lead_id}'
    # ${result}=    Execute Database Query    ${query}
    # ${actual_status}=    Get From List    ${result[0]}    0
    # Should Be Equal    ${actual_status}    ${expected_status}
    
    Log    Database validation passed (Mock implementation)

Create Test Report Data
    [Documentation]    Creates comprehensive test report data
    [Arguments]    ${test_name}    ${status}    ${duration}    ${environment}=${ENVIRONMENT}
    
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    
    ${report_data}=    Create Dictionary
    ...    test_name=${test_name}
    ...    status=${status}
    ...    duration=${duration}
    ...    environment=${environment}
    ...    timestamp=${timestamp}
    ...    framework_version=${FRAMEWORK_VERSION}
    
    Log    Test report data created: ${report_data}
    RETURN    ${report_data}

Save Test Results
    [Documentation]    Saves test results to JSON file
    [Arguments]    ${results_data}    ${filename}=test_results.json
    
    ${results_path}=    Join Path    ${REPORTS_DIR}    ${filename}
    Create Directory    ${REPORTS_DIR}
    
    # Load existing results if file exists
    ${existing_results}=    Run Keyword And Return Status    File Should Exist    ${results_path}
    
    Run Keyword If    ${existing_results}
    ...    ${all_results}=    Load Test Data From JSON    ${filename}
    ...    ELSE
    ...    ${all_results}=    Create List
    
    # Add new results
    Append To List    ${all_results}    ${results_data}
    
    # Save updated results
    ${json_string}=    Evaluate    json.dumps($all_results, indent=2)    json
    Create File    ${results_path}    ${json_string}
    
    Log    Test results saved to: ${results_path}