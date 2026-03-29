*** Settings ***
Documentation    Login Page Object for KFIC Application
Resource         base_page.robot

*** Variables ***
# Login Page Locators - Updated for actual KFIC page
${USERNAME_FIELD}     id=loginId
${PASSWORD_FIELD}     id=uiPwd
${LOGIN_BUTTON}       id=userLogin
${RELOGIN_BUTTON}     id=relogin
${FORGOT_PASSWORD}    id=forgetPassword
${LOGIN_ERROR}        xpath=//div[contains(@class,'alert') or contains(@class,'error')]

*** Keywords ***
Enter Username
    [Documentation]    Enters username in the login field
    [Arguments]    ${username}
    Wait For Element And Input Text    ${USERNAME_FIELD}    ${username}

Enter Password
    [Documentation]    Enters password in the login field
    [Arguments]    ${password}
    Wait For Element And Input Text    ${PASSWORD_FIELD}    ${password}

Click Login Button
    [Documentation]    Clicks the login button
    Wait For Element And Click    ${LOGIN_BUTTON}
    Wait For Loading To Complete

Login To Application
    [Documentation]    Complete login process with Re-Login handling
    [Arguments]    ${username}    ${password}
    Handle Re-Login If Present
    Enter Username    ${username}
    Enter Password    ${password}
    Click Login Button
    Wait For Page Load

Handle Re-Login If Present
    [Documentation]    Handles Re-Login button if it appears
    ${relogin_present}=    Run Keyword And Return Status    Element Should Be Visible    ${RELOGIN_BUTTON}
    Run Keyword If    ${relogin_present}    Click Element    ${RELOGIN_BUTTON}
    Run Keyword If    ${relogin_present}    Wait For Page Load

Verify Login Error
    [Documentation]    Verifies login error message
    [Arguments]    ${expected_error}
    Wait Until Element Is Visible    ${LOGIN_ERROR}    timeout=10s
    Element Should Contain    ${LOGIN_ERROR}    ${expected_error}

Click Forgot Password
    [Documentation]    Clicks forgot password link
    Wait For Element And Click    ${FORGOT_PASSWORD}

Check Remember Me
    [Documentation]    Checks the remember me checkbox
    Wait For Element And Click    ${REMEMBER_ME}