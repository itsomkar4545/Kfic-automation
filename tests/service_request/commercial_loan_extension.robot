*** Settings ***
Documentation    Commercial Loan Extension Service Request - Standard & Balloon
Library          SeleniumLibrary
Library          OperatingSystem
Library          Collections
Library          String
Library          ../../utils/excel_reader.py
Resource         ../../config/environment.robot
Resource         ../../pages/service_request_page.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD and DOCUMENT_FOLDER are loaded from environment.robot
${CUSTOMER_ID}   ${EMPTY}
${SELECTED_MANAGER_USER}    ${EMPTY}
${TEMP_DOC_PATH}    ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/commercial_loan_extension.xlsx

# Iframe
${IFRAME_LOAN_EXTN}    viewLoanExtnBallonSRFrame

# Grid XPaths
${XPATH_LMS_ROW}    //table[@id='dt-authdata']//tr[td[contains(text(),'LMS')]]
${XPATH_LMS_EDIT_BTN}    //table[@id='dt-authdata']//tr[td[contains(text(),'LMS')]]//a[contains(@class,'editBtn')]

# Form Field IDs
${XPATH_REPAY_CAL_TYPE}    id=repayCalType
${XPATH_NEW_TENURE}    id=newTenure
${XPATH_NEW_INSTALLMENT_TXT}    id=newInstallmentAmount_txt
${XPATH_BORROWER_STATUS}    id=borrowerStatus
${XPATH_SVC_CHARGES_WAIVER_TXT}    id=serviceChargesWaiver_txt
${XPATH_PAYMENT_MODE}    id=paymentMode
${XPATH_REMARKS}    id=remarks
${XPATH_SAVE_LOAN_EXTN}    id=saveLoanExtnBallon

# Repayment Schedule Buttons
${XPATH_NEW_REPAYMENT_BTN}    id=calculateBtn
${XPATH_OLD_REPAYMENT_BTN}    id=repaymentSRBt

# Balloon Field IDs
${XPATH_BALLOON_TYPE}    id=balloonType
${XPATH_BALLOON_FREQUENCY}    id=balloonFrequency
${XPATH_BALLOON_AMOUNT_TXT}    id=balloonAmount_txt
${XPATH_BALLOON_INSTALLMENTS}    id=balloonStartInstall
${XPATH_ADD_BALLOON_BTN}    id=addBalllonbt

# Dropdown Value Maps
&{RESCHEDULE_TYPE_MAP}    Tenure=1    Installment=2
&{BORROWER_STATUS_MAP}    Default=1    Non Default=2
&{PAYMENT_MODE_MAP}    KNet-Kiosk=1    KNet-Web=2    Cash-Cheque=3
&{BALLOON_TYPE_MAP}    Balloon=BL    Regular EMI=EMI
&{BALLOON_FREQ_MAP}    MONTHLY=1    QUARTERLY=2    Half Yearly=3    Yearly=4

# Add Document Field IDs
${XPATH_DOC_GROUP}    id=docGroup
${XPATH_DOC_TYPE}    id=docType
${XPATH_DOC_NUMBER}    id=documentNo
${XPATH_DOC_DESCRIPTION}    id=docDescription
${XPATH_DOC_SUBMISSION_DATE}    id=docSubmissionDate
${XPATH_DOC_STATUS}    id=docStatus
${XPATH_DOC_FILE_INPUT}    id=documentData
${XPATH_SAVE_DOCUMENT}    id=saveDocumentData
${XPATH_CONFIRM_YES}    id=popUpYes

# Add Document Dropdown Maps
&{DOC_GROUP_MAP}    BUSINESS=BUS    BSI Forms=BSI    CINET CONCENT=CINET    EMPLOYMENT=EMP    FINANCE=FIN    LOANKIT=LOANKIT    LOAN ITEM=LOI    LEGAL=LGL    OTHER=OTH    IDENTIFICATION=POI
&{DOC_STATUS_MAP}    Verified=4    Pending Verification=3    Expired=2    Active=1

