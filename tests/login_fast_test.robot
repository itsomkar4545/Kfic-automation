*** Settings ***
Documentation    Fast and Clean Login Test for KFIC
Library          SeleniumLibrary
Library          DateTime
Resource         ../config/environment.robot

*** Variables ***
${LOGIN_ID}      infraadmin
${PASSWORD}      Abcd@123

*** Test Cases ***
TC001_Fast_Login_Test
    [Documentation]    Fast login test with validation
    [Tags]    login    fast    smoke
    
    Open Browser    ${URLS.qc}    chrome
    Maximize Browser Window
    Set Selenium Implicit Wait    10
    
    # Handle Re-Login
    ${relogin_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    id=relogin    timeout=2s
    Run Keyword If    ${relogin_present}    Click Element    id=relogin
    
    # Login
    Wait Until Element Is Visible    id=loginId    timeout=15s
    Input Text    id=loginId    ${LOGIN_ID}
    Input Text    id=uiPwd    ${PASSWORD}
    Click Element    id=userLogin
    Sleep    3s
    
    # Validate
    ${current_url}=    Get Location
    Should Not Contain    ${current_url}    LoginPage    Login Failed
    ${title}=    Get Title
    Log    Login successful. Page title: ${title}
    
    Close Browser