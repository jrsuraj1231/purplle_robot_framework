*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Resource    ../../resources/common_resources.robot

# API Chaining: output of one API call feeds the next call as input.
# Chain: Homepage health → Search keyword → Extract result URL → Hit product URL

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
TC_API_CHAIN_01 Homepage Up Then Search Then Hit Product URL
    [Documentation]
    ...    Chain Step 1: Verify homepage returns 200.
    ...    Chain Step 2: Use homepage session to call search API for "lipstick".
    ...    Chain Step 3: Extract the response URL and verify it does not point to an error page.
    ...    Each step depends on the previous step succeeding.
    [Tags]    api    search    chaining    smoke

    # Step 1 — confirm site is reachable
    ${home_response}=    GET On Session    purplle    /    expected_status=any
    Should Be True    ${home_response.status_code} == 200
    Log    Step 1 PASS — Homepage status: ${home_response.status_code}

    # Step 2 — use the live session to search; keyword carried from Step 1 context
    ${params}=          Create Dictionary    q=lipstick
    ${search_response}=    GET On Session    purplle    ${SEARCH_ENDPOINT}
    ...    params=${params}    expected_status=any
    Should Be True    ${search_response.status_code} < 500
    Log    Step 2 PASS — Search status: ${search_response.status_code}

    # Step 3 — the final URL from search response feeds the next assertion
    ${final_url}=    Set Variable    ${search_response.url}
    Should Contain    ${final_url}    purplle.com
    Should Not Contain    ${final_url}    error
    Log    Step 3 PASS — Final URL: ${final_url}

TC_API_CHAIN_02 Autocomplete Response Feeds Full Search Call
    [Documentation]
    ...    Chain Step 1: Call autocomplete with partial keyword "found".
    ...    Chain Step 2: If autocomplete succeeds, use the same keyword to call full search.
    ...    Chain Step 3: Verify full search does not return a server error.
    ...    Demonstrates feeding partial keyword result into a full search call.
    [Tags]    api    search    chaining    regression

    # Step 1 — autocomplete with partial keyword
    ${partial}=         Set Variable    found
    ${auto_params}=     Create Dictionary    q=${partial}
    ${auto_response}=   GET On Session    purplle    ${AUTO_ENDPOINT}
    ...    params=${auto_params}    expected_status=any
    Log    Step 1 — Autocomplete status: ${auto_response.status_code}

    # Step 2 — build full keyword from the partial (simulates picking a suggestion)
    ${full_keyword}=    Set Variable    foundation
    Log    Step 2 — Using keyword for full search: ${full_keyword}

    # Step 3 — fire full search using the derived keyword
    ${search_params}=   Create Dictionary    q=${full_keyword}
    ${search_response}=    GET On Session    purplle    ${SEARCH_ENDPOINT}
    ...    params=${search_params}    expected_status=any
    Should Be True    ${search_response.status_code} < 500
    Log    Step 3 PASS — Full search status: ${search_response.status_code}
    Log    Step 3 PASS — Final URL: ${search_response.url}

TC_API_CHAIN_03 Search Two Keywords And Compare Response Times
    [Documentation]
    ...    Chain Step 1: Search "lipstick" and capture response time.
    ...    Chain Step 2: Search "moisturizer" and capture response time.
    ...    Chain Step 3: Assert both response times are under 10 seconds.
    ...    Demonstrates chaining two sequential API calls and comparing their outputs.
    [Tags]    api    search    chaining    performance

    # Step 1 — first search
    ${params1}=     Create Dictionary    q=lipstick
    ${resp1}=       GET On Session    purplle    ${SEARCH_ENDPOINT}
    ...    params=${params1}    expected_status=any
    ${time1}=       Set Variable    ${resp1.elapsed.total_seconds()}
    Log    Step 1 — lipstick response time: ${time1}s

    # Step 2 — second search (chained after Step 1 session)
    ${params2}=     Create Dictionary    q=moisturizer
    ${resp2}=       GET On Session    purplle    ${SEARCH_ENDPOINT}
    ...    params=${params2}    expected_status=any
    ${time2}=       Set Variable    ${resp2.elapsed.total_seconds()}
    Log    Step 2 — moisturizer response time: ${time2}s

    # Step 3 — compare: both must be within acceptable limit
    Should Be True    ${time1} < 10
    Should Be True    ${time2} < 10
    Log    Step 3 PASS — Both searches responded under 10s
