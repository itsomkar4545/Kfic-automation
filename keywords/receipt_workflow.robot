*** Settings ***
Documentation    Receipt Management Workflow Keywords
Resource         ../pages/login_page.robot
Resource         ../pages/receipt_management_page.robot
Resource         ../utils/data_utils.robot

*** Keywords ***
Logout From Application
    [Documentation]    Logs out from the application
    Click Element    xpath=//a[text()='Logout']
    Wait For Page Load
Complete Receipt Generation Workflow
    [Documentation]    Completes full receipt generation workflow
    [Arguments]    ${receipt_data}    ${users_data}
    
    # Receipt Generation by Maker
    ${maker_user}=    Get From Dictionary    ${users_data}    maker
    Login To Application    ${maker_user['username']}    ${maker_user['password']}
    Navigate To Receipt Generation
    Fill Receipt Details    ${receipt_data}
    Generate Receipt
    Logout From Application
    
    # Receipt Approval by Checker
    ${checker_user}=    Get From Dictionary    ${users_data}    checker
    Login To Application    ${checker_user['username']}    ${checker_user['password']}
    Navigate To Receipt Generation
    Search And Approve Receipt    ${receipt_data['startReceiptNo']}
    Logout From Application

Generate Receipt Only
    [Documentation]    Generates receipt without approval
    [Arguments]    ${receipt_data}    ${user_data}
    Login To Application    ${user_data['username']}    ${user_data['password']}
    Navigate To Receipt Generation
    Fill Receipt Details    ${receipt_data}
    Generate Receipt
    Logout From Application

Approve Receipt Only
    [Documentation]    Approves existing receipt
    [Arguments]    ${receipt_no}    ${user_data}
    Login To Application    ${user_data['username']}    ${user_data['password']}
    Navigate To Receipt Generation
    Search And Approve Receipt    ${receipt_no}
    Logout From Application