*** Settings ***
Documentation    Lead Creation Test Suite for KFIC LOS
Resource         ../../keywords/lead_workflow.robot
Resource         ../../utils/data_utils.robot
Suite Setup      Open Application
Suite Teardown   Close Application
Test Setup       Take Screenshot On Failure
Test Tags        los    lead_creation    smoke

*** Variables ***
${SUITE_NAME}    Lead Creation Tests

*** Test Cases ***
TC001_Create Individual Lead Complete Workflow
    [Documentation]    Test complete workflow for individual lead creation
    [Tags]    individual    workflow    critical
    ${lead_data}=    Get Lead Data    individual
    ${users_data}=    Load Test Data From JSON    users.json
    Execute Full Lead Workflow    ${lead_data}    ${users_data}
    Validate Lead Status In Database    ${lead_data['IDNumber']}    DISBURSED

TC002_Create Corporate Lead Complete Workflow
    [Documentation]    Test complete workflow for corporate lead creation
    [Tags]    corporate    workflow    critical
    ${lead_data}=    Get Lead Data    corporate
    ${users_data}=    Load Test Data From JSON    users.json
    Execute Full Lead Workflow    ${lead_data}    ${users_data}
    Validate Lead Status In Database    ${lead_data['IDNumber']}    DISBURSED

TC003_Credit Approval Only
    [Documentation]    Test credit approval process only
    [Tags]    credit_approval    partial_workflow
    ${lead_data}=    Get Lead Data    individual
    ${credit_user}=    Get User Data    credit_approver
    Login As User    ${credit_user}
    Pull Lead From App Pool    ${lead_data['IDNumber']}
    Complete Credit Approval    ${lead_data['IDNumber']}    ${credit_user}
    Validate Lead Status In Database    ${lead_data['IDNumber']}    CREDIT_APPROVED

TC004_Offer Process Only
    [Documentation]    Test offer process only
    [Tags]    offer    partial_workflow
    ${lead_data}=    Get Lead Data    individual
    ${offer_user}=    Get User Data    offer_manager
    Login As User    ${offer_user}
    Pull Lead From App Pool    ${lead_data['IDNumber']}
    Complete Offer Process    ${lead_data['IDNumber']}    ${offer_user}
    Validate Lead Status In Database    ${lead_data['IDNumber']}    OFFER_GENERATED

TC005_Document Collection Process
    [Documentation]    Test document collection process
    [Tags]    document_collection    partial_workflow
    ${lead_data}=    Get Lead Data    individual
    ${doc_user}=    Get User Data    doc_collector
    Login As User    ${doc_user}
    Pull Lead From App Pool    ${lead_data['IDNumber']}
    Complete Document Collection    ${lead_data['IDNumber']}    ${doc_user}
    Validate Lead Status In Database    ${lead_data['IDNumber']}    DOCUMENTS_COLLECTED

TC006_Disbursement Process
    [Documentation]    Test disbursement process
    [Tags]    disbursement    partial_workflow
    ${lead_data}=    Get Lead Data    individual
    ${disbursement_user}=    Get User Data    disbursement_officer
    Login As User    ${disbursement_user}
    Pull Lead From App Pool    ${lead_data['IDNumber']}
    Complete Disbursement    ${lead_data['IDNumber']}    ${disbursement_user}
    Validate Lead Status In Database    ${lead_data['IDNumber']}    DISBURSED

*** Keywords ***
Suite Setup Actions
    [Documentation]    Actions to perform before suite execution
    Log    Starting ${SUITE_NAME}
    Set Global Variable    ${START_TIME}    ${CURDIR}

Suite Teardown Actions
    [Documentation]    Actions to perform after suite execution
    Log    Completed ${SUITE_NAME}
    Create Test Report Data    ${SUITE_NAME}    COMPLETED    ${CURDIR}