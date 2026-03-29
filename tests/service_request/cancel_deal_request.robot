*** Settings ***
Documentation    Cancel Deal Request Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/cancel_deal_request.xlsx

*** Test Cases ***
Cancel Deal Request
    [Documentation]    Service request for cancel deal
    [Tags]    cancel_deal_request
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_CANCEL_DEAL_REQUEST}    ${EXCEL_PATH}

    # TODO: Add cancel deal specific processing here

    Close Browser
