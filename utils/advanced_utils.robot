*** Settings ***
Documentation    Advanced Framework Utilities for Performance and Reliability
Library          Collections
Library          DateTime
Library          OperatingSystem
Library          String
Library          Process

*** Variables ***
${PERFORMANCE_LOG}    ${CURDIR}/../results/performance.log
${RETRY_COUNT}        3
${PERFORMANCE_THRESHOLD}    5.0    # seconds

*** Keywords ***
Measure Test Performance
    [Documentation]    Measure and log test step performance
    [Arguments]    ${step_name}    ${keyword_to_run}    @{args}
    
    ${start_time}=    Get Current Date    result_format=epoch
    ${result}=    Run Keyword    ${keyword_to_run}    @{args}
    ${end_time}=    Get Current Date    result_format=epoch
    
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Log Performance Metric    ${step_name}    ${duration}
    
    # Alert if performance is slow
    Run Keyword If    ${duration} > ${PERFORMANCE_THRESHOLD}
    ...    Log    WARNING: ${step_name} took ${duration}s (threshold: ${PERFORMANCE_THRESHOLD}s)    WARN
    
    [Return]    ${result}

Log Performance Metric
    [Documentation]    Log performance metrics to file
    [Arguments]    ${step_name}    ${duration}
    
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${log_entry}=    Set Variable    ${timestamp} | ${step_name} | ${duration}s
    
    Create Directory    ${CURDIR}/../results
    Append To File    ${PERFORMANCE_LOG}    ${log_entry}\n

Smart Element Interaction
    [Documentation]    Enhanced element interaction with auto-retry and performance monitoring
    [Arguments]    ${action}    ${locator}    ${value}=${EMPTY}    ${timeout}=10s
    
    FOR    ${attempt}    IN RANGE    1    ${RETRY_COUNT + 1}
        ${success}=    Run Keyword And Return Status
        ...    Run Keywords
        ...    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
        ...    AND    Wait Until Element Is Enabled    ${locator}    timeout=${timeout}
        ...    AND    Run Keyword If    '${action}' == 'click'    Click Element    ${locator}
        ...    ELSE IF    '${action}' == 'input'    Input Text    ${locator}    ${value}
        ...    ELSE IF    '${action}' == 'select'    Select From List By Value    ${locator}    ${value}
        
        Exit For Loop If    ${success}
        
        Run Keyword If    ${attempt} < ${RETRY_COUNT}
        ...    Run Keywords
        ...    Log    Retry ${attempt}: ${action} on ${locator} failed, retrying...    WARN
        ...    AND    Sleep    1s
    END
    
    Run Keyword Unless    ${success}
    ...    Fail    Failed to ${action} on ${locator} after ${RETRY_COUNT} attempts

Bulk Element Operations
    [Documentation]    Perform multiple element operations efficiently
    [Arguments]    ${operations_list}
    
    # operations_list format: [{'action': 'click', 'locator': 'xpath', 'value': 'optional'}]
    FOR    ${operation}    IN    @{operations_list}
        ${action}=    Get From Dictionary    ${operation}    action
        ${locator}=    Get From Dictionary    ${operation}    locator
        ${value}=    Get From Dictionary    ${operation}    value    default=${EMPTY}
        
        Smart Element Interaction    ${action}    ${locator}    ${value}
    END

Generate Unique Test Data
    [Documentation]    Generate unique test data to avoid conflicts
    [Arguments]    ${data_type}=string    ${length}=10
    
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${random_string}=    Generate Random String    ${length}    [LETTERS][NUMBERS]
    
    ${unique_data}=    Run Keyword If    '${data_type}' == 'number'
    ...    Set Variable    ${timestamp}
    ...    ELSE IF    '${data_type}' == 'email'
    ...    Set Variable    test${timestamp}@kfic.com
    ...    ELSE IF    '${data_type}' == 'phone'
    ...    Set Variable    91${timestamp}
    ...    ELSE
    ...    Set Variable    TEST${timestamp}${random_string}
    
    [Return]    ${unique_data}

Parallel Data Setup
    [Documentation]    Setup test data for parallel execution
    [Arguments]    ${base_data}    ${thread_id}=1
    
    ${modified_data}=    Copy Dictionary    ${base_data}
    
    # Add thread-specific suffixes to avoid conflicts
    FOR    ${key}    IN    @{base_data.keys()}
        ${value}=    Get From Dictionary    ${base_data}    ${key}
        ${new_value}=    Set Variable    ${value}_T${thread_id}
        Set To Dictionary    ${modified_data}    ${key}    ${new_value}
    END
    
    [Return]    ${modified_data}

