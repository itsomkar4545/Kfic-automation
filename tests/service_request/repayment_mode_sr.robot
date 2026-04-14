*** Settings ***
Documentation    Repayment Mode Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/repayment_mode_sr.xlsx

*** Test Cases ***
Repayment Mode SR Request
    [Documentation]    Service request for repayment mode change
    [Tags]    repayment_mode_sr
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_REPAYMENT_MODE_SR}    ${EXCEL_PATH}

    # TODO: Add repayment mode specific processing here

    Close Browser
