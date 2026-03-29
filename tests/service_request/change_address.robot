*** Settings ***
Documentation    Change Address Service Request
Library          SeleniumLibrary
Library          OperatingSystem
Library          Collections
Library          String
Library          ../../utils/excel_reader.py
Library          ../../utils/address_reader.py
Resource         ../../config/environment.robot
Resource         ../../pages/service_request_page.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${DOCUMENT_FOLDER}    C:\\Users\\omkar.patil\\OneDrive - KIYA.AI\\Desktop\\Omkar\\Customer ID Proof
${CUSTOMER_ID}   ${EMPTY}
${SELECTED_MANAGER_USER}    ${EMPTY}

# Mapping dictionaries for dropdown values
&{ADDRESS_TYPE_MAP}    RESIDENTIAL ADDRESS=1    PERMANENT ADDRESS=4    BUSINESS ADDRESS=6
&{CUST_TYPE_MAP}       Main Applicant=101    Guarantor=103    Joint Applicant=102
&{STATUS_MAP}          Active=1    InActive=2
&{AREA_MAP}            ABDULLA AL-SALEM=3    SALMIYA=103    JABRIYA=115    HAWALLI=114    KHALDIYA=140    AHMADI=139    FAHAHEEL=128    MANGAF=123    JAHRA=116
&{UNIT_TYPE_MAP}       Apartment=1    Villa=2
&{ID_TYPE_MAP}         CIVIL ID Number=20001    Passport Number=20002

# Address type label mapping (used to find existing row in table)
&{ADDR_LABEL_MAP}      RESIDENTIAL=RESIDENTIAL ADDRESS    PERMANENT=PERMANENT ADDRESS    BUSINESS=BUSINESS ADDRESS

*** Test Cases ***
Change Address Request
    [Documentation]    Service request for address change - handles Create and Edit actions
    [Tags]    change_address
    [Teardown]    Run Keyword If Test Failed    Sleep    10s

    Open Browser    ${LOS_QC_URL}    chrome
    Maximize Browser Window
    Execute JavaScript    document.body.style.zoom='75%'
    Set Selenium Implicit Wait    10

    # Step 1-7: Maker creates/edits addresses and sends for verification
    Login To Application    ${LOGIN_ID}    ${PASSWORD}
    Navigate To Service Request
    Search Customer
    Select Account
    Process Address Changes
    
    # Step 8: Logout Maker
    Logout From Application
    Sleep    2s
    
    # Step 9-12: Manager approves the application
    Login To Application    ${SELECTED_MANAGER_USER}    ${PASSWORD}
    Navigate To Service Request Inbox
    Open Application By CIF    ${CUSTOMER_ID}
    Approve Application
    
    # Step 13: Logout Manager
    Logout From Application
    Sleep    2s
    
    # Step 14-17: Maker closes the application
    Login To Application    ${LOGIN_ID}    ${PASSWORD}
    Navigate To Service Request Inbox
    Open Application By CIF    ${CUSTOMER_ID}
    Close Application

    Close Browser

*** Keywords ***
Read Customer Search Data
    ${excel_path}=    Set Variable    ${CURDIR}/../../data/customer_search.xlsx
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
    Log    Logged in as: ${username}

Navigate To Service Request
    Click Element    xpath=//a[@class='item-nav'][@data-original-title='Menu']
    Sleep    1s
    Click Element    ${XPATH_SERVICE_MENU}
    Sleep    1s
    Click Element    ${XPATH_SERVICE_REQUEST_SUBMENU}
    Sleep    1s
    Click Element    ${XPATH_CHANGE_ADDRESS}
    Sleep    2s

Search Customer
    ${data}=    Read Customer Search Data

    Wait Until Element Is Visible    ${XPATH_CUSTOMER_ID_INPUT}    timeout=15s
    Click Element       ${XPATH_CUSTOMER_ID_INPUT}
    Clear Element Text  ${XPATH_CUSTOMER_ID_INPUT}
    ${customer_id}=    Get From Dictionary    ${data}    Customer ID
    Set Global Variable    ${CUSTOMER_ID}    ${customer_id}
    Input Text    ${XPATH_CUSTOMER_ID_INPUT}    ${customer_id}
    Sleep    1s

    Click Element    ${XPATH_SEARCH_BTN}
    Wait Until Element Is Visible    id=customerServiceList    timeout=15s
    Click Element    xpath=//input[@name='cifNo'][@type='radio']
    Click Element    id=okServiceProceed
    Sleep    2s

