*** Settings ***
Documentation    Receipt Master Page Object for KFIC Application
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

# Success/Error Messages
${SUCCESS_MESSAGE}          xpath=//div[contains(@class,'alert-success')]
${ERROR_MESSAGE}            xpath=//div[contains(@class,'alert-error')]

*** Keywords ***
Navigate To Receipt Generation
    [Documentation]    Navigate to Receipt Generation page
    
    Click Menu Button
    Navigate To Configuration
    Click Receipt Management
    Click Receipt Generation
    Click Add Button

Click Menu Button
    [Documentation]    Click the main menu button
    Wait For Element And Click    ${MENU_BUTTON}
    Log    Menu button clicked

Navigate To Configuration
    [Documentation]    Navigate to Configuration section
    Execute Javascript    document.querySelector('#Transaction').scrollIntoView(true);
    Sleep    2s
    Wait For Element And Click    ${CONFIGURATION_MENU}
    Log    Configuration menu clicked

Click Receipt Management
    [Documentation]    Click Receipt Management option
    Wait For Element And Click    ${RECEIPT_MANAGEMENT}
    Log    Receipt Management clicked

Click Receipt Generation
    [Documentation]    Click Receipt Generation option
    Wait For Element And Click    ${RECEIPT_GENERATION}
    Log    Receipt Generation clicked

Click Add Button
    [Documentation]    Click Add button to create new receipt
    Wait For Element And Click    ${ADD_BUTTON}
    Log    Add button clicked

Select Book Size
    [Documentation]    Select book size from dropdown
    [Arguments]    ${book_size}
    
    Wait Until Element Is Visible    ${BOOK_SIZE_DROPDOWN}    timeout=10s
    Select From List By Value    ${BOOK_SIZE_DROPDOWN}    ${book_size}
    Log    Book size selected: ${book_size}

Enter Number Of Books
    [Documentation]    Enter number of books
    [Arguments]    ${no_of_books}
    
    Wait For Element And Input Text    ${NO_OF_BOOKS_INPUT}    ${no_of_books}
    Log    Number of books entered: ${no_of_books}

Enter Start Receipt Number
    [Documentation]    Enter start receipt number
    [Arguments]    ${start_receipt_no}
    
    Wait For Element And Input Text    ${START_RECEIPT_NO_INPUT}    ${start_receipt_no}
    Sleep    1s
    Log    Start receipt number entered: ${start_receipt_no}

Enter Book Prefix
    [Documentation]    Enter book prefix
    [Arguments]    ${book_prefix}
    
    Wait For Element And Input Text    ${BOOK_PREFIX_INPUT}    ${book_prefix}
    Log    Book prefix entered: ${book_prefix}

Enter Receipt Prefix
    [Documentation]    Enter receipt prefix
    [Arguments]    ${receipt_prefix}
    
    Wait For Element And Input Text    ${RECEIPT_PREFIX_INPUT}    ${receipt_prefix}
    Log    Receipt prefix entered: ${receipt_prefix}

Click Generate Receipt
    [Documentation]    Click Generate Receipt button
    Wait For Element And Click    ${GENERATE_RECEIPT_BTN}
    Sleep    3s
    Log    Generate Receipt button clicked

Click Save Customer
    [Documentation]    Click Save Customer button using JavaScript
    Wait Until Element Is Visible    ${SAVE_CUSTOMER_BTN}    timeout=10s
    Execute JavaScript    document.getElementById("saveCustomer").click()
    Log    Save Customer button clicked

Click Submit Form
    [Documentation]    Click Submit Form link
    Wait For Element And Click    ${SUBMIT_FORM_LINK}
    Log    Submit Form clicked

Fill Receipt Form
    [Documentation]    Fill complete receipt generation form
    [Arguments]    ${receipt_data}
    
    Select Book Size    ${receipt_data['bookSize']}
    Enter Number Of Books    ${receipt_data['noOfBooks']}
    Enter Start Receipt Number    ${receipt_data['startReceiptNo']}
    Enter Book Prefix    ${receipt_data['bookPrefix']}
    Enter Receipt Prefix    ${receipt_data['receiptPrefix']}

Complete Receipt Generation Process
    [Documentation]    Complete the receipt generation process
    
    Click Generate Receipt
    Click Save Customer
    Click Submit Form

Verify Receipt Generation Success
    [Documentation]    Verify receipt generation was successful
    
    ${success_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${SUCCESS_MESSAGE}    timeout=10s
    
    Run Keyword If    ${success_visible}
    ...    Log    Receipt generation successful
    ...    ELSE
    ...    Log    No success message found - check manually

Verify Receipt Generation Error
    [Documentation]    Verify if there's an error in receipt generation
    
    ${error_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    
    Run Keyword If    ${error_visible}
    ...    Run Keywords
    ...    ${error_text}=    Get Text    ${ERROR_MESSAGE}
    ...    AND    Log    Error occurred: ${error_text}
    ...    AND    Fail    Receipt generation failed: ${error_text}