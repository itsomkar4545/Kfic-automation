*** Settings ***
Documentation    Data Utilities for Test Data Management
Library          Collections
Library          OperatingSystem
Library          ExcelLibrary
Library          JSONLibrary
Library          DatabaseLibrary
Library          String
Library          DateTime

*** Variables ***
${TEST_DATA_PATH}    ${CURDIR}/../data

*** Keywords ***
Load Test Data From Excel
    [Documentation]    Loads test data from Excel file
    [Arguments]    ${file_name}    ${sheet_name}=Sheet1
    ${file_path}=    Join Path    ${TEST_DATA_PATH}    ${file_name}
    Open Excel Document    ${file_path}    doc_id=testdata
    ${data}=    Read Excel Worksheet    name=${sheet_name}    header=True
    Close Excel Document    doc_id=testdata
    RETURN    ${data}

Load Test Data From JSON
    [Documentation]    Loads test data from JSON file
    [Arguments]    ${file_name}
    ${file_path}=    Join Path    ${TEST_DATA_PATH}    ${file_name}
    ${json_data}=    Load JSON From File    ${file_path}
    RETURN    ${json_data}

Get User Data
    [Documentation]    Gets user data by role
    [Arguments]    ${role}
    ${users_data}=    Load Test Data From JSON    users.json
    ${user_data}=    Get From Dictionary    ${users_data}    ${role}
    RETURN    ${user_data}

Get Lead Data
    [Documentation]    Gets lead data by type
    [Arguments]    ${lead_type}=individual
    ${leads_data}=    Load Test Data From JSON    leads.json
    ${lead_data}=    Get From Dictionary    ${leads_data}    ${lead_type}
    RETURN    ${lead_data}

Generate Random Lead ID
    [Documentation]    Generates random lead ID
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${random_number}=    Evaluate    random.randint(1000, 9999)    random
    ${lead_id}=    Set Variable    LD${timestamp}${random_number}
    RETURN    ${lead_id}

Generate Test Data
    [Documentation]    Generates test data using Faker
    [Arguments]    ${data_type}
    ${faker}=    Evaluate    __import__('faker').Faker()
    Run Keyword If    '${data_type}' == 'name'    RETURN    ${faker.name()}
    ...    ELSE IF    '${data_type}' == 'email'    RETURN    ${faker.email()}
    ...    ELSE IF    '${data_type}' == 'phone'    RETURN    ${faker.phone_number()}
    ...    ELSE IF    '${data_type}' == 'address'    RETURN    ${faker.address()}
    ...    ELSE    RETURN    ${faker.text()}

Execute Database Query
    [Documentation]    Executes database query
    [Arguments]    ${query}    ${db_config}=${None}
    Run Keyword If    ${db_config} == ${None}    ${db_config}=    Get Database Config
    Connect To Database    pymysql    ${db_config.database}    ${db_config.username}    ${db_config.password}    ${db_config.host}    ${db_config.port}
    ${result}=    Query    ${query}
    Disconnect From Database
    RETURN    ${result}

Validate Lead Status In Database
    [Documentation]    Validates lead status in database
    [Arguments]    ${lead_id}    ${expected_status}
    ${query}=    Set Variable    SELECT status FROM leads WHERE lead_id = '${lead_id}'
    ${result}=    Execute Database Query    ${query}
    ${actual_status}=    Get From List    ${result[0]}    0
    Should Be Equal    ${actual_status}    ${expected_status}

Create Test Report Data
    [Documentation]    Creates test report data
    [Arguments]    ${test_name}    ${status}    ${duration}
    ${report_data}=    Create Dictionary
    ...    test_name=${test_name}
    ...    status=${status}
    ...    duration=${duration}
    ...    timestamp=${CURDIR}/../results/test_report.json
    ${existing_data}=    Run Keyword And Return Status    Load Test Data From JSON    test_report.json
    Run Keyword If    ${existing_data}    Append To List    ${existing_data}    ${report_data}
    ...    ELSE    ${existing_data}=    Create List    ${report_data}
    ${json_string}=    Convert JSON To String    ${existing_data}
    Create File    ${CURDIR}/../results/test_report.json    ${json_string}