Select Account
    Wait Until Element Is Visible    ${XPATH_ACCOUNT_INFO_DIV}    timeout=15s
    Sleep    3s
    Wait Until Element Is Visible    xpath=//input[@type='radio'][@name='accountNumber']    timeout=10s
    Execute JavaScript    document.getElementById('accountNumber1').click()
    Sleep    1s
    Execute JavaScript    document.getElementById('proceedAccData').click()
    Sleep    3s

# ─────────────────────────────────────────────
# PROCESS ALL ADDRESS SECTIONS
# ─────────────────────────────────────────────
Process Address Changes
    # Wait for iframe to appear and load after Select Account
    Wait Until Element Is Visible    xpath=//iframe[@id='viewChangeAddressFrame']    timeout=20s
    Sleep    3s
    Select Frame    id=viewChangeAddressFrame
    Sleep    2s
    ${excel_path}=    Set Variable    ${CURDIR}/../../data/change_address.xlsx
    ${addresses}=    Read Address Sections    ${excel_path}
    
    Log To Console    \n=== DEBUG: All addresses read from Excel ==="
    Log To Console    ${addresses}

    FOR    ${addr_type}    IN    RESIDENTIAL    PERMANENT    BUSINESS
        ${addr_data}=    Get From Dictionary    ${addresses}    ${addr_type}
        Log To Console    \n=== DEBUG: Processing ${addr_type} ==="
        Log To Console    Address Data: ${addr_data}
        ${has_data}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${addr_data}    Action
        Log To Console    Has Action Key: ${has_data}
        Run Keyword If    ${has_data}    Route Address Action    ${addr_type}    ${addr_data}
    END

    # Send for Verification - Common for all addresses
    Sleep    2s
    Send For Verification

Route Address Action
    [Arguments]    ${addr_type}    ${data}
    ${action}=    Get From Dictionary    ${data}    Action
    Run Keyword If    '${action}' == 'Create'    Create Address Section    ${data}
    ...    ELSE IF    '${action}' == 'Edit'    Edit Address Section    ${addr_type}    ${data}
    ...    ELSE    Log    Skipping ${addr_type} - Action is '${action}'

