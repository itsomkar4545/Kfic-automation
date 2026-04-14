*** Settings ***
Documentation    Personal Details Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/personal_details.xlsx

*** Test Cases ***
Personal Details Request
    [Documentation]    Service request for personal details
    [Tags]    personal_details
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_PERSONAL_DETAILS}    ${EXCEL_PATH}

    # TODO: Add personal details specific processing here

    Close Browser
