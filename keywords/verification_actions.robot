*** Keywords ***
# ─────────────────────────────────────────────
# SEND FOR VERIFICATION
# ─────────────────────────────────────────────

Click Send For Verification
    Wait Until Element Is Visible    id=NextSR    timeout=10s
    Click Element    id=NextSR
    Sleep    2s
    Log    ✓ Clicked Send for Verification button

Click Send For Verification With Confirmation
    Click Send For Verification
    # Handle confirmation popup if it appears
    ${popup_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    id=popUpYes    timeout=3s
    Run Keyword If    ${popup_present}    Click Element    id=popUpYes
    Sleep    2s
    Log    ✓ Send for Verification completed with confirmation

# Alternative using JavaScript click
Send For Verification JS
    Execute JavaScript    document.getElementById('NextSR').click()
    Sleep    2s
    Log    ✓ Send for Verification clicked via JavaScript

# With tooltip verification
Send For Verification With Tooltip Check
    Wait Until Element Is Visible    id=NextSR    timeout=10s
    ${tooltip}=    Get Element Attribute    xpath=//li[@id='NextSR']//a    data-title
    Should Be Equal    ${tooltip}    Send for Verification
    Click Element    id=NextSR
    Sleep    2s
    Log    ✓ Send for Verification clicked after tooltip verification