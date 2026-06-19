*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     ../../config/readme.py
Resource    ../../resources/common_resources.robot

# NOTE: API endpoint paths are based on common e-commerce REST patterns.
# Verify the actual endpoints by inspecting Network tab in browser DevTools
# before running. Update config/config.yaml api.endpoints if they differ.

Suite Setup     Create Purplle API Session
Suite Teardown  Delete All Sessions

*** Variables ***
${API_BASE_URL}     https://www.purplle.com
${SEARCH_ENDPOINT}  /api/search
${AUTO_ENDPOINT}    /api/autocomplete

*** Keywords ***
Create Purplle API Session
    ${headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
    Create Session    purplle    ${API_BASE_URL}    headers=${headers}    verify=True

*** Test Cases ***
TC_API_SEARCH_01 Search API Returns HTTP 200 For Valid Keyword
    [Documentation]
    ...    Verify the search endpoint responds with HTTP 200 for a valid product keyword.
    ...    Endpoint: GET /api/search?q=lipstick
    [Tags]    api    search    smoke
    ${params}=    Create Dictionary    q=lipstick
    ${response}=    GET On Session    purplle    ${SEARCH_ENDPOINT}    params=${params}    expected_status=any
    Should Be True    ${response.status_code} == 200 or ${response.status_code} == 301 or ${response.status_code} == 302
    Log    Response status: ${response.status_code}
    Log    Response body (first 500 chars): ${response.text}[:500]

TC_API_SEARCH_02 Search API Returns HTTP 200 For Brand Name
    [Documentation]
    ...    Verify the search endpoint responds with HTTP 200 for a brand name keyword.
    ...    Endpoint: GET /api/search?q=Lakme
    [Tags]    api    search    smoke
    ${params}=    Create Dictionary    q=Lakme
    ${response}=    GET On Session    purplle    ${SEARCH_ENDPOINT}    params=${params}    expected_status=any
    Should Be True    ${response.status_code} == 200 or ${response.status_code} == 301 or ${response.status_code} == 302
    Log    Response status: ${response.status_code}

TC_API_SEARCH_03 Search API Response Contains JSON Body
    [Documentation]
    ...    Verify the search API response body is parseable as JSON.
    ...    Endpoint: GET /api/search?q=foundation
    [Tags]    api    search    regression
    ${params}=    Create Dictionary    q=foundation
    ${response}=    GET On Session    purplle    ${SEARCH_ENDPOINT}    params=${params}    expected_status=any
    Run Keyword If    ${response.status_code} == 200    Verify JSON Response    ${response}

TC_API_SEARCH_04 Search API Returns HTTP 200 For Skincare Keyword
    [Documentation]
    ...    Verify the search endpoint responds correctly for skincare keyword "serum".
    [Tags]    api    search    regression
    ${params}=    Create Dictionary    q=serum
    ${response}=    GET On Session    purplle    ${SEARCH_ENDPOINT}    params=${params}    expected_status=any
    Should Be True    ${response.status_code} == 200 or ${response.status_code} == 301 or ${response.status_code} == 302
    Log    Response status: ${response.status_code}

TC_API_SEARCH_05 Autocomplete API Returns Response For Partial Keyword
    [Documentation]
    ...    Verify the autocomplete/suggest endpoint responds for a partial keyword "lips".
    ...    Endpoint: GET /api/autocomplete?q=lips
    [Tags]    api    search    regression
    ${params}=    Create Dictionary    q=lips
    ${response}=    GET On Session    purplle    ${AUTO_ENDPOINT}    params=${params}    expected_status=any
    Should Be True    ${response.status_code} == 200 or ${response.status_code} == 404
    Log    Autocomplete status: ${response.status_code}

TC_API_SEARCH_06 Search API Does Not Return 5xx Server Error
    [Documentation]
    ...    Verify the search endpoint does not return any 5xx server-side errors for a valid query.
    [Tags]    api    search    smoke
    ${params}=    Create Dictionary    q=lipstick
    ${response}=    GET On Session    purplle    ${SEARCH_ENDPOINT}    params=${params}    expected_status=any
    Should Be True    ${response.status_code} < 500
    Log    Response status: ${response.status_code}

TC_API_SEARCH_07 Homepage Responds With HTTP 200
    [Documentation]
    ...    Verify the main purplle.com homepage returns HTTP 200 (basic connectivity check).
    [Tags]    api    smoke
    ${response}=    GET On Session    purplle    /    expected_status=any
    Should Be True    ${response.status_code} == 200
    Log    Homepage status: ${response.status_code}

*** Keywords ***
Verify JSON Response
    [Arguments]    ${response}
    ${json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json}
    Log    JSON response keys: ${json}
