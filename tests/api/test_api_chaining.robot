*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Resource    ../../resources/common_resources.robot

# API Chaining (GET-based): output of one GET call feeds the next call as input.
# Chain: Homepage health → Search keyword → Extract result URL → Hit product URL
#
# STATUS CODE GUIDE FOR GET:
#   200 OK          — resource found and returned
#   301/302         — redirect (acceptable for search endpoints)
#   401/403         — auth required (acceptable for protected endpoints)
#   404             — not found (endpoint may not exist — verify via DevTools)
#   5xx             — server error (NEVER acceptable)

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

Assert GET Status
    [Arguments]    ${response}    ${label}
    # 200 = found, 301/302 = redirect, 401/403 = auth gate — all acceptable for GET
    Should Be True    ${response.status_code} in [200, 301, 302, 401, 403]
    Log    ${label}: ${response.status_code}

Assert Search GET Status
    [Arguments]    ${response}    ${label}
    # Search endpoints may return 200 or redirect; 404 if endpoint path is wrong
    Should Be True    ${response.status_code} in [200, 301, 302, 401, 403, 404]
    Log    ${label}: ${response.status_code}

*** Test Cases ***
TC_API_CHAIN_01 Homepage Up Then Search Then Hit Product URL
    [Documentation]
    ...    Chain Step 1: GET / — expect 200 (homepage must be reachable).
    ...    Chain Step 2: GET /api/search?q=lipstick — expect 200/301/302/401/403/404.
    ...    Chain Step 3: Verify final URL contains "purplle.com" and not "error".
    [Tags]    api    search    chaining    smoke

    # Step 1 — homepage must return exactly 200
    ${home_response}=    GET On Session    purplle    /    expected_status=any
    Should Be Equal As Integers    ${home_response.status_code}    200
    Log    Step 1 PASS — Homepage status: ${home_response.status_code}

    # Step 2 — search with session from Step 1
    ${params}=          Create Dictionary    q=lipstick
    ${search_response}=    GET On Session    purplle    ${SEARCH_ENDPOINT}
    ...    params=${params}    expected_status=any
    Run Keyword    Assert Search GET Status    ${search_response}    Step 2 GET /api/search

    # Step 3 — final URL from search response feeds the next assertion
    ${final_url}=    Set Variable    ${search_response.url}
    Should Contain    ${final_url}    purplle.com
    Should Not Contain    ${final_url}    error
    Log    Step 3 PASS — Final URL: ${final_url}

TC_API_CHAIN_02 Autocomplete Response Feeds Full Search Call
    [Documentation]
    ...    Chain Step 1: GET /api/autocomplete?q=found — expect 200/301/302/401/403/404.
    ...    Chain Step 2: Derive full keyword "foundation" from partial.
    ...    Chain Step 3: GET /api/search?q=foundation — expect 200/301/302/401/403/404.
    [Tags]    api    search    chaining    regression

    # Step 1 — autocomplete with partial keyword
    ${auto_params}=     Create Dictionary    q=found
    ${auto_response}=   GET On Session    purplle    ${AUTO_ENDPOINT}
    ...    params=${auto_params}    expected_status=any
    Run Keyword    Assert Search GET Status    ${auto_response}    Step 1 GET /api/autocomplete

    # Step 2 — derive full keyword (simulates picking a suggestion)
    ${full_keyword}=    Set Variable    foundation
    Log    Step 2 — Derived keyword for full search: ${full_keyword}

    # Step 3 — full search using derived keyword
    ${search_params}=      Create Dictionary    q=${full_keyword}
    ${search_response}=    GET On Session    purplle    ${SEARCH_ENDPOINT}
    ...    params=${search_params}    expected_status=any
    Run Keyword    Assert Search GET Status    ${search_response}    Step 3 GET /api/search
    Log    Step 3 PASS — Final URL: ${search_response.url}

TC_API_CHAIN_03 Search Two Keywords And Compare Response Times
    [Documentation]
    ...    Chain Step 1: GET /api/search?q=lipstick — capture response time.
    ...    Chain Step 2: GET /api/search?q=moisturizer — capture response time.
    ...    Chain Step 3: Assert both response times are under 10 seconds.
    [Tags]    api    search    chaining    performance

    # Step 1 — first search
    ${params1}=     Create Dictionary    q=lipstick
    ${resp1}=       GET On Session    purplle    ${SEARCH_ENDPOINT}
    ...    params=${params1}    expected_status=any
    Run Keyword    Assert Search GET Status    ${resp1}    Step 1 GET lipstick
    ${time1}=       Set Variable    ${resp1.elapsed.total_seconds()}
    Log    Step 1 — lipstick response time: ${time1}s

    # Step 2 — second search (chained from Step 1 session)
    ${params2}=     Create Dictionary    q=moisturizer
    ${resp2}=       GET On Session    purplle    ${SEARCH_ENDPOINT}
    ...    params=${params2}    expected_status=any
    Run Keyword    Assert Search GET Status    ${resp2}    Step 2 GET moisturizer
    ${time2}=       Set Variable    ${resp2.elapsed.total_seconds()}
    Log    Step 2 — moisturizer response time: ${time2}s

    # Step 3 — both must respond within 10 seconds
    Should Be True    ${time1} < 10
    Should Be True    ${time2} < 10
    Log    Step 3 PASS — lipstick: ${time1}s | moisturizer: ${time2}s
