*** Settings ***
Documentation    Valuation Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/valuation_sr.xlsx

*** Test Cases ***
Valuation SR Request
    [Documentation]    Service request for valuation
    [Tags]    valuation_sr
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_VALUATION_SR}    ${EXCEL_PATH}

    # TODO: Add valuation specific processing here

    Close Browser
