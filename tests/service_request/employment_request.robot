*** Settings ***
Documentation    Employment Request Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/employment_request.xlsx

*** Test Cases ***
Employment Request
    [Documentation]    Service request for employment request
    [Tags]    employment_request
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_EMPLOYMENT_REQUEST}    ${EXCEL_PATH}

    # TODO: Add employment request specific processing here

    Close Browser
