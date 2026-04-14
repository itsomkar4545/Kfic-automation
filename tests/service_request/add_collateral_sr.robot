*** Settings ***
Documentation    Add Collateral Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/add_collateral_sr.xlsx

*** Test Cases ***
Add Collateral SR Request
    [Documentation]    Service request for add collateral
    [Tags]    add_collateral_sr
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_ADD_COLLATERAL_SR}    ${EXCEL_PATH}

    # TODO: Add collateral specific processing here

    Close Browser