# ─────────────────────────────────────────────
# CREATE SECTION
# ─────────────────────────────────────────────
Create Address Section
    [Arguments]    ${data}
    Log    === CREATE: Starting new address record ===

    # 1. Customer Type
    ${cust_type_name}=    Get From Dictionary    ${data}    Customer_Type
    ${cust_type_val}=     Get From Dictionary    ${CUST_TYPE_MAP}    ${cust_type_name}
    Select2 Dropdown    custType    ${cust_type_val}    ${cust_type_name}
    Validate Select2 Value    custType    ${cust_type_name}

    # 2. Get Details button
    Click Element    ${XPATH_FETCH_CUST_DETAILS}
    Sleep    2s

    # 3. Address Type
    ${addr_type_name}=    Get From Dictionary    ${data}    Address_Type
    ${addr_type_val}=     Get From Dictionary    ${ADDRESS_TYPE_MAP}    ${addr_type_name}
    Select2 Dropdown    addressType    ${addr_type_val}    ${addr_type_name}
    Validate Select2 Value    addressType    ${addr_type_name}

    # 4. Status (Active/InActive)
    ${status_name}=    Get From Dictionary    ${data}    Status
    ${status_val}=     Get From Dictionary    ${STATUS_MAP}    ${status_name}
    Select2 Dropdown    activeInActiveType    ${status_val}    ${status_name}
    Validate Select2 Value    activeInActiveType    ${status_name}

    # 5. Living Since
    ${living_since}=    Get From Dictionary    ${data}    Living_Since
    Run Keyword If    '${living_since}' != 'None' and '${living_since}' != ''
    ...    Set Date Field    ${XPATH_ADDRESS_START_DATE}    ${living_since}
    Sleep    1s

    # 6. Country - always Kuwait
    Select2 Dropdown    country    KWT    KUWAIT
    Validate Select2 Value    country    KUWAIT
    Sleep    2s

    # 7. District
    ${district}=    Get From Dictionary    ${data}    District
    Run Keyword If    '${district}' != '' and '${district}' != 'None'
    ...    Select2 Dropdown By Label    district    ${district}
    Run Keyword If    '${district}' != '' and '${district}' != 'None'
    ...    Validate Select2 Value    district    ${district}
    Sleep    1s

    # 8. Area
    ${area_name}=    Get From Dictionary    ${data}    Area
    ${area_val}=     Get From Dictionary    ${AREA_MAP}    ${area_name}
    Select2 Dropdown    area    ${area_val}    ${area_name}
    Validate Select2 Value    area    ${area_name}

    # 9. Block
    Click Element       ${XPATH_BLOCK}
    Clear Element Text  ${XPATH_BLOCK}
    Input Text          ${XPATH_BLOCK}    ${data}[Block]
    Validate Text Field    block    ${data}[Block]
    Sleep    1s

    # 10. Street
    Click Element       ${XPATH_STREET}
    Clear Element Text  ${XPATH_STREET}
    Input Text          ${XPATH_STREET}    ${data}[Street]
    Validate Text Field    street    ${data}[Street]
    Sleep    1s

    # 11. Building
    Click Element       ${XPATH_BUILDING}
    Clear Element Text  ${XPATH_BUILDING}
    Input Text          ${XPATH_BUILDING}    ${data}[Building]
    Validate Text Field    building    ${data}[Building]
    Sleep    1s

    # 12. Unit Type
    ${unit_type_name}=    Get From Dictionary    ${data}    Unit_Type
    ${unit_type_val}=     Get From Dictionary    ${UNIT_TYPE_MAP}    ${unit_type_name}
    Select2 Dropdown    unitType    ${unit_type_val}    ${unit_type_name}
    Validate Select2 Value    unitType    ${unit_type_name}

    # 13. Unit No
    Click Element       ${XPATH_UNIT_NO}
    Clear Element Text  ${XPATH_UNIT_NO}
    Input Text          ${XPATH_UNIT_NO}    ${data}[Unit_No]
    Validate Text Field    unitNo    ${data}[Unit_No]
    Sleep    1s

    # 14. Floor
    Click Element       ${XPATH_FLOOR}
    Clear Element Text  ${XPATH_FLOOR}
    Input Text          ${XPATH_FLOOR}    ${data}[Floor]
    Validate Text Field    floor    ${data}[Floor]
    Sleep    1s

    # 15. Upload Document
    Upload Random Document
    Sleep    2s

    # 16. Save
    Click Element    ${XPATH_SAVE_BTN}
    Sleep    3s
    Log    === CREATE: Address record saved successfully ===

