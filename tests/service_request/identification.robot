*** Settings ***
Documentation    Identification Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/identification.xlsx

*** Test Cases ***
Identification Request
    [Documentation]    Service request for identification
    [Tags]    identification
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_IDENTIFICATION}    ${EXCEL_PATH}

    # TODO: Add identification specific processing here

    Close Browser
