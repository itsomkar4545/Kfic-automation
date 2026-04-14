*** Settings ***
Documentation    Full Insurance Renew Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/full_insurance_renew.xlsx

*** Test Cases ***
Full Insurance Renew Request
    [Documentation]    Service request for full insurance renewal
    [Tags]    full_insurance_renew
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_FULL_INSURANCE_RENEW}    ${EXCEL_PATH}

    # TODO: Add full insurance renew specific processing here

    Close Browser
