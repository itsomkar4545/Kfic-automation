*** Settings ***
Documentation    Refund Maker Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/refund_maker.xlsx

*** Test Cases ***
Refund Maker Request
    [Documentation]    Service request for refund maker
    [Tags]    refund_maker
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_REFUND_MAKER}    ${EXCEL_PATH}

    # TODO: Add refund maker specific processing here

    Close Browser
