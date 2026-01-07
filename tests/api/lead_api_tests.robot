*** Settings ***
Documentation    API Test Suite for KFIC LOS/LMS
Library          RequestsLibrary
Library          Collections
Library          JSONLibrary
Resource         ../../config/environment.robot
Suite Setup      Create Session    kfic_api    ${API_CONFIG.base_url}
Suite Teardown   Delete All Sessions
Test Tags        api    integration

*** Variables ***
${API_ENDPOINT}    /leads
${AUTH_TOKEN}      Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9

*** Test Cases ***
TC001_Get All Leads
    [Documentation]    Test GET all leads API
    [Tags]    get    leads
    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    kfic_api    ${API_ENDPOINT}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${leads}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${leads}

TC002_Create New Lead
    [Documentation]    Test POST create new lead API
    [Tags]    post    create_lead
    ${lead_data}=    Create Dictionary
    ...    applicantType=Individual
    ...    firstName=John
    ...    lastName=Doe
    ...    email=john.doe@test.com
    ...    phone=+96512345678
    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}    Content-Type=application/json
    ${response}=    POST On Session    kfic_api    ${API_ENDPOINT}    json=${lead_data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    ${created_lead}=    Set Variable    ${response.json()}
    Should Be Equal    ${created_lead['firstName']}    John
    Set Suite Variable    ${CREATED_LEAD_ID}    ${created_lead['id']}

TC003_Get Lead By ID
    [Documentation]    Test GET lead by ID API
    [Tags]    get    lead_by_id
    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    kfic_api    ${API_ENDPOINT}/${CREATED_LEAD_ID}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${lead}=    Set Variable    ${response.json()}
    Should Be Equal    ${lead['id']}    ${CREATED_LEAD_ID}

TC004_Update Lead
    [Documentation]    Test PUT update lead API
    [Tags]    put    update_lead
    ${update_data}=    Create Dictionary    email=john.updated@test.com
    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}    Content-Type=application/json
    ${response}=    PUT On Session    kfic_api    ${API_ENDPOINT}/${CREATED_LEAD_ID}    json=${update_data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${updated_lead}=    Set Variable    ${response.json()}
    Should Be Equal    ${updated_lead['email']}    john.updated@test.com

TC005_Delete Lead
    [Documentation]    Test DELETE lead API
    [Tags]    delete    remove_lead
    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${response}=    DELETE On Session    kfic_api    ${API_ENDPOINT}/${CREATED_LEAD_ID}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    204

TC006_Lead Status Workflow API
    [Documentation]    Test lead status workflow through API
    [Tags]    workflow    status_change
    # Create lead
    ${lead_data}=    Create Dictionary    applicantType=Individual    firstName=Test    lastName=User
    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}    Content-Type=application/json
    ${response}=    POST On Session    kfic_api    ${API_ENDPOINT}    json=${lead_data}    headers=${headers}
    ${lead_id}=    Set Variable    ${response.json()['id']}
    
    # Update status to CREDIT_APPROVED
    ${status_data}=    Create Dictionary    status=CREDIT_APPROVED
    PUT On Session    kfic_api    ${API_ENDPOINT}/${lead_id}/status    json=${status_data}    headers=${headers}
    
    # Verify status
    ${response}=    GET On Session    kfic_api    ${API_ENDPOINT}/${lead_id}    headers=${headers}
    Should Be Equal    ${response.json()['status']}    CREDIT_APPROVED