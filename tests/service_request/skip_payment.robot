*** Settings ***
Documentation    Skip Payment Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/skip_payment.xlsx

*** Test Cases ***
Skip Payment Request
    [Documentation]    Service request for skip payment
    [Tags]    skip_payment
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_SKIP_PAYMENT}    ${EXCEL_PATH}

    # TODO: Add skip payment specific processing here

    Close Browser
