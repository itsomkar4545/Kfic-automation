*** Keywords ***
# ─────────────────────────────────────────────
# ASSIGNMENT FORM INTERACTIONS
# ─────────────────────────────────────────────

Select User From Dropdown
    [Arguments]    ${user_value}
    Execute JavaScript    $("#assignUser").val("${user_value}").trigger("change")
    Sleep    1s
    Log    ✓ Selected user: ${user_value}

Fill Maker Remarks
    [Arguments]    ${remarks}
    Input Text    id=makerRemarks    ${remarks}
    Log    ✓ Filled maker remarks: ${remarks}

Get Group Name
    ${group_name}=    Get Text    id=select2-grpName-container
    Log    Current Group Name: ${group_name}
    RETURN    ${group_name}

Get Selected User
    ${selected_user}=    Get Text    id=select2-assignUser-container
    Log    Selected User: ${selected_user}
    RETURN    ${selected_user}

Fill Assignment Form
    [Arguments]    ${user_value}    ${remarks}
    Select User From Dropdown    ${user_value}
    Fill Maker Remarks    ${remarks}
    Log    ✓ Assignment form filled successfully

# Alternative method using Click for Select2
Select User By Click
    [Arguments]    ${user_display_text}
    Click Element    xpath=//span[@id='select2-assignUser-container']
    Sleep    1s
    Click Element    xpath=//li[contains(text(),'${user_display_text}')]
    Sleep    1s
    Log    ✓ Selected user by click: ${user_display_text}