*** Test Cases ***
Commercial Loan Extension Request
    [Documentation]    Detects Standard/Balloon from grid and processes accordingly
    [Tags]    commercial_loan_extension
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser    ${LOS_QC_URL}    chrome
    Maximize Browser Window
    Execute JavaScript    document.body.style.zoom='75%'
    Set Selenium Implicit Wait    10

    # Step 1: Maker Login
    Login To Application    ${LOGIN_ID}    ${PASSWORD}

    # Step 2: Navigate to Commercial Loan Extension
    Navigate To Service Request

    # Step 3: Search Customer (read from Standard section by default for CIF)
    ${std_data}=    Read Excel Row    ${EXCEL_PATH}    2    3
    ${customer_id}=    Get From Dictionary    ${std_data}    Customer ID
    Set Global Variable    ${CUSTOMER_ID}    ${customer_id}
    Search Customer    ${customer_id}

    # Step 4: Select Account
    Select Account

    # Step 5: Switch to iframe & detect repay type from grid
    Switch To Loan Extension Iframe
    ${repay_type}=    Get Repay Type From Grid

    # Step 6: Read common fields from Standard section (row 2=header, 3=data)
    ${data}=    Read Excel Row    ${EXCEL_PATH}    2    3

    # Step 7: Click Edit on LMS row
    Click Edit On LMS Row

    # Step 8: Fill common form fields
    Fill Standard Form    ${data}

    # Step 9: Fill Balloon details if Balloon (row 10=header, 11=data)
    Run Keyword If    '${repay_type}' != 'Standard'
    ...    Fill Balloon Details

    # Step 9.1: Download Repayment Schedules (New & Old)
    Download Repayment Schedules

    # Step 10: Save
    Save Loan Extension Form

    # Step 10.1: Add Document (Optional - Finance category)
    Add Document To SR

    # Step 11: Send for Verification & Complete Assignment
    Complete Verification From Excel

    # Step 12: Logout Maker
    Logout From Application
    Sleep    2s

    # Step 13: Verification/Approval Loop
    Handle Verification Loop

    # Step 14: Maker Close
    Login To Application    ${LOGIN_ID}    ${PASSWORD}
    Navigate To Service Request Inbox
    Open Application By CIF    ${CUSTOMER_ID}
    Close Application

    Close Browser

*** Keywords ***
# ─────────────────────────────────────────────
# LOGIN
# ─────────────────────────────────────────────
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

# ─────────────────────────────────────────────
# NAVIGATE TO COMMERCIAL LOAN EXTENSION
# ─────────────────────────────────────────────
Navigate To Service Request
    Click Element    xpath=//a[@class='item-nav'][@data-original-title='Menu']
    Sleep    1s
    Click Element    ${XPATH_SERVICE_MENU}
    Sleep    1s
    Click Element    ${XPATH_SERVICE_REQUEST_SUBMENU}
    Sleep    1s
    Click Element    ${XPATH_COMM_LOAN_EXTEN}
    Sleep    2s

# ─────────────────────────────────────────────
# SEARCH CUSTOMER
# ─────────────────────────────────────────────
Search Customer
    [Arguments]    ${customer_id}
    Wait Until Element Is Visible    ${XPATH_CUSTOMER_ID_INPUT}    timeout=15s
    Click Element    ${XPATH_CUSTOMER_ID_INPUT}
    Clear Element Text  ${XPATH_CUSTOMER_ID_INPUT}
    Input Text    ${XPATH_CUSTOMER_ID_INPUT}    ${customer_id}
    Sleep    1s
    Click Element    ${XPATH_SEARCH_BTN}
    Wait Until Element Is Visible    id=customerServiceList    timeout=15s
    Click Element    xpath=//input[@name='cifNo'][@type='radio']
    Click Element    id=okServiceProceed
    Sleep    2s

# ─────────────────────────────────────────────
# SELECT ACCOUNT
# ─────────────────────────────────────────────
Select Account
    Wait Until Element Is Visible    ${XPATH_ACCOUNT_INFO_DIV}    timeout=15s
    Sleep    3s
    Wait Until Element Is Visible    xpath=//input[@type='radio'][@name='accountNumber']    timeout=10s
    Execute JavaScript    document.getElementById('accountNumber1').click()
    Sleep    1s
    Execute JavaScript    document.getElementById('proceedAccData').click()
    Sleep    3s

