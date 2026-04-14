*** Settings ***
Documentation    Debt Acknowledgement Cancel Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/debt_ack_cancel.xlsx

*** Test Cases ***
Debt Acknowledgement Cancel Request
    [Documentation]    Service request for debt acknowledgement cancel
    [Tags]    debt_ack_cancel
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_DEBT_ACK_CANCEL}    ${EXCEL_PATH}

    # TODO: Add debt acknowledgement cancel specific processing here

    Close Browser
