*** Comments ***
================================================================================
  KEYWORD REFERENCE — Purplle.com Robot Framework Test Suite
================================================================================
  This file documents every keyword used in the framework, grouped by library.
  It is a reference-only file — it is NOT executable.
  Import path: docs/keyword_reference.robot

  SECTIONS:
    1. SeleniumLibrary     — browser automation keywords
    2. RequestsLibrary     — HTTP / REST API keywords
    3. Collections         — list and dictionary keywords
    4. BuiltIn             — Robot Framework built-in keywords
    5. Custom Keywords     — keywords defined in resources/

================================================================================


================================================================================
  SECTION 1 — SeleniumLibrary
  Import: Library    SeleniumLibrary
  Used in: resources/common_resources.robot, resources/pages/*.robot,
           tests/functional/*, tests/integration/*, tests/e2e/*
================================================================================

# ── Browser Lifecycle ──────────────────────────────────────────────────────────

# Open Browser
#   Purpose : Launch a new browser window and navigate to a URL.
#   Syntax  : Open Browser    <url>    <browser>
#   Usage   :
#       Open Browser    https://www.purplle.com    chrome
#       Open Browser    ${BASE_URL}    ${BROWSER}
#       Open Browser    ${url}    ${BROWSER}
#       ...    options=add_argument("--headless=new");add_argument("--no-sandbox")
#   Notes   : ${BROWSER} defaults to chrome. Pass options= for headless/flags.
#             Called inside custom keyword Open Application in common_resources.

# Maximize Browser Window
#   Purpose : Maximize the browser window to full screen.
#   Syntax  : Maximize Browser Window
#   Usage   :
#       Maximize Browser Window
#   Notes   : Called right after Open Browser inside Open Application.

# Close All Browsers
#   Purpose : Close every open browser session managed by SeleniumLibrary.
#   Syntax  : Close All Browsers
#   Usage   :
#       Close All Browsers
#   Notes   : Used inside custom keyword Close Application for Suite Teardown.

# ── Navigation ─────────────────────────────────────────────────────────────────

# Go To
#   Purpose : Navigate the current browser to a given URL.
#   Syntax  : Go To    <url>
#   Usage   :
#       Go To    ${BASE_URL}
#       Go To    ${BASE_URL}/search?q=${keyword}
#       Go To    https://www.purplle.com/cart
#       Go To    https://www.purplle.com/makeup
#       Go To    https://www.purplle.com/profile/myfavourites
#       Go To    ${MAKEUP_URL}
#       Go To    ${SKINCARE_URL}
#       Go To    ${HAIR_URL}
#   Notes   : Used heavily in Test Setup and inside page keywords.
#             Purplle is Angular — search requires direct URL navigation,
#             pressing ENTER on the search bar does not trigger navigation.

# Location Should Be
#   Purpose : Assert the current URL matches exactly.
#   Syntax  : Location Should Be    <expected_url>
#   Usage   :
#       Location Should Be    https://www.purplle.com/
#   Notes   : Use for exact URL match. Use Location Should Contain for partial.

# Location Should Contain
#   Purpose : Assert the current URL contains a substring.
#   Syntax  : Location Should Contain    <substring>
#   Usage   :
#       Location Should Contain    myfavourites
#   Notes   : Preferred over Location Should Be when query strings may vary.

# ── Waits ──────────────────────────────────────────────────────────────────────

# Wait Until Element Is Visible
#   Purpose : Pause test execution until an element becomes visible on the page.
#             Fails if the element is not visible within the timeout.
#   Syntax  : Wait Until Element Is Visible    <locator>    timeout=<time>
#   Usage   :
#       Wait Until Element Is Visible    ${LOGO}
#       Wait Until Element Is Visible    ${FIRST_PRODUCT_CARD}    timeout=15s
#       Wait Until Element Is Visible    ${EMPTY_CART_MESSAGE}    timeout=15s
#       Wait Until Element Is Visible    ${MOBILE_INPUT}    timeout=10s
#       Wait Until Element Is Visible    ${PRODUCT_NAME}    timeout=15s
#       Wait Until Element Is Visible    ${WISHLIST_PAGE_HEADING}    timeout=15s
#       Wait Until Element Is Visible    ${SEARCH_SUGGESTION_BOX}    timeout=5s
#       Wait Until Element Is Visible    xpath=//h1    timeout=15s
#   Notes   : ALWAYS use this instead of Sleep. Default timeout is ${TIMEOUT} (15s).
#             Never use Sleep — it is fragile and wastes time.

# ── Interaction ────────────────────────────────────────────────────────────────

# Click Element
#   Purpose : Click on any DOM element identified by a locator.
#   Syntax  : Click Element    <locator>
#   Usage   :
#       Click Element    ${LOGO}
#       Click Element    ${FIRST_PRODUCT_CARD}
#       Click Element    ${FIRST_PRODUCT}
#       Click Element    ${ADD_TO_BAG_BTN}
#       Click Element    ${SORT_DROPDOWN}
#       Click Element    ${SORT_PRICE_LOW_HIGH}
#       Click Element    ${SORT_PRICE_HIGH_LOW}
#       Click Element    ${SORT_POPULARITY}
#       Click Element    ${NAV_MAKEUP}
#       Click Element    ${NAV_SKINCARE}
#       Click Element    ${NAV_HAIR}
#       Click Element    ${NAV_BRANDS}
#       Click Element    ${NAV_OFFERS}
#       Click Element    ${NAV_NEW}
#       Click Element    ${NAV_SPLURGE}
#       Click Element    ${WISHLIST_ICON}
#       Click Element    ${CART_ICON}
#       Click Element    ${SEARCH_INPUT}
#       Click Element    ${SEARCH_SUGGESTION_ITEM}
#       Click Element    ${REMOVE_BTN}
#       Click Element    ${REMOVE_FROM_WISHLIST_BTN}
#       Click Element    ${MOVE_TO_BAG_BTN}
#       Click Element    ${QUANTITY_PLUS}
#       Click Element    ${QUANTITY_MINUS}
#       Click Element    ${PROCEED_TO_CHECKOUT_BTN}
#       Click Element    ${CONTINUE_SHOPPING_BTN}
#       Click Element    ${APPLY_COUPON_BTN}
#       Click Element    ${LOAD_MORE_BTN}
#       Click Element    ${BRAND_FILTER_HEADING}
#       Click Element    ${PRICE_FILTER_HEADING}
#       Click Element    ${LOGIN_REGISTER_LINK}
#       Click Element    ${EMAIL_LOGIN_TAB}
#       Click Element    ${PRODUCT_BRAND}
#       Click Element    ${category_locator}
#       Click Element    xpath=//label[contains(text(),'${brand_name}')]
#   Notes   : Locators must be defined in locators/*_locators.robot.
#             Never hardcode locators inside test cases.

# Click Button
#   Purpose : Click a <button> element. Semantically clearer than Click Element.
#   Syntax  : Click Button    <locator>
#   Usage   :
#       Click Button    ${GET_OTP_BUTTON}
#       Click Button    ${VERIFY_OTP_BUTTON}
#       Click Button    ${LOGIN_SUBMIT_BTN}
#   Notes   : Use for actual <button> tags. Use Click Element for <a>, <div>, etc.

# Click Link
#   Purpose : Click an <a> (anchor/link) element.
#   Syntax  : Click Link    <locator_or_text>
#   Usage   :
#       Click Link    ${LOGIN_REGISTER_LINK}
#   Notes   : Functionally same as Click Element but signals intent — it's a link.

# Input Text
#   Purpose : Type text into an input or textarea field.
#   Syntax  : Input Text    <locator>    <text>
#   Usage   :
#       Input Text    ${SEARCH_INPUT}    ${keyword}
#       Input Text    ${SEARCH_INPUT}    kajal
#       Input Text    ${SEARCH_INPUT}    lipst
#       Input Text    ${MOBILE_INPUT}    ${mobile}
#       Input Text    ${OTP_INPUT}    ${otp}
#       Input Text    ${EMAIL_INPUT}    ${email}
#       Input Text    ${PASSWORD_INPUT}    ${password}
#       Input Text    ${COUPON_INPUT}    ${coupon_code}
#   Notes   : Clears the field before typing. Use Clear Element Text first
#             if the field already has content and you need to replace it.

# Clear Element Text
#   Purpose : Clear all existing text from an input field.
#   Syntax  : Clear Element Text    <locator>
#   Usage   :
#       Clear Element Text    ${MOBILE_INPUT}
#   Notes   : Used before re-entering text in the same field (e.g. invalid → valid input).

# Press Keys
#   Purpose : Simulate keyboard key presses on a focused element.
#   Syntax  : Press Keys    <locator>    <key>
#   Usage   :
#       Press Keys    ${SEARCH_INPUT}    RETURN
#   Notes   : On Purplle (Angular app) pressing RETURN in search does NOT navigate.
#             Use Go To with the search URL instead for reliable navigation.

# Scroll Element Into View
#   Purpose : Scroll the page until the element is within the visible viewport.
#   Syntax  : Scroll Element Into View    <locator>
#   Usage   :
#       Scroll Element Into View    ${REVIEWS_SECTION}
#       Scroll Element Into View    ${SIMILAR_PRODUCTS}
#       Scroll Element Into View    ${LOAD_MORE_BTN}
#   Notes   : Useful for lazy-loaded sections and infinite-scroll pages.

# ── Assertions ─────────────────────────────────────────────────────────────────

# Element Should Be Visible
#   Purpose : Assert that an element is present and visible on the page RIGHT NOW.
#             Does not wait — use Wait Until Element Is Visible to wait first.
#   Syntax  : Element Should Be Visible    <locator>
#   Usage   :
#       Element Should Be Visible    ${LOGO}
#       Element Should Be Visible    ${SEARCH_INPUT}
#       Element Should Be Visible    ${CART_ICON}
#       Element Should Be Visible    ${NAV_BRANDS}
#       Element Should Be Visible    ${NAV_OFFERS}
#       Element Should Be Visible    ${NAV_SKINCARE}
#       Element Should Be Visible    ${MOBILE_INPUT}
#       Element Should Be Visible    ${GET_OTP_BUTTON}
#       Element Should Be Visible    ${LOGIN_REGISTER_LINK}
#       Element Should Be Visible    ${SIGNUP_LINK}
#       Element Should Be Visible    ${ERROR_MESSAGE}
#       Element Should Be Visible    ${PRODUCT_NAME}
#       Element Should Be Visible    ${PRODUCT_PRICE}
#       Element Should Be Visible    ${PRODUCT_MRP}
#       Element Should Be Visible    ${PRODUCT_IMAGE}
#       Element Should Be Visible    ${PRODUCT_BRAND}
#       Element Should Be Visible    ${PRODUCT_DESCRIPTION}
#       Element Should Be Visible    ${REVIEWS_SECTION}
#       Element Should Be Visible    ${SIMILAR_PRODUCTS}
#       Element Should Be Visible    ${ADD_TO_BAG_BTN}
#       Element Should Be Visible    ${WISHLIST_ICON}
#       Element Should Be Visible    ${EMPTY_CART_MESSAGE}
#       Element Should Be Visible    ${CONTINUE_SHOPPING_BTN}
#       Element Should Be Visible    ${CART_PAGE_HEADING}
#       Element Should Be Visible    ${EMPTY_WISHLIST_MESSAGE}
#       Element Should Be Visible    ${WISHLIST_PAGE_HEADING}
#       Element Should Be Visible    ${LOGIN_TO_VIEW_WISHLIST}
#       Element Should Be Visible    ${SEARCH_SUGGESTION_BOX}
#       Element Should Be Visible    ${NO_RESULTS_MESSAGE}
#       Element Should Be Visible    ${CATEGORY_HEADING}
#       Element Should Be Visible    ${BRAND_FILTER_HEADING}
#       Element Should Be Visible    ${PRICE_FILTER_HEADING}
#       Element Should Be Visible    xpath=//h1

# Page Should Contain Element
#   Purpose : Assert that an element exists anywhere on the page (visible or not).
#   Syntax  : Page Should Contain Element    <locator>
#   Usage   :
#       Page Should Contain Element    ${PRODUCT_CARDS}
#       Page Should Contain Element    ${FIRST_PRODUCT_CARD}
#       Page Should Contain Element    ${FIRST_FEATURED_PRODUCT}
#       Page Should Contain Element    ${CART_ITEMS}
#       Page Should Contain Element    ${WISHLIST_ITEMS}
#   Notes   : Does not require the element to be visible. Use for presence checks.

# Page Should Not Contain Element
#   Purpose : Assert that an element does NOT exist anywhere on the page.
#   Syntax  : Page Should Not Contain Element    <locator>
#   Usage   :
#       Page Should Not Contain Element    ${PROCEED_TO_CHECKOUT_BTN}
#   Notes   : Useful for asserting empty states (e.g. cart has no checkout button).

# ── Data Retrieval ─────────────────────────────────────────────────────────────

# Get Title
#   Purpose : Return the current page title as a string.
#   Syntax  : ${title}=    Get Title
#   Usage   :
#       ${title}=    Get Title
#       Should Contain    ${title}    Purplle
#   Notes   : Used inside custom keyword Title Should Contain in common_resources.
#             SeleniumLibrary only has Title Should Be (exact match).
#             Title Should Contain is a custom keyword in common_resources.robot.

# Get Text
#   Purpose : Return the visible text content of an element as a string.
#   Syntax  : ${var}=    Get Text    <locator>
#   Usage   :
#       ${name}=     Get Text    ${PRODUCT_NAME}
#       ${price}=    Get Text    ${PRODUCT_PRICE}
#       ${brand}=    Get Text    ${PRODUCT_BRAND}
#       ${rating}=   Get Text    ${RATING_VALUE}
#       ${count}=    Get Text    ${SEARCH_RESULTS_COUNT}
#       ${heading}=  Get Text    ${CATEGORY_HEADING}
#       ${total}=    Get Text    ${CART_TOTAL}
#       ${message}=  Get Text    ${ERROR_MESSAGE}
#   Notes   : Returns inner text (not HTML). Use to capture values for assertions.

# Get WebElements
#   Purpose : Return a list of all matching WebElement objects for a locator.
#   Syntax  : ${list}=    Get WebElements    <locator>
#   Usage   :
#       ${items}=    Get WebElements    ${CART_ITEMS}
#       ${items}=    Get WebElements    ${WISHLIST_ITEMS}
#   Notes   : Returns a Python list. Use Get Length / len() to count items.
#             Each item is a Selenium WebElement — can call .text, .click(), etc.

# ── Configuration ──────────────────────────────────────────────────────────────

# Set Selenium Implicit Wait
#   Purpose : Set the global implicit wait timeout for all element lookups.
#   Syntax  : Set Selenium Implicit Wait    <time>
#   Usage   :
#       Set Selenium Implicit Wait    ${IMPLICIT_WAIT}    # 10s
#   Notes   : Set once in Open Application. Applies to all subsequent keywords.
#             Implicit wait runs silently on every element search.

# Set Selenium Timeout
#   Purpose : Set the global explicit timeout for SeleniumLibrary keywords.
#   Syntax  : Set Selenium Timeout    <time>
#   Usage   :
#       Set Selenium Timeout    ${TIMEOUT}    # 15s
#   Notes   : Used by Wait Until Element Is Visible when no timeout= is given.

# Set Screenshot Directory
#   Purpose : Set the folder where failure screenshots are automatically saved.
#   Syntax  : Set Screenshot Directory    <path>
#   Usage   :
#       Set Screenshot Directory    ${SCREENSHOT_DIR}    # outputs/screenshots/
#   Notes   : Called in Open Application. Screenshots are captured automatically
#             by SeleniumLibrary on any keyword failure.


================================================================================
  SECTION 2 — RequestsLibrary
  Import: Library    RequestsLibrary
  Used in: tests/api/*.robot
================================================================================

# ── Session Management ─────────────────────────────────────────────────────────

# Create Session
#   Purpose : Create a named HTTP session with a base URL and default headers.
#             All subsequent HTTP calls use this session by name.
#   Syntax  : Create Session    <alias>    <base_url>    headers=<dict>    verify=<bool>
#   Usage   :
#       ${headers}=    Create Dictionary
#       ...    Accept=application/json
#       ...    Content-Type=application/json
#       ...    User-Agent=Mozilla/5.0 ...
#       Create Session    purplle    https://www.purplle.com
#       ...    headers=${headers}    verify=True
#   Notes   : alias="purplle" is used in all On Session calls.
#             verify=True enables SSL certificate validation.
#             Called in Suite Setup via Create Purplle API Session keyword.

# Delete All Sessions
#   Purpose : Close and delete all active HTTP sessions.
#   Syntax  : Delete All Sessions
#   Usage   :
#       Delete All Sessions
#   Notes   : Called in Suite Teardown to clean up session resources.

# ── HTTP Methods ───────────────────────────────────────────────────────────────

# GET On Session
#   Purpose : Send an HTTP GET request to retrieve a resource.
#   Syntax  : GET On Session    <alias>    <endpoint>    params=<dict>    expected_status=<any|code>
#   Expected status codes: 200 OK | 301/302 redirect | 401/403 auth | 404 not found
#   Usage   :
#       ${response}=    GET On Session    purplle    /    expected_status=any
#       ${response}=    GET On Session    purplle    /api/search    params=${params}    expected_status=any
#       ${response}=    GET On Session    purplle    /api/autocomplete    params=${params}    expected_status=any
#       ${response}=    GET On Session    purplle    /api/cart    expected_status=any
#       ${response}=    GET On Session    purplle    /api/wishlist    expected_status=any
#       ${response}=    GET On Session    purplle    /api/profile    expected_status=any
#       ${response}=    GET On Session    purplle    /api/products    expected_status=any
#       ${response}=    GET On Session    purplle    /api/categories    expected_status=any
#   Notes   : Use expected_status=any to suppress auto-fail on non-2xx.
#             Then assert manually: Should Be True ${response.status_code} in [200, 401, 403]

# POST On Session
#   Purpose : Send an HTTP POST request to create a resource.
#   Syntax  : POST On Session    <alias>    <endpoint>    json=<dict>    expected_status=<any|code>
#   Expected status codes: 201 Created | 200 OK | 401/403 auth (guest)
#   Usage   :
#       ${response}=    POST On Session    purplle    /api/cart    json=${body}    expected_status=any
#       ${response}=    POST On Session    purplle    /api/wishlist    json=${body}    expected_status=any
#       ${response}=    POST On Session    purplle    /api/checkout    json=${body}    expected_status=any
#       ${response}=    POST On Session    purplle    /api/profile    json=${body}    expected_status=any
#   Notes   : 201 Created is the correct REST standard for a successful creation.
#             Purplle's endpoints are auth-gated — guest calls return 401/403.
#             NEVER assert < 500 — that masks 400 Bad Request errors.

# PUT On Session
#   Purpose : Send an HTTP PUT request to fully replace a resource.
#             All fields of the resource must be sent — replaces the whole object.
#   Syntax  : PUT On Session    <alias>    <endpoint>    json=<dict>    expected_status=<any|code>
#   Expected status codes: 200 OK (body returned) | 204 No Content | 401/403 auth
#   Usage   :
#       ${response}=    PUT On Session    purplle    /api/cart/items/12345    json=${body}    expected_status=any
#       ${response}=    PUT On Session    purplle    /api/profile    json=${body}    expected_status=any
#       ${response}=    PUT On Session    purplle    /api/profile/preferences    json=${body}    expected_status=any
#       ${response}=    PUT On Session    purplle    /api/wishlist/items/12345    json=${body}    expected_status=any
#   Notes   : PUT differs from PATCH — PUT replaces the entire resource.
#             Missing fields in the payload will be set to null/default.

# PATCH On Session
#   Purpose : Send an HTTP PATCH request to partially update a resource.
#             Only the fields included in the payload are changed; others stay.
#   Syntax  : PATCH On Session    <alias>    <endpoint>    json=<dict>    expected_status=<any|code>
#   Expected status codes: 200 OK (body returned) | 204 No Content | 401/403 auth
#   Usage   :
#       ${response}=    PATCH On Session    purplle    /api/cart/items/12345    json=${qty}    expected_status=any
#       ${response}=    PATCH On Session    purplle    /api/profile    json=${name_patch}    expected_status=any
#       ${response}=    PATCH On Session    purplle    /api/wishlist/items/12345    json=${note}    expected_status=any
#   Notes   : PATCH differs from PUT — PATCH only modifies named fields.
#             Ideal for fine-tuning a single field without resending full payload.

# DELETE On Session
#   Purpose : Send an HTTP DELETE request to remove a resource.
#   Syntax  : DELETE On Session    <alias>    <endpoint>    expected_status=<any|code>
#   Expected status codes: 200 OK | 204 No Content | 401/403 auth | 404 already gone
#   Usage   :
#       ${response}=    DELETE On Session    purplle    /api/cart/items/12345    expected_status=any
#       ${response}=    DELETE On Session    purplle    /api/wishlist/items/67890    expected_status=any
#       ${response}=    DELETE On Session    purplle    /api/profile    expected_status=any
#   Notes   : 204 No Content is the most common success status for DELETE.
#             404 is acceptable — means the resource was already deleted.
#             401/403 expected for guest calls on auth-protected endpoints.

# ── Response Object Properties ─────────────────────────────────────────────────
# After any On Session call, the response object exposes:
#
#   ${response.status_code}          — integer HTTP status (200, 201, 404, etc.)
#   ${response.text}                 — raw response body as a string
#   ${response.url}                  — final URL after redirects
#   ${response.json()}               — parsed JSON body → Python dict or list
#   ${response.elapsed.total_seconds()} — response time in seconds (float)
#   ${response.headers}              — response headers dict
#
#   Usage examples:
#       Should Be True    ${response.status_code} in [200, 201, 401, 403]
#       Should Contain    ${response.url}    purplle.com
#       ${elapsed}=    Set Variable    ${response.elapsed.total_seconds()}
#       Should Be True    ${elapsed} < 10
#       ${json}=    Set Variable    ${response.json()}
#       Should Not Be Empty    ${json}


================================================================================
  SECTION 3 — Collections Library
  Import: Library    Collections
  Used in: tests/api/*.robot
================================================================================

# Create Dictionary
#   Purpose : Create a Python dictionary (key=value pairs).
#             Used to build request bodies, query params, and headers.
#   Syntax  : ${dict}=    Create Dictionary    key1=value1    key2=value2    ...
#   Usage   :
#       ${headers}=    Create Dictionary
#       ...    Accept=application/json
#       ...    Content-Type=application/json
#       ...    User-Agent=Mozilla/5.0 ...
#
#       ${params}=    Create Dictionary    q=lipstick
#       ${params}=    Create Dictionary    category=makeup
#       ${params}=    Create Dictionary    q=lips
#
#       ${body}=    Create Dictionary    product_id=12345    quantity=1
#       ${body}=    Create Dictionary    product_id=${PRODUCT_ID}
#       ${body}=    Create Dictionary    payment_method=COD
#       ${body}=    Create Dictionary    name=Suraj    email=suraj@example.com    phone=9876543210
#       ${body}=    Create Dictionary    email_notifications=true    sms_notifications=false
#   Notes   : The most frequently used Collections keyword in this suite.
#             Used for every HTTP request payload and params block.

# Get From Dictionary
#   Purpose : Extract the value for a specific key from a dictionary.
#   Syntax  : ${val}=    Get From Dictionary    <dict>    <key>
#   Usage   :
#       ${val}=    Get From Dictionary    ${json}    products
#   Notes   : Raises KeyError if key is absent. Use Dictionary Should Contain Key first.

# Get From List
#   Purpose : Extract an item from a list by its index.
#   Syntax  : ${item}=    Get From List    <list>    <index>
#   Usage   :
#       ${first}=    Get From List    ${items}    0
#   Notes   : Index 0 = first item. Negative indices count from the end (-1 = last).

# Dictionary Should Contain Key
#   Purpose : Assert that a dictionary contains a specific key.
#   Syntax  : Dictionary Should Contain Key    <dict>    <key>
#   Usage   :
#       Dictionary Should Contain Key    ${json}    products
#       Dictionary Should Contain Key    ${json}    status
#   Notes   : Used to validate JSON response structure after ${response.json()}.

# Length Should Be
#   Purpose : Assert the length of a list or dictionary equals an expected value.
#   Syntax  : Length Should Be    <collection>    <expected_length>
#   Usage   :
#       Length Should Be    ${items}    3
#   Notes   : Works on lists, dicts, and strings.

# Should Not Be Empty
#   Purpose : Assert that a list, dictionary, or string is not empty.
#   Syntax  : Should Not Be Empty    <collection_or_string>
#   Usage   :
#       Should Not Be Empty    ${json}
#       Should Not Be Empty    ${items}
#   Notes   : Fails if the value is [], {}, or "".


================================================================================
  SECTION 4 — BuiltIn Library (always available, no import needed)
================================================================================

# Set Variable
#   Purpose : Assign any value to a variable.
#   Syntax  : ${var}=    Set Variable    <value>
#   Usage   :
#       ${json}=        Set Variable    ${response.json()}
#       ${final_url}=   Set Variable    ${search_response.url}
#       ${elapsed}=     Set Variable    ${response.elapsed.total_seconds()}
#       ${full_keyword}=    Set Variable    foundation
#       ${partial}=     Set Variable    found
#   Notes   : Used to alias response properties into cleaner variable names.

# Should Be True
#   Purpose : Assert that a Python expression evaluates to True.
#   Syntax  : Should Be True    <expression>
#   Usage   :
#       Should Be True    ${response.status_code} in [200, 201, 401, 403]
#       Should Be True    ${response.status_code} in [200, 204, 401, 403]
#       Should Be True    ${response.status_code} in [200, 204, 401, 403, 404]
#       Should Be True    ${response.status_code} in [200, 301, 302, 401, 403]
#       Should Be True    ${response.status_code} == 200
#       Should Be True    ${elapsed} < 10
#       Should Be True    ${both_auth_gated} or ${both_succeeded}
#   Notes   : Accepts any Python expression. Preferred over Should Be Equal
#             when checking membership (in []) or comparisons (< > ==).

# Should Be Equal As Integers
#   Purpose : Assert two values are equal when treated as integers.
#   Syntax  : Should Be Equal As Integers    <actual>    <expected>
#   Usage   :
#       Should Be Equal As Integers    ${resp1.status_code}    ${resp2.status_code}
#       Should Be Equal As Integers    ${put_resp.status_code}    ${patch_resp.status_code}
#   Notes   : Used to verify two chained API calls returned the same status code.
#             Safer than == comparison for HTTP status codes.

# Should Contain
#   Purpose : Assert that a string or list contains a specific substring or item.
#   Syntax  : Should Contain    <container>    <item>
#   Usage   :
#       Should Contain    ${title}    Purplle
#       Should Contain    ${response.url}    purplle.com
#       Should Contain    ${response.url}    https
#   Notes   : Case-sensitive. Use for partial URL and page title checks.

# Should Not Contain
#   Purpose : Assert that a string does NOT contain a specific substring.
#   Syntax  : Should Not Contain    <container>    <item>
#   Usage   :
#       Should Not Contain    ${final_url}    error
#   Notes   : Useful for verifying redirect URLs did not land on an error page.

# Evaluate
#   Purpose : Evaluate a Python expression and return the result.
#   Syntax  : ${result}=    Evaluate    <python_expression>    [modules]
#   Usage   :
#       ${status_match}=    Evaluate    ${resp1.status_code} == ${resp2.status_code}
#       ${both_auth_gated}=    Evaluate
#       ...    ${post_resp.status_code} in [401,403] and ${del_resp.status_code} in [401,403,404]
#       ${both_succeeded}=     Evaluate
#       ...    ${post_resp.status_code} in [200,201] and ${del_resp.status_code} in [200,204]
#   Notes   : Useful for multi-condition boolean logic in test assertions.
#             Pass module names as the second argument to use Python stdlib.

# Log
#   Purpose : Write a message to the Robot Framework log (log.html).
#   Syntax  : Log    <message>    [level]
#   Usage   :
#       Log    Step 1 PASS — Homepage status: ${response.status_code}
#       Log    Response body (first 500 chars): ${response.text}[:500]
#       Log    Final URL: ${response.url}
#       Log    CRUD Chain complete — POST:${post_resp.status_code} ...
#   Notes   : Default level is INFO. Use DEBUG/WARN for other levels.
#             All Log output is visible in outputs/log.html.

# Run Keyword
#   Purpose : Call another keyword by name dynamically.
#   Syntax  : Run Keyword    <keyword_name>    [args]
#   Usage   :
#       Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST /api/cart
#       Run Keyword    Assert GET Status     ${get_resp}    Step 2 GET (Read)
#       Run Keyword    Assert PUT Status     ${put_resp}    Step 3 PUT (Full Update)
#       Run Keyword    Assert PATCH Status   ${patch_resp}  Step 4 PATCH (Partial)
#       Run Keyword    Assert DELETE Status  ${del_resp}    Step 5 DELETE (Remove)
#       Run Keyword    Assert No Server Error    ${response}    Step label
#   Notes   : Used to call custom Assert keywords by name from within test cases.

# Run Keyword If
#   Purpose : Call a keyword conditionally if an expression is true.
#   Syntax  : Run Keyword If    <condition>    <keyword>    [args]
#   Usage   :
#       Run Keyword If    ${response.status_code} == 200    Verify JSON Response    ${response}
#   Notes   : Skips keyword silently if condition is false. Use in API tests
#             where response structure only exists on 200 responses.

# Run Keyword And Return Status
#   Purpose : Run a keyword and return True/False instead of failing.
#   Syntax  : ${status}=    Run Keyword And Return Status    <keyword>    [args]
#   Usage   :
#       ${suggestion_found}=    Run Keyword And Return Status
#       ...    Wait Until Element Is Visible    ${SEARCH_SUGGESTION_BOX}    timeout=5s
#   Notes   : Captures expected failures gracefully for optional/conditional UI elements.


================================================================================
  SECTION 5 — Custom Keywords (defined in resources/)
================================================================================

# Open Application    [resources/common_resources.robot]
#   Purpose : Browser setup — open browser, maximize, set timeouts and screenshot dir.
#   Syntax  : Open Application    [url=${BASE_URL}]
#   Usage   :
#       Suite Setup    Open Application
#       Open Application    https://www.purplle.com/login
#   Notes   : Wraps Open Browser with headless support, implicit wait, timeout,
#             and screenshot directory setup. Use this instead of raw Open Browser.

# Close Application    [resources/common_resources.robot]
#   Purpose : Close all open browsers.
#   Syntax  : Close Application
#   Usage   :
#       Suite Teardown    Close Application
#   Notes   : Wraps Close All Browsers. Always use in Suite Teardown.

# Title Should Contain    [resources/common_resources.robot]
#   Purpose : Assert the page title contains a substring (partial match).
#   Syntax  : Title Should Contain    <expected_substring>
#   Usage   :
#       Title Should Contain    Purplle
#       Title Should Contain    lipstick
#   Notes   : SeleniumLibrary only provides Title Should Be (exact match).
#             This custom keyword uses Get Title + Should Contain for partial match.

# Create Purplle API Session    [tests/api/*.robot]
#   Purpose : Create the shared HTTP session with JSON headers for all API tests.
#   Syntax  : Create Purplle API Session
#   Usage   :
#       Suite Setup    Create Purplle API Session
#   Notes   : Defined locally in each API test file. Sets Accept, Content-Type,
#             User-Agent headers and calls Create Session with alias "purplle".

# Assert POST Status    [tests/api/test_post_chaining.robot, test_crud_chaining.robot, etc.]
#   Purpose : Assert POST response is in the accepted status list [200, 201, 401, 403].
#   Syntax  : Assert POST Status    <response>    <label>
#   Usage   :
#       Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST /api/cart
#   Notes   : 201 = resource created. 401/403 = guest auth gate. 400/5xx = failure.

# Assert GET Status    [tests/api/test_crud_chaining.robot, test_api_chaining.robot]
#   Purpose : Assert GET response is in the accepted status list [200, 301, 302, 401, 403].
#   Syntax  : Assert GET Status    <response>    <label>
#   Usage   :
#       Run Keyword    Assert GET Status    ${get_resp}    Step 2 GET (Read)

# Assert PUT Status    [tests/api/test_put_chaining.robot, test_crud_chaining.robot, etc.]
#   Purpose : Assert PUT response is in the accepted status list [200, 204, 401, 403].
#   Syntax  : Assert PUT Status    <response>    <label>
#   Usage   :
#       Run Keyword    Assert PUT Status    ${put_resp}    Step 3 PUT (Full Update)

# Assert PATCH Status    [tests/api/test_patch_chaining.robot, test_crud_chaining.robot, etc.]
#   Purpose : Assert PATCH response is in the accepted status list [200, 204, 401, 403].
#   Syntax  : Assert PATCH Status    <response>    <label>
#   Usage   :
#       Run Keyword    Assert PATCH Status    ${patch_resp}    Step 4 PATCH (Partial)

# Assert DELETE Status    [tests/api/test_delete_chaining.robot, test_crud_chaining.robot, etc.]
#   Purpose : Assert DELETE response is in accepted list [200, 204, 401, 403, 404].
#   Syntax  : Assert DELETE Status    <response>    <label>
#   Usage   :
#       Run Keyword    Assert DELETE Status    ${del_resp}    Step 5 DELETE (Remove)

# Assert Search GET Status    [tests/api/test_api_chaining.robot]
#   Purpose : Assert search/autocomplete GET response in [200, 301, 302, 401, 403, 404].
#             404 is included because search endpoint paths are best-guess patterns.
#   Syntax  : Assert Search GET Status    <response>    <label>
#   Usage   :
#       Run Keyword    Assert Search GET Status    ${search_response}    Step 2 GET /api/search

# Verify JSON Response    [tests/api/test_search_api.robot]
#   Purpose : Assert JSON response body is parseable and not empty.
#   Syntax  : Verify JSON Response    <response>
#   Usage   :
#       Run Keyword If    ${response.status_code} == 200    Verify JSON Response    ${response}
#   Notes   : Only called when status is 200. Parses response.json() and checks
#             Should Not Be Empty.

================================================================================
  END OF KEYWORD REFERENCE
================================================================================
