*** Settings ***
Documentation    Business Keywords for Lead Creation Workflow
Resource         ../pages/login_page.robot
Resource         ../pages/lead_management_page.robot
Resource         ../utils/data_utils.robot
Library          Collections

*** Keywords ***
Login As User
    [Documentation]    Logs in as specified user
    [Arguments]    ${user_data}
    ${username}=    Get From Dictionary    ${user_data}    username
    ${password}=    Get From Dictionary    ${user_data}    password    default=password123
    Login To Application    ${username}    ${password}

Logout From Application
    [Documentation]    Logs out from the application
    Click Element    xpath=//a[text()='Logout']
    Wait For Page Load

Switch User
    [Documentation]    Switches to different user
    [Arguments]    ${user_data}
    Logout From Application
    Login As User    ${user_data}

Pull Lead From App Pool
    [Documentation]    Pulls a lead from app pool
    [Arguments]    ${lead_id}
    Click App Pool
    Click On Pull    ${lead_id}
    Handle Popup Confirmation

Access Lead From Inbox
    [Documentation]    Accesses lead from inbox
    [Arguments]    ${lead_id}
    Click Inbox
    Click On Lead    ${lead_id}

Complete Credit Approval
    [Documentation]    Completes credit approval process
    [Arguments]    ${lead_id}    ${user_data}
    Access Lead From Inbox    ${lead_id}
    Click Credit Approval Link
    ${remark}=    Get From Dictionary    ${user_data}    remark    default=Credit Approved
    Process Lead Workflow Step    ${remark}

Complete Offer Process
    [Documentation]    Completes offer process
    [Arguments]    ${lead_id}    ${user_data}
    Access Lead From Inbox    ${lead_id}
    Click Offer Link
    ${remark}=    Get From Dictionary    ${user_data}    remark    default=Offer Generated
    Process Lead Workflow Step    ${remark}

Complete Deal Printing
    [Documentation]    Completes deal printing process
    [Arguments]    ${lead_id}    ${user_data}
    Access Lead From Inbox    ${lead_id}
    Click Deal Printing Link
    ${remark}=    Get From Dictionary    ${user_data}    remark    default=Deal Printed
    Process Lead Workflow Step    ${remark}

Complete Document Collection
    [Documentation]    Completes document collection process
    [Arguments]    ${lead_id}    ${user_data}
    Access Lead From Inbox    ${lead_id}
    Click Document Collection Link
    ${remark}=    Get From Dictionary    ${user_data}    remark    default=Documents Collected
    Process Lead Workflow Step    ${remark}

Complete Disbursement
    [Documentation]    Completes disbursement process
    [Arguments]    ${lead_id}    ${user_data}
    Access Lead From Inbox    ${lead_id}
    Click Disbursement Link
    ${remark}=    Get From Dictionary    ${user_data}    remark    default=Amount Disbursed
    Process Lead Workflow Step    ${remark}

Execute Full Lead Workflow
    [Documentation]    Executes complete lead workflow
    [Arguments]    ${lead_data}    ${users_data}
    ${lead_id}=    Get From Dictionary    ${lead_data}    IDNumber
    
    # Credit Approval
    ${credit_user}=    Get From Dictionary    ${users_data}    credit_approver
    Login As User    ${credit_user}
    Pull Lead From App Pool    ${lead_id}
    Complete Credit Approval    ${lead_id}    ${credit_user}
    
    # Offer Process
    ${offer_user}=    Get From Dictionary    ${users_data}    offer_manager
    Switch User    ${offer_user}
    Pull Lead From App Pool    ${lead_id}
    Complete Offer Process    ${lead_id}    ${offer_user}
    
    # Deal Printing
    ${deal_user}=    Get From Dictionary    ${users_data}    deal_manager
    Switch User    ${deal_user}
    Pull Lead From App Pool    ${lead_id}
    Complete Deal Printing    ${lead_id}    ${deal_user}
    
    # Document Collection
    ${doc_user}=    Get From Dictionary    ${users_data}    doc_collector
    Switch User    ${doc_user}
    Pull Lead From App Pool    ${lead_id}
    Complete Document Collection    ${lead_id}    ${doc_user}
    
    # Disbursement
    ${disbursement_user}=    Get From Dictionary    ${users_data}    disbursement_officer
    Switch User    ${disbursement_user}
    Pull Lead From App Pool    ${lead_id}
    Complete Disbursement    ${lead_id}    ${disbursement_user}