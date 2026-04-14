*** Settings ***
Documentation    Enhanced Configuration Management for KFIC Automation Framework
Library          Collections
Library          OperatingSystem

*** Variables ***
# Framework Version
${FRAMEWORK_VERSION}    1.0.0

# Environment Selection (Change this for different environments)
${ENVIRONMENT}    qc

# Application URLs
&{URLS}
...    dev=http://localhost:8090/Kiya.aiCBS-10.2.0/LoginPage?tid=139&lang=en
...    qc=http://172.21.0.93:9092/Kiya.aiCBS-10.2.0/LoginPage?tid=139&lang=en
...    uat=http://uat.kfic.com/finairoLending/LoginPage?tid=139&lang=en
...    prod=http://prod.kfic.com/finairoLending/LoginPage?tid=139&lang=en

# Browser Configuration
${BROWSER}              chrome
${HEADLESS}             False
${BROWSER_WIDTH}        1920
${BROWSER_HEIGHT}       1080

# Timeout Configuration
${IMPLICIT_WAIT}        15
${EXPLICIT_WAIT}        20
${PAGE_LOAD_TIMEOUT}    30
${ELEMENT_TIMEOUT}      10

# Test Data Configuration
${TEST_DATA_DIR}        ${CURDIR}/../data
${SCREENSHOTS_BASE}     ${CURDIR}/../results/screenshots
${SCREENSHOTS_DIR}      ${EMPTY}
${REPORTS_DIR}          ${CURDIR}/../results/reports
${LOGS_DIR}             ${CURDIR}/../results/logs

# Database Configuration (Future use)
&{DB_CONFIG}
...    dev_host=172.21.0.123
...    dev_port=3306
...    dev_name=kfic_dev
...    qc_host=172.21.0.93
...    qc_port=3306
...    qc_name=kfic_qc
...    uat_host=uat.kfic.com
...    uat_port=3306
...    uat_name=kfic_uat

# API Configuration (Future use)
&{API_CONFIG}
...    dev_base_url=http://172.21.0.123:8080/api/v1
...    qc_base_url=http://172.21.0.93:8080/api/v1
...    timeout=30
...    headers={"Content-Type": "application/json", "Accept": "application/json"}

# Email Configuration (For reporting)
&{EMAIL_CONFIG}
...    smtp_server=smtp.gmail.com
...    smtp_port=587
...    sender_email=automation@kfic.com
...    recipients=["team@kfic.com"]

# Parallel Execution Configuration
${PARALLEL_PROCESSES}   2
${PARALLEL_ENABLED}     False

# Retry Configuration
${MAX_RETRIES}          3
${RETRY_DELAY}          2

# Screenshot Configuration
${SCREENSHOT_ON_FAILURE}    True
${SCREENSHOT_ON_PASS}       False
${SCREENSHOT_QUALITY}       80

*** Keywords ***
Get Environment URL
    [Documentation]    Returns URL based on current environment
    ${url}=    Get From Dictionary    ${URLS}    ${ENVIRONMENT}
    RETURN    ${url}

Get Database Config
    [Documentation]    Returns database configuration for current environment
    ${host_key}=    Set Variable    ${ENVIRONMENT}_host
    ${port_key}=    Set Variable    ${ENVIRONMENT}_port
    ${name_key}=    Set Variable    ${ENVIRONMENT}_name
    
    ${host}=    Get From Dictionary    ${DB_CONFIG}    ${host_key}
    ${port}=    Get From Dictionary    ${DB_CONFIG}    ${port_key}
    ${name}=    Get From Dictionary    ${DB_CONFIG}    ${name_key}
    
    &{config}=    Create Dictionary    host=${host}    port=${port}    database=${name}
    RETURN    &{config}

Get API Base URL
    [Documentation]    Returns API base URL for current environment
    ${url_key}=    Set Variable    ${ENVIRONMENT}_base_url
    ${base_url}=    Get From Dictionary    ${API_CONFIG}    ${url_key}
    RETURN    ${base_url}

Setup Test Environment
    [Documentation]    Sets up test environment with all configurations
    Log    Framework Version: ${FRAMEWORK_VERSION}
    Log    Environment: ${ENVIRONMENT}
    Log    Browser: ${BROWSER}
    Log    Application URL: ${URLS.${ENVIRONMENT}}
    
    # Create necessary directories
    Create Directory    ${SCREENSHOTS_DIR}
    Create Directory    ${REPORTS_DIR}
    Create Directory    ${LOGS_DIR}

Validate Environment
    [Documentation]    Validates if environment configuration is correct
    Dictionary Should Contain Key    ${URLS}    ${ENVIRONMENT}
    Should Not Be Empty    ${URLS.${ENVIRONMENT}}
    Log    Environment validation passed for: ${ENVIRONMENT}