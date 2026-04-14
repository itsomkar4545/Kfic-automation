*** Settings ***
Documentation    Partial Settlement Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/partial_settlement.xlsx

*** Test Cases ***
Partial Settlement Request
    [Documentation]    Service request for partial settlement
    [Tags]    partial_settlement
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_PARTIAL_SETTLEMENT}    ${EXCEL_PATH}

    # TODO: Add partial settlement specific processing here

    Close Browser
