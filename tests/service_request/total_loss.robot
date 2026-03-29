*** Settings ***
Documentation    Total Loss Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/total_loss.xlsx

*** Test Cases ***
Total Loss Request
    [Documentation]    Service request for total loss
    [Tags]    total_loss
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_TOTAL_LOSS}    ${EXCEL_PATH}

    # TODO: Add total loss specific processing here

    Close Browser
