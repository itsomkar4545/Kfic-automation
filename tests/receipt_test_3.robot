*** Settings ***
Documentation    Receipt Test 3 for Parallel Execution
Library          SeleniumLibrary
Resource         ../pages/base_page.robot
Resource         ../pages/login_page.robot
Resource         ../pages/receipt_page.robot
Resource         ../utils/data_utils.robot

*** Test Cases ***
TC003_Receipt_Test_3
    [Documentation]    Receipt test 3 for parallel execution
    [Tags]    receipt    parallel
    
    ${test_data}=    Load Test Data From JSON    receipt_data.json
    ${login_creds}=    Get User Data By Environment    admin
    ${receipt_data}=    Get From Dictionary    ${test_data}    receipt_data_variant_b
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Navigate To Receipt Generation
    Fill Receipt Form    ${receipt_data}
    Generate Receipt
    Save Receipt
    Submit Receipt
    Close Application