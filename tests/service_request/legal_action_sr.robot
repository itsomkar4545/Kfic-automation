*** Settings ***
Documentation    Legal Action Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/legal_action_sr.xlsx

*** Test Cases ***
Legal Action SR Request
    [Documentation]    Service request for legal action
    [Tags]    legal_action_sr
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_LEGAL_ACTION_SR}    ${EXCEL_PATH}

    # TODO: Add legal action specific processing here

    Close Browser
