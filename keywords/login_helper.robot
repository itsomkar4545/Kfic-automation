*** Keywords ***
Login With Popup Handler
    [Documentation]    Login and handle change password popup
    Wait Until Element Is Visible    id=loginId    timeout=15s
    Input Text    id=loginId    ${LOGIN_ID}
    Input Text    id=uiPwd    ${PASSWORD}
    Click Element    id=userLogin
    Sleep    3s
    
    # Handle Change Password Popup
    ${popup_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    xpath=//button[text()='OK']    timeout=3s
    Run Keyword If    ${popup_present}    Click Element    xpath=//button[text()='OK']
    Sleep    1s
