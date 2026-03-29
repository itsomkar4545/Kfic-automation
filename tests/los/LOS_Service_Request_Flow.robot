*** Settings ***
Documentation    Service Request Flow with Customer Search
Library          SeleniumLibrary
Library          Collections
Library          ../../utils/excel_reader.py
Resource         ../../config/environment.robot
Resource         ../../pages/service_request_page.robot

*** Variables ***
${LOGIN_ID}      admin
${PASSWORD}      admin123

*** Test Cases ***
Service Request Flow
    [Documentation]    Complete service request with customer search
    [Tags]    service_request
    
    Open Browser    ${LOS_QC_URL}    chrome
    Maximize Browser Window
    Set Selenium Implicit Wait    10
    
    # Login
    ${relogin_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    id=relogin    timeout=2s
    Run Keyword If    ${relogin_present}    Click Element    id=relogin
    
    Wait Until Element Is Visible    id=loginId    timeout=15s
    Input Text    id=loginId    ${LOGIN_ID}
    Input Text    id=uiPwd    ${PASSWORD}
    Click Element    id=userLogin
    Sleep    3s
    
    # Navigate to Service Request
    Click Element    ${XPATH_SERVICE_REQUEST_MENU}
    Sleep    2s
    
    # Customer Search
    Search Customer From Excel
    
    # Select Account
    Select Loan Account
    
    # Proceed
    Click Element    ${XPATH_PROCEED_BTN}
    Sleep    2s
    
    Log    Service request flow completed
    Close Browser

*** Keywords ***
Read Service Request Data
    [Documentation]    Reads data from Excel file
    ${excel_path}=    Set Variable    ${CURDIR}/../../data/service_request_input.xlsx
    ${data}=    Read Excel Data    ${excel_path}
    RETURN    ${data}

Search Customer From Excel
    [Documentation]    Search customer using Excel data
    ${data}=    Read Service Request Data
    
    # Customer ID
    ${customer_id}=    Get From Dictionary    ${data}    Customer_ID    default=${EMPTY}
    Run Keyword If    '${customer_id}' != '${EMPTY}'
    ...    Input Text    ${XPATH_CUSTOMER_ID_INPUT}    ${customer_id}
    
    # Customer Name
    ${customer_name}=    Get From Dictionary    ${data}    Customer_Name    default=${EMPTY}
    Run Keyword If    '${customer_name}' != '${EMPTY}'
    ...    Input Text    ${XPATH_CUSTOMER_NAME_INPUT}    ${customer_name}
    
    # Account Number
    ${account_no}=    Get From Dictionary    ${data}    Account_No    default=${EMPTY}
    Run Keyword If    '${account_no}' != '${EMPTY}'
    ...    Input Text    ${XPATH_ACCOUNT_NO_INPUT}    ${account_no}
    
    # National ID Type
    ${id_type}=    Get From Dictionary    ${data}    National_ID_Type    default=${EMPTY}
    Run Keyword If    '${id_type}' != '${EMPTY}'
    ...    Select National ID Type    ${id_type}
    
    # National ID
    ${national_id}=    Get From Dictionary    ${data}    National_ID    default=${EMPTY}
    Run Keyword If    '${national_id}' != '${EMPTY}'
    ...    Input Text    ${XPATH_NATIONAL_ID_INPUT}    ${national_id}
    
    # Mobile Number
    ${mobile}=    Get From Dictionary    ${data}    Mobile_No    default=${EMPTY}
    Run Keyword If    '${mobile}' != '${EMPTY}'
    ...    Input Text    ${XPATH_MOBILE_INPUT}    ${mobile}
    
    # Email
    ${email}=    Get From Dictionary    ${data}    Email_ID    default=${EMPTY}
    Run Keyword If    '${email}' != '${EMPTY}'
    ...    Input Text    ${XPATH_EMAIL_INPUT}    ${email}
    
    # Search
    Click Element    ${XPATH_SEARCH_BTN}
    Sleep    3s

Select National ID Type
    [Arguments]    ${id_type}
    Click Element    ${XPATH_NATIONAL_ID_TYPE_DROPDOWN}
    Sleep    1s
    Click Element    xpath=//li[text()='${id_type}']
    Sleep    1s

Select Loan Account
    [Documentation]    Select first available loan account
    Wait Until Element Is Visible    ${XPATH_ACCOUNT_RADIO_BTN}    timeout=10s
    Click Element    ${XPATH_ACCOUNT_RADIO_BTN}
    Sleep    1s
