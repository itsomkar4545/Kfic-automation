*** Settings ***
Documentation    Common Keywords shared across all Service Request tests
Library          SeleniumLibrary
Library          OperatingSystem
Library          Collections
Library          String
Library          ../utils/excel_reader.py
Resource         ../config/environment.robot
Resource         service_request_page.robot

*** Keywords ***
Read Customer Search Data From Excel
    [Arguments]    ${excel_path}
    ${data}=    Read Excel Data    ${excel_path}
    RETURN    ${data}

Login To Application
    [Arguments]    ${username}    ${password}
    ${relogin_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    id=relogin    timeout=2s
    Run Keyword If    ${relogin_present}    Click Element    id=relogin
    Wait Until Element Is Visible    id=loginId    timeout=15s
    Input Text    id=loginId    ${username}
    Input Text    id=uiPwd    ${password}
    Click Element    id=userLogin
    Sleep    3s

Navigate To Service Request Menu
    [Arguments]    ${service_xpath}
    Click Element    xpath=//a[@class='item-nav'][@data-original-title='Menu']
    Sleep    1s
    Click Element    ${XPATH_SERVICE_MENU}
    Sleep    1s
    Click Element    ${XPATH_SERVICE_REQUEST_SUBMENU}
    Sleep    1s
    Click Element    ${service_xpath}
    Sleep    2s

Search And Select Customer
    [Arguments]    ${customer_id}
    Wait Until Element Is Visible    ${XPATH_CUSTOMER_ID_INPUT}    timeout=15s
    Click Element       ${XPATH_CUSTOMER_ID_INPUT}
    Clear Element Text  ${XPATH_CUSTOMER_ID_INPUT}
    Input Text    ${XPATH_CUSTOMER_ID_INPUT}    ${customer_id}
    # Validate customer ID input
    ${actual_cif}=    Get Element Attribute    ${XPATH_CUSTOMER_ID_INPUT}    value
    Should Be Equal As Strings    ${actual_cif}    ${customer_id}
    ...    msg=VALIDATION FAILED: Customer ID expected '${customer_id}' but got '${actual_cif}'
    Log    ✓ VALIDATED: Customer ID = ${actual_cif}
    Sleep    1s
    Click Element    ${XPATH_SEARCH_BTN}
    Wait Until Element Is Visible    id=customerServiceList    timeout=15s
    Click Element    xpath=//input[@name='cifNo'][@type='radio']
    Click Element    id=okServiceProceed
    Sleep    2s

Select First Account
    Wait Until Element Is Visible    ${XPATH_ACCOUNT_INFO_DIV}    timeout=15s
    Sleep    3s
    Wait Until Element Is Visible    xpath=//input[@type='radio'][@name='accountNumber']    timeout=10s
    Execute JavaScript    document.getElementById('accountNumber1').click()
    Sleep    1s
    # Validate account radio button is selected
    ${is_checked}=    Execute JavaScript    return document.getElementById('accountNumber1').checked
    Should Be True    ${is_checked}
    ...    msg=VALIDATION FAILED: Account radio button not selected
    Log    ✓ VALIDATED: Account radio button selected
    Execute JavaScript    document.getElementById('proceedAccData').click()
    Sleep    3s

Logout From Application
    Click Element    ${XPATH_LOGOUT}
    Sleep    2s

Navigate To Service Request Inbox
    Wait Until Element Is Visible    ${XPATH_SERVICE_REQUEST_INBOX}    timeout=10s
    Click Element    ${XPATH_SERVICE_REQUEST_INBOX}
    Sleep    3s

Open Application By CIF
    [Arguments]    ${cif_number}
    Wait Until Element Is Visible    ${XPATH_INBOX_TABLE}    timeout=15s
    Sleep    2s
    ${row_xpath}=    Set Variable    //table[@id='dt-authdata']//tr[td[contains(text(),'${cif_number}')]]
    Wait Until Element Is Visible    xpath=${row_xpath}    timeout=10s
    Click Element    xpath=${row_xpath}
    Sleep    3s

Approve Application
    Wait Until Element Is Visible    ${XPATH_APPROVE_BTN}    timeout=15s
    Sleep    3s
    Click Element    ${XPATH_APPROVE_BTN}
    Sleep    3s

Close Application
    Wait Until Element Is Visible    ${XPATH_CLOSE_BTN}    timeout=15s
    Sleep    3s
    Click Element    ${XPATH_CLOSE_BTN}
    Sleep    3s

Send For Verification
    Wait Until Element Is Visible    ${XPATH_SEND_FOR_VERIFICATION_BTN}    timeout=10s
    Sleep    2s
    Execute JavaScript    document.querySelector("li#NextSR a").click();
    Sleep    2s

Fill Move To Next Form
    [Arguments]    ${manager_user}
    Select From List By Value    id=assignUser    ${manager_user}
    Sleep    1s
    Input Text    ${XPATH_MAKER_REMARKS}    send for verification to Manager
    Sleep    1s
    Click Element    ${XPATH_MOVE_TO_NEXT_SUBMIT}
    Sleep    3s

Open Browser And Setup
    [Arguments]    ${url}=${LOS_QC_URL}
    Open Browser    ${url}    chrome
    Maximize Browser Window
    Execute JavaScript    document.body.style.zoom='75%'
    Set Selenium Implicit Wait    10

Maker Creates Service Request
    [Arguments]    ${login_id}    ${password}    ${service_xpath}    ${excel_path}
    Login To Application    ${login_id}    ${password}
    Navigate To Service Request Menu    ${service_xpath}
    ${data}=    Read Customer Search Data From Excel    ${excel_path}
    ${customer_id}=    Get From Dictionary    ${data}    Customer ID
    Set Global Variable    ${CUSTOMER_ID}    ${customer_id}
    Search And Select Customer    ${customer_id}
    Select First Account
