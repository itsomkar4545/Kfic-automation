*** Settings ***
Documentation    Login Test Variants for Parallel Execution
Library          SeleniumLibrary
Resource         ../pages/base_page.robot
Resource         ../pages/login_page.robot
Resource         ../utils/data_utils.robot

*** Test Cases ***
TC006_Login_Test_Variant_A
    [Documentation]    Login test with admin user - variant A
    [Tags]    login    parallel    smoke
    
    ${login_creds}=    Get User Data By Environment    admin
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Verify Login Success
    Sleep    2s
    Close Application

TC007_Login_Test_Variant_B
    [Documentation]    Login test with admin user - variant B
    [Tags]    login    parallel    smoke
    
    ${login_creds}=    Get User Data By Environment    admin
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Verify Login Success
    Sleep    3s
    Close Application

TC008_Login_Test_Variant_C
    [Documentation]    Login test with admin user - variant C
    [Tags]    login    parallel    smoke
    
    ${login_creds}=    Get User Data By Environment    admin
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Verify Login Success
    Sleep    2s
    Close Application