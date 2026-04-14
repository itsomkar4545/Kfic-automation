*** Settings ***
Documentation    LOS Retail Flow - ⚠️ UPDATE data/retail_flow_input.csv BEFORE RUNNING!
Library          SeleniumLibrary
Library          OperatingSystem
Library          String
Library          Collections
Library          ../../utils/excel_reader.py
Library          ../../utils/arabic_translator.py
Resource         ../../config/environment.robot

*** Variables ***
${LOS_QC_URL}    http://172.21.0.93:6661/finairoLending-1.0.1/LoginPage?tid=139&lang=en
${LOGIN_ID}      user1
# PASSWORD is loaded from environment.robot
${SCREENSHOT_DIR}    ${CURDIR}/../../screenshots

# Relative XPath Variables
${XPATH_NEW_LEAD_BTN}    //a[@class='item-preLead' and @onclick='jsfunctionPreLead()']
${XPATH_ID_TYPE_DROPDOWN}    //span[@class='select2-results']/ul
${XPATH_ID_TYPE_CIVIL}    //li[contains(text(),'Civil ID Number')]
${XPATH_ID_TYPE_PASSPORT}    //li[contains(text(),'Passport Number')]
${XPATH_ID_NUMBER_INPUT}    //input[@id='idNumber']
${XPATH_DEDUP_CHECK_BTN}    //button[@id='search' or contains(text(),'Dedupe Search')]
${XPATH_CUSTOMER_NAME_INPUT}    //input[@id='customerName']
${XPATH_CUSTOMER_NAME_ARABIC_INPUT}    //input[@id='customerNameArabic']
${XPATH_NATIONALITY_CONTAINER}    //span[@id='select2-nationalityId-container']
${XPATH_NATIONALITY_DROPDOWN}    //span[@id='select2-nationalityId-container']/parent::span
${XPATH_EMAIL_INPUT}    //input[@id='email']
${XPATH_MOBILE_INPUT}    //input[@id='mobileNumber']
${XPATH_VERIFY_EMAIL_BTN}    //button[contains(text(),'Verify Email')]
${XPATH_EMAIL_OTP_INPUT}    //input[@id='emailOtp']
${XPATH_VERIFY_EMAIL_OTP_BTN}    //a[contains(text(),'Verify') and contains(@onclick,'email')]
${XPATH_VERIFY_MOBILE_BTN}    //button[contains(text(),'Verify Mobile')]
${XPATH_MOBILE_OTP_INPUT}    //input[@id='mobileOtp']
${XPATH_VERIFY_MOBILE_OTP_BTN}    //a[contains(text(),'Verify') and contains(@onclick,'mobile')]
${XPATH_SAVE_BTN}    //button[text()='Save']
${XPATH_CONVERT_TO_APP_BTN}    //button[text()='Convert to Application']
${XPATH_YES_BTN}    //button[contains(text(), 'Yes')]
${XPATH_SELECT2_SEARCH_FIELD}    //input[@class='select2-search__field']

*** Test Cases ***
# TC001_Login_Test
#     [Documentation]    Login test for LOS
#     [Tags]    login    smoke
#     
#     Log To Console    \n⚠️ WARNING: Have you updated data/retail_flow_input.csv with latest test data? ⚠️
#     Sleep    2s
#     
#     Open Browser    ${LOS_QC_URL}    chrome
#     Maximize Browser Window
#     Set Selenium Implicit Wait    10
#     
#     ${relogin_present}=    Run Keyword And Return Status
#     ...    Wait Until Element Is Visible    id=relogin    timeout=2s
#     Run Keyword If    ${relogin_present}    Click Element    id=relogin
#     
#     Wait Until Element Is Visible    id=loginId    timeout=15s
#     Input Text    id=loginId    ${LOGIN_ID}
#     Input Text    id=uiPwd    ${PASSWORD}
#     Click Element    id=userLogin
#     Sleep    3s
#     
#     ${current_url}=    Get Location
#     Should Not Contain    ${current_url}    LoginPage
#     Log    Login successful
#     
#     Close Browser