# ─────────────────────────────────────────────
# SWITCH TO LOAN EXTENSION IFRAME
# ─────────────────────────────────────────────
Switch To Loan Extension Iframe
    Wait Until Element Is Visible    xpath=//iframe[@id='${IFRAME_LOAN_EXTN}']    timeout=20s
    Sleep    3s
    Select Frame    id=${IFRAME_LOAN_EXTN}
    Sleep    2s

# ─────────────────────────────────────────────
# GET REPAY TYPE FROM GRID (Standard / Balloon)
# ─────────────────────────────────────────────
Get Repay Type From Grid
    Wait Until Element Is Visible    xpath=//table[@id='dt-authdata']    timeout=15s
    Sleep    2s
    ${repay_type}=    Get Text    xpath=${XPATH_LMS_ROW}/td[1]
    Log    ✓ Detected Repay Type from Grid: ${repay_type}
    RETURN    ${repay_type}

# ─────────────────────────────────────────────
# CLICK EDIT ON LMS ROW
# ─────────────────────────────────────────────
Click Edit On LMS Row
    Wait Until Element Is Visible    xpath=${XPATH_LMS_EDIT_BTN}    timeout=10s
    Click Element    xpath=${XPATH_LMS_EDIT_BTN}
    Sleep    3s

# ─────────────────────────────────────────────
# FILL STANDARD FORM (Common for both)
# ─────────────────────────────────────────────
Fill Standard Form
    [Arguments]    ${data}
    # 1. Reschedulement Type (Tenure / Installment)
    ${reschedule_type}=    Get From Dictionary    ${data}    Reschedulement_Type
    ${reschedule_val}=    Get From Dictionary    ${RESCHEDULE_TYPE_MAP}    ${reschedule_type}
    Select2 Dropdown    repayCalType    ${reschedule_val}    ${reschedule_type}
    Sleep    2s

    # 2. New Tenure (if Tenure selected)
    ${new_tenure}=    Get From Dictionary    ${data}    New_Tenure
    Run Keyword If    '${reschedule_type}' == 'Tenure' and '${new_tenure}' != '' and '${new_tenure}' != 'None'
    ...    Fill New Tenure Field    ${new_tenure}

    # 3. New Installment Amount (if Installment selected)
    ${new_installment}=    Get From Dictionary    ${data}    New_Installment_Amount
    Run Keyword If    '${reschedule_type}' == 'Installment' and '${new_installment}' != '' and '${new_installment}' != 'None'
    ...    Fill New Installment Field    ${new_installment}

    # 4. Borrower Status
    ${borrower_status}=    Get From Dictionary    ${data}    Borrower_Status
    ${borrower_val}=    Get From Dictionary    ${BORROWER_STATUS_MAP}    ${borrower_status}
    Select2 Dropdown    borrowerStatus    ${borrower_val}    ${borrower_status}
    Sleep    1s

    # 5. Service Charges Waiver
    ${svc_charges}=    Get From Dictionary    ${data}    Service_Charges_Waiver
    Run Keyword If    '${svc_charges}' != '' and '${svc_charges}' != 'None'
    ...    Input Text    ${XPATH_SVC_CHARGES_WAIVER_TXT}    ${svc_charges}

    # 6. Payment Mode
    ${payment_mode}=    Get From Dictionary    ${data}    Payment_Mode
    ${payment_val}=    Get From Dictionary    ${PAYMENT_MODE_MAP}    ${payment_mode}
    Select2 Dropdown    paymentMode    ${payment_val}    ${payment_mode}
    Sleep    1s

    # 7. Remarks
    ${remarks}=    Get From Dictionary    ${data}    Remarks
    Run Keyword If    '${remarks}' != '' and '${remarks}' != 'None'
    ...    Input Text    ${XPATH_REMARKS}    ${remarks}

# ─────────────────────────────────────────────
# FILL NEW TENURE FIELD
# ─────────────────────────────────────────────
Fill New Tenure Field
    [Arguments]    ${tenure}
    Input Text    ${XPATH_NEW_TENURE}    ${tenure}
    Sleep    1s

