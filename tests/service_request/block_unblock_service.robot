*** Settings ***
Documentation    Block/Unblock Service Request
Library          SeleniumLibrary
Resource         ../../pages/common_keywords.robot

*** Variables ***
${LOGIN_ID}      20
# PASSWORD is loaded from environment.robot via common_keywords.robot
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/block_unblock_service.xlsx

*** Test Cases ***
Block Unblock Service Request
    [Documentation]    Service request for block/unblock service
    [Tags]    block_unblock_service
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot

    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_BLOCK_UNBLOCK_SERVICE}    ${EXCEL_PATH}

    # TODO: Add block/unblock specific processing here

    Close Browser
