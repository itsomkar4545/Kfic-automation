*** Settings ***
Documentation    Base Page Object with common web elements and actions
Library          SeleniumLibrary
Library          Collections
Resource         ../config/environment.robot

*** Variables ***
# Common Locators
${LOADING_SPINNER}    xpath=//div[@class='loading-spinner']
${SUCCESS_MESSAGE}    xpath=//div[contains(@class,'alert-success')]
${ERROR_MESSAGE}      xpath=//div[contains(@class,'alert-error')]
${POPUP_YES_BTN}      xpath=//button[text()='Yes']
${POPUP_NO_BTN}       xpath=//button[text()='No']

*** Keywords ***
Open Application
    [Documentation]    Opens the application in browser
    [Arguments]    ${browser}=${BROWSER}    ${headless}=${HEADLESS}
    ${url}=    Get Environment URL
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Run Keyword If    ${headless}    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Open Browser    ${url}    ${browser}    options=${options}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Set Selenium Timeout    ${PAGE_LOAD_TIMEOUT}

Wait For Page Load
    [Documentation]    Waits for page to load completely
    Wait For Condition    return document.readyState == "complete"    timeout=30s

Wait For Element And Click
    [Documentation]    Waits for element and clicks it
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Wait Until Element Is Enabled    ${locator}    timeout=${timeout}
    Click Element    ${locator}

Wait For Element And Input Text
    [Documentation]    Waits for element and inputs text
    [Arguments]    ${locator}    ${text}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Wait Until Element Is Enabled    ${locator}    timeout=${timeout}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${text}

Select From Dropdown By Text
    [Documentation]    Selects option from dropdown by visible text
    [Arguments]    ${locator}    ${text}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Select From List By Label    ${locator}    ${text}

Handle Alert
    [Documentation]    Handles JavaScript alerts
    [Arguments]    ${action}=accept
    Run Keyword If    '${action}' == 'accept'    Alert Should Be Present    action=ACCEPT
    ...    ELSE    Alert Should Be Present    action=DISMISS

Take Screenshot On Failure
    [Documentation]    Takes screenshot when test fails
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${screenshot_path}=    Set Variable    ${SCREENSHOTS_DIR}/failure_${timestamp}.png
    Capture Page Screenshot    ${screenshot_path}

Wait For Loading To Complete
    [Documentation]    Waits for loading spinner to disappear
    Wait Until Element Is Not Visible    ${LOADING_SPINNER}    timeout=30s

Verify Success Message
    [Documentation]    Verifies success message is displayed
    [Arguments]    ${expected_message}=${EMPTY}
    Wait Until Element Is Visible    ${SUCCESS_MESSAGE}    timeout=10s
    Run Keyword If    '${expected_message}' != '${EMPTY}'    
    ...    Element Should Contain    ${SUCCESS_MESSAGE}    ${expected_message}

Verify Error Message
    [Documentation]    Verifies error message is displayed
    [Arguments]    ${expected_message}=${EMPTY}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=10s
    Run Keyword If    '${expected_message}' != '${EMPTY}'    
    ...    Element Should Contain    ${ERROR_MESSAGE}    ${expected_message}

Close Application
    [Documentation]    Closes the browser
    Close All Browsers