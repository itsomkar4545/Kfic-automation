*** Settings ***
Documentation    Lead Management Page Object for KFIC LOS
Resource         base_page.robot

*** Variables ***
# Lead Management Locators
${INBOX_MENU}              xpath=//a[text()='Inbox']
${APP_POOL_MENU}           xpath=//a[text()='App Pool']
${LEAD_SEARCH}             id=leadSearch
${LEAD_ROW}                xpath=//tr[contains(@class,'lead-row')]
${PULL_BUTTON}             xpath=//button[text()='Pull']
${CREDIT_APPROVAL_LINK}    xpath=//a[text()='Credit Approval']
${OFFER_LINK}              xpath=//a[text()='Offer']
${DEAL_PRINTING_LINK}      xpath=//a[text()='Deal Printing']
${DOCUMENT_COLLECTION_LINK}    xpath=//a[text()='Document Collection']
${DISBURSEMENT_LINK}       xpath=//a[text()='Disbursement']
${NEXT_BUTTON}             xpath=//button[text()='Next']
${SAVE_BUTTON}             xpath=//button[text()='Save']
${APPROVE_BUTTON}          xpath=//button[text()='Approve']
${REMARK_FIELD}            id=remarks
${SUBMIT_BUTTON}           xpath=//button[text()='Submit']

*** Keywords ***
Click Inbox
    [Documentation]    Clicks on Inbox menu
    Wait For Element And Click    ${INBOX_MENU}
    Wait For Page Load

Click App Pool
    [Documentation]    Clicks on App Pool menu
    Wait For Element And Click    ${APP_POOL_MENU}
    Wait For Page Load

Search Lead
    [Documentation]    Searches for a lead by ID
    [Arguments]    ${lead_id}
    Wait For Element And Input Text    ${LEAD_SEARCH}    ${lead_id}
    Press Keys    ${LEAD_SEARCH}    ENTER
    Wait For Page Load

Click On Lead
    [Documentation]    Clicks on a specific lead
    [Arguments]    ${lead_id}
    ${lead_locator}=    Set Variable    xpath=//tr[contains(.,'${lead_id}')]//a
    Wait For Element And Click    ${lead_locator}
    Wait For Page Load

Click On Pull
    [Documentation]    Clicks pull button for a lead
    [Arguments]    ${lead_id}
    ${pull_locator}=    Set Variable    xpath=//tr[contains(.,'${lead_id}')]//button[text()='Pull']
    Wait For Element And Click    ${pull_locator}
    Handle Popup Confirmation

Click Credit Approval Link
    [Documentation]    Clicks on Credit Approval link
    Wait For Element And Click    ${CREDIT_APPROVAL_LINK}
    Wait For Page Load

Click Offer Link
    [Documentation]    Clicks on Offer link
    Wait For Element And Click    ${OFFER_LINK}
    Wait For Page Load

Click Deal Printing Link
    [Documentation]    Clicks on Deal Printing link
    Wait For Element And Click    ${DEAL_PRINTING_LINK}
    Wait For Page Load

Click Document Collection Link
    [Documentation]    Clicks on Document Collection link
    Wait For Element And Click    ${DOCUMENT_COLLECTION_LINK}
    Wait For Page Load

Click Disbursement Link
    [Documentation]    Clicks on Disbursement link
    Wait For Element And Click    ${DISBURSEMENT_LINK}
    Wait For Page Load

Enter Remark
    [Documentation]    Enters remark in the remark field
    [Arguments]    ${remark}
    Wait For Element And Input Text    ${REMARK_FIELD}    ${remark}

Click Next Button
    [Documentation]    Clicks the Next button
    Wait For Element And Click    ${NEXT_BUTTON}
    Wait For Loading To Complete

Click Save Button
    [Documentation]    Clicks the Save button
    Wait For Element And Click    ${SAVE_BUTTON}
    Wait For Loading To Complete
    Verify Success Message

Click Approve Button
    [Documentation]    Clicks the Approve button
    Wait For Element And Click    ${APPROVE_BUTTON}
    Wait For Loading To Complete

Click Submit Button
    [Documentation]    Clicks the Submit button
    Wait For Element And Click    ${SUBMIT_BUTTON}
    Wait For Loading To Complete
    Verify Success Message

Handle Popup Confirmation
    [Documentation]    Handles popup confirmation
    Wait For Element And Click    ${POPUP_YES_BTN}

Process Lead Workflow Step
    [Documentation]    Generic workflow step processing
    [Arguments]    ${remark}
    Enter Remark    ${remark}
    Click Next Button
    Click Submit Button