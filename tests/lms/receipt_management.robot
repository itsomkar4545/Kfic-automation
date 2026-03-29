*** Settings ***
Documentation    Receipt Management Test Suite
Resource         ../../keywords/receipt_workflow.robot
Resource         ../../utils/data_utils.robot
Suite Setup      Open Application
Suite Teardown   Close Application
Test Tags        receipt_management    lms

*** Test Cases ***
TC001_Complete_Receipt_Generation_Workflow
    [Documentation]    Test complete receipt generation and approval workflow
    [Tags]    workflow    critical
    ${receipt_data}=    Load Test Data From JSON    receipt_data.json
    ${receipt_info}=    Get From Dictionary    ${receipt_data}    receipt_data
    ${users_data}=    Get From Dictionary    ${receipt_data}    users
    Complete Receipt Generation Workflow    ${receipt_info}    ${users_data}

TC002_Generate_Receipt_Only
    [Documentation]    Test receipt generation only
    [Tags]    generation    smoke
    ${receipt_data}=    Load Test Data From JSON    receipt_data.json
    ${receipt_info}=    Get From Dictionary    ${receipt_data}    receipt_data
    ${maker_user}=    Get From Dictionary    ${receipt_data['users']}    maker
    Generate Receipt Only    ${receipt_info}    ${maker_user}

TC003_Approve_Receipt_Only
    [Documentation]    Test receipt approval only
    [Tags]    approval    smoke
    ${receipt_data}=    Load Test Data From JSON    receipt_data.json
    ${checker_user}=    Get From Dictionary    ${receipt_data['users']}    checker
    ${receipt_no}=    Set Variable    RCP001001
    Approve Receipt Only    ${receipt_no}    ${checker_user}