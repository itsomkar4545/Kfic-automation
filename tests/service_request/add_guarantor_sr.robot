*** Settings ***
Documentation    Add Guarantor Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/add_guarantor_sr.xlsx

*** Test Cases ***
Add Guarantor SR Request
    [Documentation]    Service request for add guarantor
    [Tags]    add_guarantor_sr
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_ADD_GUARANTOR_SR}    ${EXCEL_PATH}

    # TODO: Add guarantor specific processing here

    Close Browser
