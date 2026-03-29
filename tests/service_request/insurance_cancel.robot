*** Settings ***
Documentation    Insurance Cancel Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/insurance_cancel.xlsx

*** Test Cases ***
Insurance Cancel Request
    [Documentation]    Service request for insurance cancel
    [Tags]    insurance_cancel
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_INSURANCE_CANCEL}    ${EXCEL_PATH}

    # TODO: Add insurance cancel specific processing here

    Close Browser
