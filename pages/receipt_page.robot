*** Settings ***
Documentation    Receipt Master Page Object
Resource         base_page.robot

*** Variables ***
# Navigation Elements
${MENU_BUTTON}              xpath=//a[@data-original-title="Menu"]
${CONFIGURATION_MENU}       xpath=//li[@id="Configuration"]
${RECEIPT_MANAGEMENT}       xpath=//li[@id="RECEIPTMANAGEMENT"]
${RECEIPT_GENERATION}       xpath=//li[@id="RECEIPTGENERATION"]

# Form Elements
${ADD_BUTTON}               xpath=//button[@id="addButton"]
${BOOK_SIZE_DROPDOWN}       xpath=//select[@id="bookSize"]
${NO_OF_BOOKS_INPUT}        xpath=//input[@name="noOfBooks"]
${START_RECEIPT_NO_INPUT}   xpath=//input[@name="startReceiptNo"]
${BOOK_PREFIX_INPUT}        xpath=//input[@name="bookPrefix"]
${RECEIPT_PREFIX_INPUT}     xpath=//input[@name="receiptPrefix"]

# Action Buttons
${GENERATE_RECEIPT_BTN}     xpath=//button[@id='Generate_Receipt']
${SAVE_CUSTOMER_BTN}        xpath=//button[@id='saveCustomer']
${SUBMIT_FORM_LINK}         xpath=//a[@id="submitForm"]

# Error/Success Messages
${ERROR_MESSAGE}            xpath=//div[contains(@class,'error') or contains(text(),'Error') or contains(text(),'already')]
${SUCCESS_MESSAGE}          xpath=//div[contains(@class,'success')]

*** Keywords ***
Navigate To Receipt Generation
    [Documentation]    Navigate to Receipt Generation page
    
    Wait For Element And Click    ${MENU_BUTTON}
    Execute Javascript    document.querySelector('#Transaction').scrollIntoView(true);
    Sleep    1s
    
    Wait For Element And Click    ${CONFIGURATION_MENU}
    Wait For Element And Click    ${RECEIPT_MANAGEMENT}
    Wait For Element And Click    ${RECEIPT_GENERATION}
    Wait For Element And Click    ${ADD_BUTTON}
    
    Wait Until Element Is Visible    ${BOOK_SIZE_DROPDOWN}    timeout=10s

Fill Receipt Form
    [Documentation]    Fill receipt generation form with guaranteed unique data
    [Arguments]    ${receipt_data}
    
    # Generate completely unique integer receipt number
    ${current_time}=    Get Current Date    result_format=epoch
    ${microseconds}=    Evaluate    int(${current_time} * 1000000) % 1000000
    ${random_num}=    Evaluate    random.randint(1000, 9999)    random
    ${thread_id}=    Evaluate    threading.current_thread().ident % 100    threading
    
    # Always use book size 1 (index 1 in dropdown)
    Select From List By Index    ${BOOK_SIZE_DROPDOWN}    1
    Wait For Element And Input Text    ${NO_OF_BOOKS_INPUT}    ${receipt_data['noOfBooks']}
    
    # Create unique integer receipt number (15 digits max)
    ${unique_receipt_no}=    Evaluate    int(str(${microseconds})[-6:] + str(${random_num}) + str(${thread_id}).zfill(2))
    Wait For Element And Input Text    ${START_RECEIPT_NO_INPUT}    ${unique_receipt_no}
    
    # Create unique prefixes with timestamp components
    ${time_suffix}=    Get Current Date    result_format=%H%M%S
    ${unique_book_prefix}=    Set Variable    BK${time_suffix}${thread_id}
    Wait For Element And Input Text    ${BOOK_PREFIX_INPUT}    ${unique_book_prefix}
    
    ${unique_receipt_prefix}=    Set Variable    RC${time_suffix}${thread_id}
    Wait For Element And Input Text    ${RECEIPT_PREFIX_INPUT}    ${unique_receipt_prefix}
    
    Log    Generated unique data - Receipt: ${unique_receipt_no}, Book: ${unique_book_prefix}, Prefix: ${unique_receipt_prefix}

Generate Receipt
    [Documentation]    Generate receipt and validate
    
    Wait For Element And Click    ${GENERATE_RECEIPT_BTN}
    Sleep    2s
    Validate No Errors    Generate Receipt

Save Receipt
    [Documentation]    Save receipt and validate
    
    Wait Until Element Is Visible    ${SAVE_CUSTOMER_BTN}    timeout=8s
    Execute JavaScript    document.getElementById("saveCustomer").click()
    Sleep    2s
    Validate No Errors    Save Receipt

Submit Receipt
    [Documentation]    Submit receipt and validate
    
    Wait For Element And Click    ${SUBMIT_FORM_LINK}
    Sleep    3s
    Validate No Errors    Submit Receipt

Validate No Errors
    [Documentation]    Check for error messages and fail if found
    [Arguments]    ${step_name}
    
    ${error_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=3s
    
    Run Keyword If    ${error_present}
    ...    Run Keywords
    ...    Log    Error detected in step: ${step_name}
    ...    AND    Fail    ${step_name} Failed: Error message found on page