# ─────────────────────────────────────────────
# FILL NEW INSTALLMENT FIELD
# ─────────────────────────────────────────────
Fill New Installment Field
    [Arguments]    ${installment}
    Input Text    ${XPATH_NEW_INSTALLMENT_TXT}    ${installment}
    Sleep    1s

# ─────────────────────────────────────────────
# FILL BALLOON DETAILS
# ─────────────────────────────────────────────
Fill Balloon Details
    ${balloon_data}=    Read Excel Row    ${EXCEL_PATH}    10    11
    
    # Balloon Type
    ${balloon_type}=    Get From Dictionary    ${balloon_data}    Balloon_Type
    ${balloon_type_val}=    Get From Dictionary    ${BALLOON_TYPE_MAP}    ${balloon_type}
    Select2 Dropdown    balloonType    ${balloon_type_val}    ${balloon_type}
    Sleep    1s
    
    # Balloon Frequency
    ${balloon_freq}=    Get From Dictionary    ${balloon_data}    Balloon_Frequency
    ${balloon_freq_val}=    Get From Dictionary    ${BALLOON_FREQ_MAP}    ${balloon_freq}
    Select2 Dropdown    balloonFrequency    ${balloon_freq_val}    ${balloon_freq}
    Sleep    1s
    
    # Balloon Amount
    ${balloon_amount}=    Get From Dictionary    ${balloon_data}    Balloon_Amount
    Run Keyword If    '${balloon_amount}' != '' and '${balloon_amount}' != 'None'
    ...    Input Text    ${XPATH_BALLOON_AMOUNT_TXT}    ${balloon_amount}
    
    # Balloon Start Installment
    ${balloon_install}=    Get From Dictionary    ${balloon_data}    Balloon_Start_Installment
    Run Keyword If    '${balloon_install}' != '' and '${balloon_install}' != 'None'
    ...    Input Text    ${XPATH_BALLOON_INSTALLMENTS}    ${balloon_install}
    
    # Add Balloon
    Click Element    ${XPATH_ADD_BALLOON_BTN}
    Sleep    2s

# ─────────────────────────────────────────────
# DOWNLOAD REPAYMENT SCHEDULES
# ─────────────────────────────────────────────
Download Repayment Schedules
    # New Repayment Schedule
    Click Element    ${XPATH_NEW_REPAYMENT_BTN}
    Sleep    3s
    
    # Old Repayment Schedule
    Click Element    ${XPATH_OLD_REPAYMENT_BTN}
    Sleep    3s

# ─────────────────────────────────────────────
# SAVE LOAN EXTENSION FORM
# ─────────────────────────────────────────────
Save Loan Extension Form
    Click Element    ${XPATH_SAVE_LOAN_EXTN}
    Sleep    3s
    Handle Alert    ACCEPT
    Sleep    2s

# ─────────────────────────────────────────────
# ADD DOCUMENT TO SR
# ─────────────────────────────────────────────
Add Document To SR
    ${doc_data}=    Read Excel Row    ${EXCEL_PATH}    14    15
    
    # Document Group
    ${doc_group}=    Get From Dictionary    ${doc_data}    Document_Group
    ${doc_group_val}=    Get From Dictionary    ${DOC_GROUP_MAP}    ${doc_group}
    Select2 Dropdown    docGroup    ${doc_group_val}    ${doc_group}
    Sleep    2s
    
    # Document Type (auto-populated based on group)
    Sleep    2s
    
    # Document Number
    ${doc_number}=    Get From Dictionary    ${doc_data}    Document_Number
    Input Text    ${XPATH_DOC_NUMBER}    ${doc_number}
    
    # Document Description
    ${doc_desc}=    Get From Dictionary    ${doc_data}    Document_Description
    Input Text    ${XPATH_DOC_DESCRIPTION}    ${doc_desc}
    
    # Document Submission Date
    ${doc_date}=    Get From Dictionary    ${doc_data}    Document_Submission_Date
    Input Text    ${XPATH_DOC_SUBMISSION_DATE}    ${doc_date}
    
    # Document Status
    ${doc_status}=    Get From Dictionary    ${doc_data}    Document_Status
    ${doc_status_val}=    Get From Dictionary    ${DOC_STATUS_MAP}    ${doc_status}
    Select2 Dropdown    docStatus    ${doc_status_val}    ${doc_status}
    Sleep    1s
    
    # Upload Document File
    ${doc_file}=    Get From Dictionary    ${doc_data}    Document_File_Path
    Run Keyword If    '${doc_file}' != '' and '${doc_file}' != 'None'
    ...    Choose File    ${XPATH_DOC_FILE_INPUT}    ${doc_file}
    
    # Save Document
    Click Element    ${XPATH_SAVE_DOCUMENT}
    Sleep    2s

