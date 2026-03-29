*** Settings ***
Documentation    Receipt Master Test Following Framework Structure
Library          SeleniumLibrary
Resource         ../pages/base_page.robot
Resource         ../pages/login_page.robot
Resource         ../pages/receipt_page.robot
Resource         ../utils/data_utils.robot

*** Variables ***
${TEST_DATA_FILE}    ${CURDIR}/../data/receipt_data.json

*** Test Cases ***
TC001_Receipt_Master_Flow
    [Documentation]    Complete Receipt Master flow using framework structure
    [Tags]    receipt    master
    
    ${test_data}=    Load Test Data From JSON    receipt_data.json
    ${login_creds}=    Get User Data By Environment    admin
    ${receipt_data}=    Get From Dictionary    ${test_data}    receipt_data
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Navigate To Receipt Generation
    Fill Receipt Form    ${receipt_data}
    Generate Receipt
    Save Receipt
    Submit Receipt
    Close Application

TC002_Receipt_Master_Flow_Variant_A
    [Documentation]    Receipt Master flow with variant A data
    [Tags]    receipt    parallel
    
    ${test_data}=    Load Test Data From JSON    receipt_data.json
    ${login_creds}=    Get User Data By Environment    admin
    ${receipt_data}=    Get From Dictionary    ${test_data}    receipt_data_variant_a
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Navigate To Receipt Generation
    Fill Receipt Form    ${receipt_data}
    Generate Receipt
    Save Receipt
    Submit Receipt
    Close Application

TC003_Receipt_Master_Flow_Variant_B
    [Documentation]    Receipt Master flow with variant B data
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

TC004_Receipt_Master_Flow_Variant_C
    [Documentation]    Receipt Master flow with variant C data
    [Tags]    receipt    parallel
    
    ${test_data}=    Load Test Data From JSON    receipt_data.json
    ${login_creds}=    Get User Data By Environment    admin
    ${receipt_data}=    Get From Dictionary    ${test_data}    receipt_data_variant_c
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Navigate To Receipt Generation
    Fill Receipt Form    ${receipt_data}
    Generate Receipt
    Save Receipt
    Submit Receipt
    Close Application

TC005_Receipt_Master_Flow_Variant_D
    [Documentation]    Receipt Master flow with variant D data
    [Tags]    receipt    parallel
    
    ${test_data}=    Load Test Data From JSON    receipt_data.json
    ${login_creds}=    Get User Data By Environment    admin
    ${receipt_data}=    Get From Dictionary    ${test_data}    receipt_data_variant_d
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Navigate To Receipt Generation
    Fill Receipt Form    ${receipt_data}
    Generate Receipt
    Save Receipt
    Submit Receipt
    Close Application

TC006_Receipt_Master_Flow_Extra_1
    [Documentation]    Receipt Master flow with extra test data 1
    [Tags]    receipt    parallel    extra
    
    ${test_data}=    Load Test Data From JSON    receipt_data.json
    ${login_creds}=    Get User Data By Environment    admin
    ${receipt_data}=    Get From Dictionary    ${test_data}    receipt_data
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Navigate To Receipt Generation
    Fill Receipt Form    ${receipt_data}
    Generate Receipt
    Save Receipt
    Submit Receipt
    Close Application

TC007_Receipt_Master_Flow_Extra_2
    [Documentation]    Receipt Master flow with extra test data 2
    [Tags]    receipt    parallel    extra
    
    ${test_data}=    Load Test Data From JSON    receipt_data.json
    ${login_creds}=    Get User Data By Environment    admin
    ${receipt_data}=    Get From Dictionary    ${test_data}    receipt_data_variant_a
    
    Open Application
    Login To Application    ${login_creds['username']}    ${login_creds['password']}
    Navigate To Receipt Generation
    Fill Receipt Form    ${receipt_data}
    Generate Receipt
    Save Receipt
    Submit Receipt
    Close Application

TC008_Receipt_Master_Flow_Extra_3
    [Documentation]    Receipt Master flow with extra test data 3
    [Tags]    receipt    parallel    extra
    
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