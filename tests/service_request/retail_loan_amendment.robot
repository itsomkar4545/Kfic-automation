*** Settings ***
Documentation    Retail Loan Amendment Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/retail_loan_amendment.xlsx

*** Test Cases ***
Retail Loan Amendment Request
    [Documentation]    Service request for retail loan amendment
    [Tags]    retail_loan_amendment
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_RETAIL_LOAN_AMEND}    ${EXCEL_PATH}

    # TODO: Add retail loan amendment specific processing here

    Close Browser
