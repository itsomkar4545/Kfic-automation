*** Settings ***
Documentation    Delete Guarantor Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/delete_guarantor_sr.xlsx

*** Test Cases ***
Delete Guarantor SR Request
    [Documentation]    Service request for delete guarantor
    [Tags]    delete_guarantor_sr
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_DELETE_GUARANTOR_SR}    ${EXCEL_PATH}

    # TODO: Add delete guarantor specific processing here

    Close Browser