Smart Wait Strategy
    [Documentation]    Intelligent waiting strategy based on element type
    [Arguments]    ${locator}    ${element_type}=button
    
    # Different wait strategies for different element types
    ${timeout}=    Run Keyword If    '${element_type}' == 'button'
    ...    Set Variable    10s
    ...    ELSE IF    '${element_type}' == 'input'
    ...    Set Variable    5s
    ...    ELSE IF    '${element_type}' == 'dropdown'
    ...    Set Variable    8s
    ...    ELSE IF    '${element_type}' == 'table'
    ...    Set Variable    15s
    ...    ELSE
    ...    Set Variable    10s
    
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    
    # Additional waits for specific element types
    Run Keyword If    '${element_type}' == 'dropdown'
    ...    Wait Until Element Contains    ${locator}    option
    ...    ELSE IF    '${element_type}' == 'table'
    ...    Wait Until Element Contains    ${locator}    td

Auto Recovery
    [Documentation]    Automatic recovery from common failures
    [Arguments]    ${recovery_action}=refresh
    
    Log    Attempting auto-recovery: ${recovery_action}    WARN
    
    Run Keyword If    '${recovery_action}' == 'refresh'
    ...    Reload Page
    ...    ELSE IF    '${recovery_action}' == 'login'
    ...    Run Keywords
    ...    Go To    ${BASE_URL}
    ...    AND    Login To Application    ${DEFAULT_USER}    ${DEFAULT_PASSWORD}
    ...    ELSE IF    '${recovery_action}' == 'clear_cache'
    ...    Execute JavaScript    localStorage.clear(); sessionStorage.clear();
    
    Sleep    2s

Validate Page Performance
    [Documentation]    Validate page load performance
    [Arguments]    ${max_load_time}=5.0
    
    ${start_time}=    Get Current Date    result_format=epoch
    Wait For Condition    return document.readyState === 'complete'    timeout=30s
    ${end_time}=    Get Current Date    result_format=epoch
    
    ${load_time}=    Evaluate    ${end_time} - ${start_time}
    
    Run Keyword If    ${load_time} > ${max_load_time}
    ...    Log    WARNING: Page load time ${load_time}s exceeds threshold ${max_load_time}s    WARN
    
    Log Performance Metric    Page Load    ${load_time}

Batch Element Validation
    [Documentation]    Validate multiple elements efficiently
    [Arguments]    ${elements_dict}
    
    # elements_dict format: {'element_name': 'locator'}
    ${failed_elements}=    Create List
    
    FOR    ${element_name}    ${locator}    IN    &{elements_dict}
        ${is_visible}=    Run Keyword And Return Status
        ...    Element Should Be Visible    ${locator}
        
        Run Keyword Unless    ${is_visible}
        ...    Append To List    ${failed_elements}    ${element_name}
    END
    
    ${failure_count}=    Get Length    ${failed_elements}
    Run Keyword If    ${failure_count} > 0
    ...    Fail    Elements not visible: ${failed_elements}

Smart Screenshot
    [Documentation]    Intelligent screenshot capture with context
    [Arguments]    ${context}=general    ${element_locator}=${EMPTY}
    
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${test_name}=    Set Variable    ${TEST NAME}
    ${screenshot_name}=    Set Variable    ${context}_${test_name}_${timestamp}.png
    
    Create Directory    ${CURDIR}/../results/screenshots
    
    # Highlight element if provided
    Run Keyword If    '${element_locator}' != '${EMPTY}'
    ...    Execute JavaScript    
    ...    arguments[0].style.border='3px solid red';    
    ...    XPATH:${element_locator}
    
    Capture Page Screenshot    ${CURDIR}/../results/screenshots/${screenshot_name}
    
    # Remove highlight
    Run Keyword If    '${element_locator}' != '${EMPTY}'
    ...    Execute JavaScript    
    ...    arguments[0].style.border='';    
    ...    XPATH:${element_locator}
    
    Log    Screenshot saved: ${screenshot_name}

Database Cleanup
    [Documentation]    Clean up test data from database
    [Arguments]    ${cleanup_queries}
    
    # cleanup_queries is a list of SQL queries
    FOR    ${query}    IN    @{cleanup_queries}
        Log    Executing cleanup: ${query}
        # Execute database query here
        # Connect To Database    ...
        # Execute Sql String    ${query}
    END

Generate Test Report Summary
    [Documentation]    Generate performance and execution summary
    
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${report_content}=    Set Variable    
    ...    Test Execution Summary - ${timestamp}\n
    ...    =====================================\n
    ...    Framework: KFIC Advanced Automation\n
    ...    Performance Optimizations: Enabled\n
    ...    Auto-retry: ${RETRY_COUNT} attempts\n
    ...    Performance Threshold: ${PERFORMANCE_THRESHOLD}s\n
    
    Create File    ${CURDIR}/../results/execution_summary.txt    ${report_content}
    Log    Test summary generated: execution_summary.txt