*** Settings ***
Documentation    Login Test Following Framework Structure
Library          SeleniumLibrary
Resource         ../pages/base_page.robot
Resource         ../pages/login_page.robot
Resource         ../utils/data_utils.robot
Resource         ../config/environment.robot

*** Test Cases ***
TC001_Login_Test
    [Documentation]    Login test using framework structure
    [Tags]    login    smoke
    
    # Use framework utilities
    ${user_data}=    Get User Data By Environment    admin
    
    # Use framework structure
    Open Application
    Login To Application    ${user_data['username']}    ${user_data['password']}
    
    # Validate login success
    ${current_url}=    Get Location
    Should Not Contain    ${current_url}    LoginPage    Login Failed
    
    Close Application