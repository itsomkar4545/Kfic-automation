*** Settings ***
Documentation    Receipt Management Page Object
Resource         base_page.robot

*** Variables ***
# Receipt Management Locators
${MENU_BUTTON}              xpath=//a[@data-original-title="Menu"]
${CONFIGURATION_MENU}       id=Configuration
${RECEIPT_MANAGEMENT_MENU}  id=RECEIPTMANAGEMENT
${RECEIPT_GENERATION_MENU}  id=RECEIPTGENERATION
${ADD_BUTTON}               id=addButton
${BOOK_SIZE_SELECT}         id=bookSize
${NO_OF_BOOKS_INPUT}        name=noOfBooks
${START_RECEIPT_INPUT}      name=startReceiptNo
${BOOK_PREFIX_INPUT}        name=bookPrefix
${RECEIPT_PREFIX_INPUT}     name=receiptPrefix
${GENERATE_BUTTON}          id=Generate_Receipt
${SAVE_BUTTON}              id=saveCustomer
${SUBMIT_BUTTON}            id=submitForm
${SEARCH_INPUT}             xpath=//input[@type='search']
${APPROVE_BUTTON}           id=idApprove
${APPROVE_SUBMIT_BUTTON}    id=btnApproveId

*** Keywords ***
Navigate To Receipt Generation
    [Documentation]    Navigates to receipt generation page
    Wait For Element And Click    ${MENU_BUTTON}
    Execute Javascript    document.querySelector('#Transaction').scrollIntoView(true);
    Wait For Element And Click    ${CONFIGURATION_MENU}
    Wait For Element And Click    ${RECEIPT_MANAGEMENT_MENU}
    Wait For Element And Click    ${RECEIPT_GENERATION_MENU}

Fill Receipt Details
    [Documentation]    Fills receipt generation form
    [Arguments]    ${receipt_data}
    Wait For Element And Click    ${ADD_BUTTON}
    Select From Dropdown By Value    ${BOOK_SIZE_SELECT}    ${receipt_data['bookSize']}
    Wait For Element And Input Text    ${NO_OF_BOOKS_INPUT}    ${receipt_data['noOfBooks']}
    Wait For Element And Input Text    ${START_RECEIPT_INPUT}    ${receipt_data['startReceiptNo']}
    Wait For Element And Input Text    ${BOOK_PREFIX_INPUT}    ${receipt_data['bookPrefix']}
    Wait For Element And Input Text    ${RECEIPT_PREFIX_INPUT}    ${receipt_data['receiptPrefix']}

Generate Receipt
    [Documentation]    Generates receipt and saves
    Wait For Element And Click    ${GENERATE_BUTTON}
    Sleep    3s
    Execute JavaScript    document.getElementById("saveCustomer").click()
    Wait For Element And Click    ${SUBMIT_BUTTON}

Search And Approve Receipt
    [Documentation]    Searches and approves receipt
    [Arguments]    ${receipt_no}
    Wait For Element And Input Text    ${SEARCH_INPUT}    ${receipt_no}
    Sleep    2s
    Click Element    id:dt-pendingdata
    ${approve_locator}=    Set Variable    xpath=//tr[td[text()="${receipt_no}"]]//a[contains(@class, 'auth-reject')]
    Wait For Element And Click    ${approve_locator}
    Execute JavaScript    document.getElementById("idApprove").click()
    Wait For Element And Click    ${APPROVE_SUBMIT_BUTTON}