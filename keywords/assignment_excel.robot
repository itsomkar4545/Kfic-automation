*** Variables ***
# Assignment Form Field Mappings
&{USER_MAP}    z.diab=z.diab - Zeinab Diab    USER5=USER5 - USER5

# Excel Configuration
${ASSIGNMENT_EXCEL_PATH}    ${CURDIR}/../data/assignment_data.xlsx

*** Keywords ***
Fill Assignment From Excel
    [Arguments]    ${excel_path}=${ASSIGNMENT_EXCEL_PATH}    ${header_row}=1    ${data_row}=2
    ${assignment_data}=    Read Excel Row    ${excel_path}    ${header_row}    ${data_row}
    
    # Get user value from Excel
    ${user_value}=    Get From Dictionary    ${assignment_data}    User_Value
    
    # Get maker remarks from Excel
    ${maker_remarks}=    Get From Dictionary    ${assignment_data}    Maker_Remarks
    
    # Fill the form
    Fill Assignment Form    ${user_value}    ${maker_remarks}
    
    Log    ✓ Assignment form filled from Excel data

Validate Assignment Form
    [Arguments]    ${expected_user}    ${expected_remarks}
    ${actual_user}=    Get Selected User
    ${actual_remarks}=    Get Value    id=makerRemarks
    
    Should Contain    ${actual_user}    ${expected_user}
    Should Be Equal    ${actual_remarks}    ${expected_remarks}
    
    Log    ✓ Assignment form validation passed