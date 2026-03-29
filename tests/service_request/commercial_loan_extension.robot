*** Settings ***
Documentation    Commercial Loan Extension Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/commercial_loan_extension.xlsx

*** Test Cases ***
Commercial Loan Extension Request
    [Documentation]    Service request for commercial loan extension
    [Tags]    commercial_loan_extension
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_COMM_LOAN_EXTEN}    ${EXCEL_PATH}

    # TODO: Add commercial loan extension specific processing here

    Close Browser
