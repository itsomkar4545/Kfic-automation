*** Settings ***
Documentation    Template for KFIC Test Cases - Copy this file to create new tests
...              
...              Instructions for Team:
...              1. Copy this file and rename it appropriately
...              2. Update the Documentation with your test description
...              3. Add appropriate Tags for test categorization
...              4. Follow the naming convention: TC###_Descriptive_Name
...              5. Use proper keywords from pages/ and keywords/ folders
...              6. Always include proper error handling and screenshots

Library          SeleniumLibrary
Library          DateTime
Resource         ../pages/base_page.robot
Resource         ../pages/login_page.robot
Resource         ../config/framework_config.robot
Resource         ../utils/data_utils.robot

Suite Setup      Suite Setup Actions
Suite Teardown   Suite Teardown Actions
Test Setup       Test Setup Actions
Test Teardown    Test Teardown Actions

*** Variables ***
# Test-specific variables go here
${TEST_USER}     admin
${TEST_DATA}     sample_data

*** Test Cases ***
TC001_Sample_Test_Case
    [Documentation]    Sample test case - replace with your actual test
    ...                
    ...                Test Steps:
    ...                1. Open application
    ...                2. Perform login
    ...                3. Navigate to required page
    ...                4. Perform test actions
    ...                5. Verify results
    ...                
    ...                Expected Result: Test should pass successfully
    
    [Tags]    sample    template    smoke
    
    # Step 1: Login to application
    Login To Application    ${TEST_USER}    ${TEST_DATA}
    
    # Step 2: Perform test actions
    Perform Test Actions
    
    # Step 3: Verify results
    Verify Test Results

TC002_Another_Sample_Test
    [Documentation]    Another sample test case
    [Tags]    sample    regression
    
    Log    This is another sample test case
    Should Be True    True    Sample assertion

*** Keywords ***
Suite Setup Actions
    [Documentation]    Actions to perform before entire test suite
    Log    Starting Test Suite: ${SUITE NAME}
    Open Application
    
Suite Teardown Actions
    [Documentation]    Actions to perform after entire test suite
    Log    Completed Test Suite: ${SUITE NAME}
    Close Application

Test Setup Actions
    [Documentation]    Actions to perform before each test case
    Log    Starting Test Case: ${TEST NAME}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Set Test Variable    ${TEST_START_TIME}    ${timestamp}

Test Teardown Actions
    [Documentation]    Actions to perform after each test case
    Log    Completed Test Case: ${TEST NAME}
    
    # Take screenshot on failure
    Run Keyword If Test Failed    Take Screenshot On Failure
    
    # Log test duration
    ${end_time}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Log    Test Duration: ${TEST_START_TIME} to ${end_time}

Perform Test Actions
    [Documentation]    Sample keyword for test actions
    Log    Performing test actions...
    Sleep    1s
    Log    Test actions completed

Verify Test Results
    [Documentation]    Sample keyword for result verification
    Log    Verifying test results...
    Should Be True    True    Sample verification passed
    Log    Test results verified successfully

# Add your custom keywords below this line
# ==========================================

Your Custom Keyword
    [Documentation]    Template for your custom keyword
    [Arguments]    ${arg1}    ${arg2}=${EMPTY}
    
    Log    Custom keyword executed with args: ${arg1}, ${arg2}
    # Add your keyword implementation here