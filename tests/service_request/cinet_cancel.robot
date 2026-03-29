*** Settings ***
Documentation    CINET Cancel Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/cinet_cancel.xlsx

*** Test Cases ***
CINET Cancel Request
    [Documentation]    Service request for CINET cancel
    [Tags]    cinet_cancel
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_CINET_CANCEL}    ${EXCEL_PATH}

    # TODO: Add CINET cancel specific processing here

    Close Browser