TC002_Lead_Creation_To_Application_Conversion
    [Documentation]    Create lead and convert to application
    [Tags]    lead_creation    application_conversion
    
    Open Browser    ${LOS_QC_URL}    chrome    options=add_argument("--disable-popup-blocking");add_experimental_option("excludeSwitches", ["enable-automation"]);set_capability("unhandledPromptBehavior", "accept")
    Maximize Browser Window
    Execute JavaScript    document.body.style.zoom='80%'
    Set Selenium Implicit Wait    10
    
    ${relogin_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    id=relogin    timeout=2s
    Run Keyword If    ${relogin_present}    Click Element    id=relogin
    
    Wait Until Element Is Visible    id=loginId    timeout=15s
    Input Text    id=loginId    ${LOGIN_ID}
    Input Text    id=uiPwd    ${PASSWORD}
    Click Element    id=userLogin
    Sleep    3s
    
    Click Element    ${XPATH_NEW_LEAD_BTN}
    Sleep    2s
    
    Fill Lead Details From CSV
    
    Sleep    2s
    Click Element    ${XPATH_SAVE_BTN}
    Sleep    3s
    
    Click Element    ${XPATH_CONVERT_TO_APP_BTN}
    Sleep    3s
    
    Log    Lead converted to application successfully
    Close Browser

*** Keywords ***
Read Retail Flow Data
    [Documentation]    Reads data from Excel file
    ${excel_path}=    Set Variable    ${CURDIR}/../../data/retail_flow_input.xlsx
    ${data}=    Read Excel Data    ${excel_path}
    Log To Console    \nData read from Excel: ${data}
    Log    Data keys: ${data.keys()}
    RETURN    ${data}


Fill Lead Details From CSV
    [Documentation]    Fills lead form with CSV data
    ${data}=    Read Retail Flow Data
    
    # ID Type - SELECT2 Dropdown
    ${id_type}=    Get From Dictionary    ${data}    ID_Type    default=Civil ID Number
    Fill Select2 Dropdown    idType    ${id_type}
    
    # ID Number
    ${id_number}=    Get From Dictionary    ${data}    ID_Number    default=${EMPTY}
    Run Keyword If    '${id_number}' != '${EMPTY}'    Fill ID Number    ${id_number}
    
    # Dedup Check
    Sleep    2s
    Wait Until Element Is Visible    ${XPATH_DEDUP_CHECK_BTN}    timeout=15s
    Click Element    ${XPATH_DEDUP_CHECK_BTN}
    Sleep    3s
    Fill All Lead Fields    ${data}

Fill ID Type
    [Arguments]    ${id_type}
    Click Element    id=idTypeDiv
    Sleep    1s
    Wait Until Element Is Visible    ${XPATH_ID_TYPE_DROPDOWN}    timeout=5s
    Click Element    xpath=//li[contains(text(),'${id_type}')]
    Sleep    1s

Fill ID Number
    [Arguments]    ${id_number}
    Wait Until Element Is Enabled    ${XPATH_ID_NUMBER_INPUT}    timeout=10s
    Click Element    ${XPATH_ID_NUMBER_INPUT}
    Sleep    1s
    Input Text    ${XPATH_ID_NUMBER_INPUT}    ${id_number}
    Sleep    1s

Fill All Lead Fields
    [Arguments]    ${data}
    
    # Customer Name
    ${customer_name}=    Get From Dictionary    ${data}    Customer_Name
    Fill Customer Name    ${customer_name}
    
    # Nationality
    ${nationality}=    Get From Dictionary    ${data}    Nationality
    Fill Nationality    ${nationality}
    
    # Email
    ${email}=    Get From Dictionary    ${data}    Email
    Fill Email    ${email}
    
    # Mobile Number
    ${mobile}=    Get From Dictionary    ${data}    Mobile_Number
    Fill Mobile    ${mobile}
    
    # Product
    ${product}=    Get From Dictionary    ${data}    Product
    Fill Product    ${product}
    
    # SubProduct
    ${subproduct}=    Get From Dictionary    ${data}    SubProduct
    Fill SubProduct    ${subproduct}
    
    # Verify Email
    Scroll Element Into View    ${XPATH_VERIFY_EMAIL_BTN}
    Click Element    ${XPATH_VERIFY_EMAIL_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Enter Email OTP
    Scroll Element Into View    ${XPATH_EMAIL_OTP_INPUT}
    Input Text    ${XPATH_EMAIL_OTP_INPUT}    123456
    Sleep    1s
    
    # Verify Email OTP
    Click Element    ${XPATH_VERIFY_EMAIL_OTP_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Verify Mobile
    Scroll Element Into View    ${XPATH_VERIFY_MOBILE_BTN}
    Click Element    ${XPATH_VERIFY_MOBILE_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Enter Mobile OTP
    Scroll Element Into View    ${XPATH_MOBILE_OTP_INPUT}
    Input Text    ${XPATH_MOBILE_OTP_INPUT}    123456
    Sleep    1s
    
    # Verify Mobile OTP
    Click Element    ${XPATH_VERIFY_MOBILE_OTP_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    2s
    
    # SubProduct (Dynamic based on Product)
    ${subproduct}=    Get From Dictionary    ${data}    SubProduct
    Fill SubProduct    ${subproduct}
    Sleep    1s
    
    # Verify Email
    Click Element    ${XPATH_VERIFY_EMAIL_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Enter Email OTP
    Input Text    ${XPATH_EMAIL_OTP_INPUT}    123456
    Sleep    1s
    
    # Verify Email OTP
    Click Element    ${XPATH_VERIFY_EMAIL_OTP_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Verify Mobile
    Click Element    ${XPATH_VERIFY_MOBILE_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Enter Mobile OTP
    Input Text    ${XPATH_MOBILE_OTP_INPUT}    123456
    Sleep    1s
    
    # Verify Mobile OTP
    Click Element    ${XPATH_VERIFY_MOBILE_OTP_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    2s

Map Product To Value
    [Documentation]    Maps product name to value
    [Arguments]    ${product_name}
    ${product_map}=    Create Dictionary
    ...    VEHICLE LOAN RETAIL=01
    ...    HOUSING LOAN RETAIL=03
    ...    CONSUMER LOAN RETAIL=04
    ...    LEASING RETAIL=08
    ${value}=    Get From Dictionary    ${product_map}    ${product_name}
    RETURN    ${value}

Handle Duplicate Found Scenario
    [Arguments]    ${data}
    Log    No browser alert - Duplicate found - Handling Yes/No popup
    Sleep    2s
    
    # Handle Yes/No Modal Popup
    ${modal_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${XPATH_YES_BTN}    timeout=3s
    Run Keyword If    ${modal_present}
    ...    Click Element    ${XPATH_YES_BTN}
    Sleep    2s
    
    # Customer Name
    ${customer_name}=    Get From Dictionary    ${data}    Customer_Name
    Scroll Element Into View    ${XPATH_CUSTOMER_NAME_INPUT}
    Wait Until Element Is Enabled    ${XPATH_CUSTOMER_NAME_INPUT}    timeout=10s
    Click Element    ${XPATH_CUSTOMER_NAME_INPUT}
    Sleep    1s
    Input Text    ${XPATH_CUSTOMER_NAME_INPUT}    ${customer_name}
    Sleep    1s
    
    # Customer Name Arabic
    ${arabic_name}=    Translate To Arabic    ${customer_name}
    Wait Until Element Is Enabled    ${XPATH_CUSTOMER_NAME_ARABIC_INPUT}    timeout=10s
    Click Element    ${XPATH_CUSTOMER_NAME_ARABIC_INPUT}
    Sleep    1s
    Input Text    ${XPATH_CUSTOMER_NAME_ARABIC_INPUT}    ${arabic_name}
    Sleep    1s
    
    # Nationality
    ${nationality}=    Get From Dictionary    ${data}    Nationality
    Fill Nationality    ${nationality}
    
    # Email
    ${email}=    Get From Dictionary    ${data}    Email
    Scroll Element Into View    ${XPATH_EMAIL_INPUT}
    Wait Until Element Is Enabled    ${XPATH_EMAIL_INPUT}    timeout=10s
    Click Element    ${XPATH_EMAIL_INPUT}
    Sleep    1s
    Input Text    ${XPATH_EMAIL_INPUT}    ${email}
    Sleep    1s
    
    # Mobile Number
    ${mobile}=    Get From Dictionary    ${data}    Mobile_Number
    Scroll Element Into View    ${XPATH_MOBILE_INPUT}
    Wait Until Element Is Enabled    ${XPATH_MOBILE_INPUT}    timeout=10s
    Click Element    ${XPATH_MOBILE_INPUT}
    Sleep    1s
    Input Text    ${XPATH_MOBILE_INPUT}    ${mobile}
    Sleep    1s
    
    # Product
    ${product}=    Get From Dictionary    ${data}    Product
    Fill Product    ${product}
    
    # SubProduct
    ${subproduct}=    Get From Dictionary    ${data}    SubProduct
    Fill SubProduct    ${subproduct}
    
    # Verify Email
    Scroll Element Into View    ${XPATH_VERIFY_EMAIL_BTN}
    Click Element    ${XPATH_VERIFY_EMAIL_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Enter Email OTP
    Scroll Element Into View    ${XPATH_EMAIL_OTP_INPUT}
    Input Text    ${XPATH_EMAIL_OTP_INPUT}    123456
    Sleep    1s
    
    # Verify Email OTP
    Click Element    ${XPATH_VERIFY_EMAIL_OTP_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Verify Mobile
    Scroll Element Into View    ${XPATH_VERIFY_MOBILE_BTN}
    Click Element    ${XPATH_VERIFY_MOBILE_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Enter Mobile OTP
    Scroll Element Into View    ${XPATH_MOBILE_OTP_INPUT}
    Input Text    ${XPATH_MOBILE_OTP_INPUT}    123456
    Sleep    1s
    
    # Verify Mobile OTP
    Click Element    ${XPATH_VERIFY_MOBILE_OTP_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    2s
    
    # Verify Email
    Click Element    ${XPATH_VERIFY_EMAIL_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Enter Email OTP
    Input Text    ${XPATH_EMAIL_OTP_INPUT}    123456
    Sleep    1s
    
    # Verify Email OTP
    Click Element    ${XPATH_VERIFY_EMAIL_OTP_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Verify Mobile
    Click Element    ${XPATH_VERIFY_MOBILE_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    1s
    
    # Enter Mobile OTP
    Input Text    ${XPATH_MOBILE_OTP_INPUT}    123456
    Sleep    1s
    
    # Verify Mobile OTP
    Click Element    ${XPATH_VERIFY_MOBILE_OTP_BTN}
    Sleep    2s
    Handle Alert    action=ACCEPT
    Sleep    2s

Fill Customer Name
    [Arguments]    ${customer_name}
    Scroll Element Into View    ${XPATH_CUSTOMER_NAME_INPUT}
    Wait Until Element Is Visible    ${XPATH_CUSTOMER_NAME_INPUT}    timeout=10s
    Click Element    ${XPATH_CUSTOMER_NAME_INPUT}
    Sleep    1s
    Input Text    ${XPATH_CUSTOMER_NAME_INPUT}    ${customer_name}
    Sleep    1s
    ${arabic_name}=    Translate To Arabic    ${customer_name}
    Scroll Element Into View    ${XPATH_CUSTOMER_NAME_ARABIC_INPUT}
    Wait Until Element Is Visible    ${XPATH_CUSTOMER_NAME_ARABIC_INPUT}    timeout=10s
    Click Element    ${XPATH_CUSTOMER_NAME_ARABIC_INPUT}
    Sleep    1s
    Input Text    ${XPATH_CUSTOMER_NAME_ARABIC_INPUT}    ${arabic_name}
    Sleep    1s

Fill Nationality
    [Arguments]    ${nationality}
    Scroll Element Into View    id=nationalityId
    Fill Select2 Dropdown    nationalityId    ${nationality}

Fill Email
    [Arguments]    ${email}
    Scroll Element Into View    ${XPATH_EMAIL_INPUT}
    Wait Until Element Is Visible    ${XPATH_EMAIL_INPUT}    timeout=10s
    Click Element    ${XPATH_EMAIL_INPUT}
    Sleep    1s
    Input Text    ${XPATH_EMAIL_INPUT}    ${email}
    Sleep    1s

Fill Mobile
    [Arguments]    ${mobile}
    Scroll Element Into View    ${XPATH_MOBILE_INPUT}
    Wait Until Element Is Visible    ${XPATH_MOBILE_INPUT}    timeout=10s
    Click Element    ${XPATH_MOBILE_INPUT}
    Sleep    1s
    Input Text    ${XPATH_MOBILE_INPUT}    ${mobile}
    Sleep    1s

Fill Product
    [Arguments]    ${product}
    Scroll Element Into View    id=product
    Fill Select2 Dropdown    product    ${product}
    Sleep    1s

Fill SubProduct
    [Arguments]    ${subproduct}
    Scroll Element Into View    id=subProduct
    Fill Select2 Dropdown    subProduct    ${subproduct}

Fill Select2 Dropdown
    [Documentation]    Generic keyword to fill SELECT2 dropdowns by searching and selecting exact match
    [Arguments]    ${element_id}    ${value}
    Wait Until Element Is Visible    id=select2-${element_id}-container    timeout=10s
    Click Element    id=select2-${element_id}-container
    Sleep    1s
    Wait Until Element Is Visible    ${XPATH_SELECT2_SEARCH_FIELD}    timeout=5s
    Input Text    ${XPATH_SELECT2_SEARCH_FIELD}    ${value}
    Sleep    1s
    Press Keys    ${XPATH_SELECT2_SEARCH_FIELD}    RETURN
    Sleep    1s
