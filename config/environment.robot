*** Settings ***
Documentation    Environment Configuration for KFIC LOS & LMS
Library          Collections

*** Variables ***
# Environment Selection
${ENVIRONMENT}    qc

# URLs
&{URLS}
...    dev=http://172.21.0.123:5555/finairoLending-1.0.1/LoginPage?tid=139&lang=en
...    qc=http://172.21.0.93:9092/Kiya.aiCBS-10.2.0/LoginPage?tid=139&lang=en
...    uat=http://uat.kfic.com/finairoLending/LoginPage?tid=139&lang=en
...    prod=http://prod.kfic.com/finairoLending/LoginPage?tid=139&lang=en

# LOS URLs
${LOS_QC_URL}    http://172.21.0.93:6661/finairoLending-1.0.1/LoginPage?tid=139&lang=en

# Database Connections
&{DB_CONFIG}
...    dev_host=172.21.0.123
...    dev_port=3306
...    dev_name=kfic_dev
...    uat_host=uat.kfic.com
...    uat_port=3306
...    uat_name=kfic_uat

# Browser Configuration
${BROWSER}        chrome
${HEADLESS}       False
${IMPLICIT_WAIT}  10
${PAGE_LOAD_TIMEOUT}  30

# Test Data Paths
${TEST_DATA_DIR}     ${CURDIR}/../data
${SCREENSHOTS_DIR}   ${CURDIR}/../results/screenshots
${REPORTS_DIR}       ${CURDIR}/../results/reports

# API Configuration
&{API_CONFIG}
...    base_url=http://172.21.0.123:8080/api/v1
...    timeout=30
...    headers={"Content-Type": "application/json"}

*** Keywords ***
Get Environment URL
    [Documentation]    Returns URL based on environment
    ${url}=    Get From Dictionary    ${URLS}    ${ENVIRONMENT}
    RETURN    ${url}

Get Database Config
    [Documentation]    Returns database configuration
    ${host}=    Get From Dictionary    ${DB_CONFIG}    ${ENVIRONMENT}_host
    ${port}=    Get From Dictionary    ${DB_CONFIG}    ${ENVIRONMENT}_port
    ${name}=    Get From Dictionary    ${DB_CONFIG}    ${ENVIRONMENT}_name
    &{config}=    Create Dictionary    host=${host}    port=${port}    database=${name}
    RETURN    &{config}