# ─────────────────────────────────────────────
# SEND FOR VERIFICATION WORKFLOW
# ─────────────────────────────────────────────
Send For Verification
    Unselect Frame
    Sleep    1s
    Click Element    id=NextSR
    Sleep    2s
    Log    ✓ Clicked Send for Verification button
    
    # Wait for assignment form to appear
    Wait Until Element Is Visible    id=assignUser    timeout=10s
    Log    ✓ Assignment form loaded

Complete Verification Assignment
    [Arguments]    ${user_value}    ${maker_remarks}
    # Step 1: Click Send for Verification
    Send For Verification
    
    # Step 2: Fill assignment form that appears
    Select User From Dropdown    ${user_value}
    Fill Maker Remarks    ${maker_remarks}
    
    # Step 3: Submit the assignment
    Submit Assignment Form
    
Complete Verification From Excel
    [Arguments]    ${excel_path}=${EXCEL_PATH}    ${header_row}=6    ${data_row}=7
    # Step 1: Click Send for Verification
    Send For Verification
    
    # Step 2: Read assignment data from Excel
    ${assignment_data}=    Read Excel Row    ${excel_path}    ${header_row}    ${data_row}
    ${user_value}=    Get From Dictionary    ${assignment_data}    Manager_User_ID
    ${maker_remarks}=    Get From Dictionary    ${assignment_data}    Maker_Remarks
    
    # Step 3: Fill and submit assignment form
    Select User From Dropdown    ${user_value}
    Fill Maker Remarks    ${maker_remarks}
    Submit Assignment Form
    
Select User From Dropdown
    [Arguments]    ${user_value}
    Execute JavaScript    $("#assignUser").val("${user_value}").trigger("change")
    Sleep    1s
    Log    ✓ Selected user: ${user_value}

Fill Maker Remarks
    [Arguments]    ${remarks}
    Input Text    id=makerRemarks    ${remarks}
    Log    ✓ Filled maker remarks: ${remarks}

Submit Assignment Form
    # Look for submit/confirm button after filling the form
    ${submit_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    id=popUpYes    timeout=3s
    Run Keyword If    ${submit_present}    Click Element    id=popUpYes
    Sleep    3s
    Log    ✓ Assignment form submitted

# ─────────────────────────────────────────────
# HANDLE VERIFICATION LOOP
# ─────────────────────────────────────────────
Handle Verification Loop
    ${verification_data}=    Read Excel Row    ${EXCEL_PATH}    6    7
    ${manager_user}=    Get From Dictionary    ${verification_data}    Manager_User_ID
    Set Global Variable    ${SELECTED_MANAGER_USER}    ${manager_user}
    
    # Manager Login & Verification
    Login To Application    ${manager_user}    ${PASSWORD}
    Navigate To Service Request Inbox
    Open Application By CIF    ${CUSTOMER_ID}
    Verify Application
    Logout From Application
    Sleep    2s

# ─────────────────────────────────────────────
# UTILITY KEYWORDS
# ─────────────────────────────────────────────
Select2 Dropdown
    [Arguments]    ${element_id}    ${value}    ${display_text}
    Execute JavaScript    $("#${element_id}").val("${value}").trigger("change")
    Sleep    1s
    Log    ✓ Selected ${display_text} in ${element_id}

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

Verify Application
    Wait Until Element Is Visible    ${XPATH_APPROVE_BTN}    timeout=15s
    Click Element    ${XPATH_APPROVE_BTN}
    Sleep    3s

Close Application
    Wait Until Element Is Visible    ${XPATH_CLOSE_BTN}    timeout=15s
    Click Element    ${XPATH_CLOSE_BTN}
    Sleep    3s