# ─────────────────────────────────────────────
# EDIT SECTION
# ─────────────────────────────────────────────
Edit Address Section
    [Arguments]    ${addr_type}    ${data}
    Log    === EDIT: Looking for existing ${addr_type} address record ===

    ${addr_label}=      Get From Dictionary    ${ADDR_LABEL_MAP}    ${addr_type}
    ${edit_btn_xpath}=  Set Variable
    ...    //table//tr[td[contains(normalize-space(text()),'${addr_label}')]]//a[contains(@class,'editBtn')]

    ${edit_btn_exists}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    xpath=${edit_btn_xpath}    timeout=5s

    Run Keyword Unless    ${edit_btn_exists}
    ...    Log    WARNING: No existing record found for ${addr_type}, skipping edit

    Run Keyword If    ${edit_btn_exists}    Run Keywords
    ...    Execute JavaScript    var elem = document.evaluate("${edit_btn_xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; if(elem) elem.scrollIntoView({block: 'center'});    AND
    ...    Sleep            1s                         AND
    ...    Click Element    xpath=${edit_btn_xpath}    AND
    ...    Sleep            2s                         AND
    ...    Edit Address Form Fields    ${data}         AND
    ...    Upload Random Document                      AND
    ...    Sleep            2s                         AND
    ...    Click Element    ${XPATH_SAVE_BTN}          AND
    ...    Sleep            3s                         AND
    ...    Log              === EDIT: ${addr_type} address updated successfully ===

# ─────────────────────────────────────────────
# EDIT: FILL ADDRESS FORM FIELDS (for Edit only)
# ─────────────────────────────────────────────
Edit Address Form Fields
    [Arguments]    ${data}

    # Handle any pending alerts before starting
    Sleep    0.5s
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present    timeout=1s
    Run Keyword If    ${alert_present}    Handle Alert    ACCEPT
    Sleep    0.5s

    # 1. Living Since - Clear and fill
    ${living_since}=    Get From Dictionary    ${data}    Living_Since
    Run Keyword If    '${living_since}' != 'None' and '${living_since}' != ''
    ...    Set Date Field    ${XPATH_ADDRESS_START_DATE}    ${living_since}
    Sleep    1s

    # 2. Country - always Kuwait (Select2 will replace existing)
    Select2 Dropdown    country    KWT    KUWAIT
    Validate Select2 Value    country    KUWAIT
    Sleep    2s

    # 3. District - Clear and select new
    ${district}=    Get From Dictionary    ${data}    District
    Run Keyword If    '${district}' != '' and '${district}' != 'None'
    ...    Select2 Dropdown By Label    district    ${district}
    Run Keyword If    '${district}' != '' and '${district}' != 'None'
    ...    Validate Select2 Value    district    ${district}
    Sleep    1s

    # 4. Area - Clear and select new
    ${area_name}=    Get From Dictionary    ${data}    Area
    Run Keyword If    '${area_name}' != '' and '${area_name}' != 'None'
    ...    Select2 Dropdown By Label    area    ${area_name}
    Run Keyword If    '${area_name}' != '' and '${area_name}' != 'None'
    ...    Validate Select2 Value    area    ${area_name}
    Sleep    1s

    # 5. Block - Clear existing data then fill
    Click Element       ${XPATH_BLOCK}
    Sleep    0.3s
    Press Keys          ${XPATH_BLOCK}    CTRL+a
    Press Keys          ${XPATH_BLOCK}    DELETE
    Sleep    0.3s
    Input Text          ${XPATH_BLOCK}    ${data}[Block]
    Validate Text Field    block    ${data}[Block]
    Sleep    1s

    # 6. Street - Clear existing data then fill
    Click Element       ${XPATH_STREET}
    Sleep    0.3s
    Press Keys          ${XPATH_STREET}    CTRL+a
    Press Keys          ${XPATH_STREET}    DELETE
    Sleep    0.3s
    Input Text          ${XPATH_STREET}    ${data}[Street]
    Validate Text Field    street    ${data}[Street]
    Sleep    1s

    # 7. Building - Clear existing data then fill
    Click Element       ${XPATH_BUILDING}
    Sleep    0.3s
    Press Keys          ${XPATH_BUILDING}    CTRL+a
    Press Keys          ${XPATH_BUILDING}    DELETE
    Sleep    0.3s
    Input Text          ${XPATH_BUILDING}    ${data}[Building]
    Validate Text Field    building    ${data}[Building]
    Sleep    1s

    # 8. Unit Type - Select2 will replace existing
    ${unit_type_name}=    Get From Dictionary    ${data}    Unit_Type
    ${unit_type_val}=     Get From Dictionary    ${UNIT_TYPE_MAP}    ${unit_type_name}
    Select2 Dropdown    unitType    ${unit_type_val}    ${unit_type_name}
    Validate Select2 Value    unitType    ${unit_type_name}
    Sleep    1s

    # Handle alert after Unit Type selection if it appears
    ${alert_present2}=    Run Keyword And Return Status    Alert Should Be Present    timeout=1s
    Run Keyword If    ${alert_present2}    Handle Alert    ACCEPT
    Sleep    0.5s

    # 9. Unit No - Clear existing data then fill
    Click Element       ${XPATH_UNIT_NO}
    Sleep    0.3s
    Press Keys          ${XPATH_UNIT_NO}    CTRL+a
    Press Keys          ${XPATH_UNIT_NO}    DELETE
    Sleep    0.3s
    Input Text          ${XPATH_UNIT_NO}    ${data}[Unit_No]
    Validate Text Field    unitNo    ${data}[Unit_No]
    Sleep    1s

    # 10. Floor - Clear existing data then fill
    Click Element       ${XPATH_FLOOR}
    Sleep    0.3s
    Press Keys          ${XPATH_FLOOR}    CTRL+a
    Press Keys          ${XPATH_FLOOR}    DELETE
    Sleep    0.3s
    Input Text          ${XPATH_FLOOR}    ${data}[Floor]
    Validate Text Field    floor    ${data}[Floor]
    Sleep    1s

# ─────────────────────────────────────────────
# VALIDATION HELPERS
# ─────────────────────────────────────────────
Validate Text Field
    [Arguments]    ${field_id}    ${expected_value}
    ${actual_value}=    Get Element Attribute    id=${field_id}    value
    ${expected_str}=    Convert To String    ${expected_value}
    Should Be Equal As Strings    ${actual_value}    ${expected_str}
    ...    msg=VALIDATION FAILED: Field '${field_id}' expected '${expected_str}' but got '${actual_value}'
    Log    ✓ VALIDATED: ${field_id} = ${actual_value}

Validate Select2 Value
    [Arguments]    ${field_id}    ${expected_label}
    ${actual_text}=    Get Text    xpath=//span[@id='select2-${field_id}-container']
    ${expected_upper}=    Convert To Upper Case    ${expected_label}
    ${actual_upper}=     Convert To Upper Case    ${actual_text}
    Should Contain    ${actual_upper}    ${expected_upper}
    ...    msg=VALIDATION FAILED: Dropdown '${field_id}' expected '${expected_label}' but got '${actual_text}'
    Log    ✓ VALIDATED: ${field_id} = ${actual_text}

# ─────────────────────────────────────────────
# DOCUMENT UPLOAD HELPER
# Uploads a random document from the folder
# ─────────────────────────────────────────────
Upload Random Document
    # Get list of files from document folder
    @{files}=    List Files In Directory    ${DOCUMENT_FOLDER}
    ${file_count}=    Get Length    ${files}
    
    # Select a random file
    ${random_index}=    Evaluate    random.randint(0, ${file_count}-1)    modules=random
    ${selected_file}=    Set Variable    ${files}[${random_index}]
    ${file_path}=    Set Variable    ${DOCUMENT_FOLDER}\\${selected_file}
    
    Log    Uploading document: ${selected_file}
    
    # Upload the file
    Choose File    ${XPATH_DOCUMENT_DATA}    ${file_path}
    Sleep    1s

# ─────────────────────────────────────────────
# DATE FIELD HELPER
# Types date in DD-MM-YYYY format directly
# ─────────────────────────────────────────────
Set Date Field
    [Arguments]    ${field_xpath}    ${date_value}
    
    # Handle different date formats and convert to DD-MM-YYYY
    ${date_str}=    Convert To String    ${date_value}
    
    # Check if date contains / or -
    ${has_slash}=    Run Keyword And Return Status    Should Contain    ${date_str}    /
    ${has_dash}=    Run Keyword And Return Status    Should Contain    ${date_str}    -
    
    # Split based on delimiter
    Run Keyword If    ${has_slash}    Set Test Variable    ${separator}    /
    ...    ELSE IF    ${has_dash}    Set Test Variable    ${separator}    -
    ...    ELSE    Fail    Date format not recognized: ${date_str}
    
    # Parse date parts
    ${date_parts}=    Split String    ${date_str}    ${separator}
    ${parts_count}=    Get Length    ${date_parts}
    
    # Handle DD/MM/YYYY or DD-MM-YYYY format
    Run Keyword If    ${parts_count} >= 3    Set Test Variable    ${day}    ${date_parts}[0]
    Run Keyword If    ${parts_count} >= 3    Set Test Variable    ${month}    ${date_parts}[1]
    Run Keyword If    ${parts_count} >= 3    Set Test Variable    ${year}    ${date_parts}[2]
    
    # Handle YYYY-MM-DD format
    ${year_length}=    Get Length    ${date_parts}[0]
    Run Keyword If    ${year_length} == 4    Set Test Variable    ${year}    ${date_parts}[0]
    Run Keyword If    ${year_length} == 4    Set Test Variable    ${month}    ${date_parts}[1]
    Run Keyword If    ${year_length} == 4    Set Test Variable    ${day}    ${date_parts}[2]
    
    # Format as DD-MM-YYYY
    ${formatted_date}=    Set Variable    ${day}-${month}-${year}
    
    # Scroll element into view using JavaScript with proper element locator
    Execute JavaScript    var elem = document.evaluate("//div[@id='addressStartDateDiv']//input[@id='addressStartDate']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; if(elem) elem.scrollIntoView({block: 'center'});
    Sleep    0.5s
    
    # Click field to focus
    Click Element    ${field_xpath}
    Sleep    0.3s
    
    # Clear existing date using JavaScript
    Execute JavaScript    document.getElementById('addressStartDate').value = ''
    Sleep    0.3s
    
    # Handle validation alert if it appears after clearing
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present    timeout=1s
    Run Keyword If    ${alert_present}    Handle Alert    ACCEPT
    Sleep    0.3s
    
    # Click field again to focus after alert
    Click Element    ${field_xpath}
    Sleep    0.3s
    
    # Input the formatted date
    Input Text    ${field_xpath}    ${formatted_date}
    Sleep    0.5s
    
    # Handle any alert that appears after input
    ${alert_present2}=    Run Keyword And Return Status    Alert Should Be Present    timeout=1s
    Run Keyword If    ${alert_present2}    Handle Alert    ACCEPT
    
    # Click outside to close any date picker
    Press Keys    None    ESCAPE
    Sleep    0.5s

# ─────────────────────────────────────────────
# SELECT2 DROPDOWN HELPER
# clicks the visible Select2 placeholder, waits
# for the options list, then selects by value
# ─────────────────────────────────────────────
Select2 Dropdown
    [Arguments]    ${field_id}    ${value}    ${label}
    # Click the visible Select2 rendered span to open dropdown
    Click Element    xpath=//span[@aria-labelledby='select2-${field_id}-container']
    Sleep    1s
    # Select the underlying hidden <select> by value (triggers Select2 update)
    Select From List By Value    id=${field_id}    ${value}
    Sleep    1s

# ─────────────────────────────────────────────
# SELECT2 DROPDOWN BY LABEL
# For fields like District that use text labels
# ─────────────────────────────────────────────
Select2 Dropdown By Label
    [Arguments]    ${field_id}    ${label}
    # Click the visible Select2 rendered span to open dropdown
    Click Element    xpath=//span[@aria-labelledby='select2-${field_id}-container']
    Sleep    1s
    # Select the underlying hidden <select> by visible text
    Select From List By Label    id=${field_id}    ${label}
    Sleep    1s


# ─────────────────────────────────────────────
# SEND FOR VERIFICATION (Page Level Button)
# Common for all address actions
# ─────────────────────────────────────────────
Send For Verification
    Log    === SEND FOR VERIFICATION: Starting process ===
    
    # Switch back to main content (out of iframe)
    Unselect Frame
    Sleep    1s
    
    # Wait for Send for Verification button to be enabled
    Wait Until Element Is Visible    ${XPATH_SEND_FOR_VERIFICATION_BTN}    timeout=10s
    Sleep    2s
    
    # Click Send for Verification button using JavaScript to avoid interception
    Execute JavaScript    document.querySelector("li#NextSR a").click();
    Sleep    2s
    
    # Fill Move to Next form
    Fill Move To Next Form
    Sleep    1s
    
    # Submit the form
    Click Element    ${XPATH_MOVE_TO_NEXT_SUBMIT}
    Sleep    3s
    
    Log    === SEND FOR VERIFICATION: Completed successfully ===

# ─────────────────────────────────────────────
# MOVE TO NEXT: FILL FORM (SEND FOR VERIFICATION)
# ─────────────────────────────────────────────
Fill Move To Next Form
    # 1. Group Name - Already disabled and pre-selected (RSM)
    Log    Group Name is pre-selected and disabled

    # 2. User Name - Select randomly from available users
    @{available_users}=    Create List    USER2    n.wisa    h.aldosari    a.ali
    ${random_index}=    Evaluate    random.randint(0, len(${available_users})-1)    modules=random
    ${selected_user}=    Set Variable    ${available_users}[${random_index}]
    Set Global Variable    ${SELECTED_MANAGER_USER}    ${selected_user}
    Log    Selected user for verification: ${selected_user}
    Select2 Dropdown    assignUser    ${selected_user}    ${selected_user}
    Sleep    1s

    # 3. Maker Remarks - Fixed text
    Input Text    ${XPATH_MAKER_REMARKS}    send for verification to Manager
    Sleep    1s

# ─────────────────────────────────────────────
# LOGOUT
# ─────────────────────────────────────────────
Logout From Application
    Log    === LOGOUT: Starting logout process ===
    Click Element    ${XPATH_LOGOUT}
    Sleep    2s
    Log    === LOGOUT: Completed successfully ===

# ─────────────────────────────────────────────
# NAVIGATE TO SERVICE REQUEST INBOX
# ─────────────────────────────────────────────
Navigate To Service Request Inbox
    Log    === NAVIGATE: Opening Service Request Inbox ===
    Wait Until Element Is Visible    ${XPATH_SERVICE_REQUEST_INBOX}    timeout=10s
    Click Element    ${XPATH_SERVICE_REQUEST_INBOX}
    Sleep    3s
    Log    === NAVIGATE: Service Request Inbox opened ===

# ─────────────────────────────────────────────
# OPEN APPLICATION BY CIF NUMBER
# ─────────────────────────────────────────────
Open Application By CIF
    [Arguments]    ${cif_number}
    Log    === OPEN APPLICATION: Searching for CIF ${cif_number} ===
    
    # Wait for inbox table to load
    Wait Until Element Is Visible    ${XPATH_INBOX_TABLE}    timeout=15s
    Sleep    2s
    
    # Find and click the row with matching CIF number
    ${row_xpath}=    Set Variable    //table[@id='dt-authdata']//tr[td[contains(text(),'${cif_number}')]]
    Wait Until Element Is Visible    xpath=${row_xpath}    timeout=10s
    Click Element    xpath=${row_xpath}
    Sleep    3s
    
    Log    === OPEN APPLICATION: Application opened for CIF ${cif_number} ===

# ─────────────────────────────────────────────
# APPROVE APPLICATION (Manager Action)
# ─────────────────────────────────────────────
Approve Application
    Log    === APPROVE: Starting approval process ===
    
    # Wait for Approve button to be enabled (background color changes from darkgrey to orange)
    Wait Until Element Is Visible    ${XPATH_APPROVE_BTN}    timeout=15s
    Sleep    3s
    
    # Click Approve button
    Click Element    ${XPATH_APPROVE_BTN}
    Sleep    3s
    
    Log    === APPROVE: Application approved successfully ===

# ─────────────────────────────────────────────
# CLOSE APPLICATION (Maker Action)
# ─────────────────────────────────────────────
Close Application
    Log    === CLOSE: Starting close process ===
    
    # Wait for Close button to be enabled (background color changes from darkgrey to orange)
    Wait Until Element Is Visible    ${XPATH_CLOSE_BTN}    timeout=15s
    Sleep    3s
    
    # Click Close button
    Click Element    ${XPATH_CLOSE_BTN}
    Sleep    3s
    
    Log    === CLOSE: Application closed successfully ===
