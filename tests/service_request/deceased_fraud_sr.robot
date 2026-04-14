*** Settings ***
Documentation    Deceased/Fraud Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/deceased_fraud_sr.xlsx

*** Test Cases ***
Deceased Fraud SR Request
    [Documentation]    Service request for deceased/fraud
    [Tags]    deceased_fraud_sr
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_DECEASED_FRAUD_SR}    ${EXCEL_PATH}

    # TODO: Add deceased/fraud specific processing here

    Close Browser
