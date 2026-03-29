*** Settings ***
Documentation    Charges Waiver Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/charges_waiver.xlsx

*** Test Cases ***
Charges Waiver Request
    [Documentation]    Service request for charges waiver
    [Tags]    charges_waiver
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_CHARGES_WAIVER}    ${EXCEL_PATH}

    # TODO: Add charges waiver specific processing here

    Close Browser
