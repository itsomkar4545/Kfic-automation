*** Settings ***
Documentation    Add Documents Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/add_documents.xlsx

*** Test Cases ***
Add Documents Request
    [Documentation]    Service request for add documents
    [Tags]    add_documents
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_ADD_DOCUMENTS}    ${EXCEL_PATH}

    # TODO: Add documents specific processing here

    Close Browser
