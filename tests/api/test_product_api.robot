*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# NOTE: Verify actual API endpoint paths from browser DevTools Network tab.
# Common purplle API patterns are used here. Update if endpoints differ.

Suite Setup     Create Purplle API Session
Suite Teardown  Delete All Sessions

*** Variables ***
${API_BASE_URL}         https://www.purplle.com
${CATEGORIES_ENDPOINT}  /api/categories
${PRODUCTS_ENDPOINT}    /api/products
${CART_ENDPOINT}        /api/cart
${WISHLIST_ENDPOINT}    /api/wishlist

*** Keywords ***
Create Purplle API Session
    ${headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
    Create Session    purplle    ${API_BASE_URL}    headers=${headers}    verify=True

*** Test Cases ***
TC_API_PRODUCT_01 Categories Endpoint Responds Without Server Error
    [Documentation]
    ...    Verify the categories API endpoint does not return a 5xx server error.
    ...    Endpoint: GET /api/categories
    [Tags]    api    product    smoke
    ${response}=    GET On Session    purplle    ${CATEGORIES_ENDPOINT}    expected_status=any
    Should Be True    ${response.status_code} < 500
    Log    Categories status: ${response.status_code}

TC_API_PRODUCT_02 Products Endpoint Responds Without Server Error
    [Documentation]
    ...    Verify the products list API endpoint does not return a 5xx server error.
    ...    Endpoint: GET /api/products
    [Tags]    api    product    smoke
    ${response}=    GET On Session    purplle    ${PRODUCTS_ENDPOINT}    expected_status=any
    Should Be True    ${response.status_code} < 500
    Log    Products status: ${response.status_code}

TC_API_PRODUCT_03 Products Endpoint With Category Filter Responds
    [Documentation]
    ...    Verify the products endpoint with a category query parameter responds.
    ...    Endpoint: GET /api/products?category=makeup
    [Tags]    api    product    regression
    ${params}=    Create Dictionary    category=makeup
    ${response}=    GET On Session    purplle    ${PRODUCTS_ENDPOINT}    params=${params}    expected_status=any
    Should Be True    ${response.status_code} < 500
    Log    Products (makeup) status: ${response.status_code}

TC_API_PRODUCT_04 Cart Endpoint Returns Expected Status For Guest
    [Documentation]
    ...    Verify the cart API endpoint returns a non-5xx status code for an unauthenticated request.
    ...    Endpoint: GET /api/cart
    [Tags]    api    cart    regression
    ${response}=    GET On Session    purplle    ${CART_ENDPOINT}    expected_status=any
    Should Be True    ${response.status_code} < 500
    Log    Cart (guest) status: ${response.status_code}
    # A 401/403 is acceptable - it means auth is working; 5xx means server error

TC_API_PRODUCT_05 Wishlist Endpoint Returns Expected Status For Guest
    [Documentation]
    ...    Verify the wishlist API endpoint returns a non-5xx status code for an unauthenticated request.
    ...    Endpoint: GET /api/wishlist
    [Tags]    api    wishlist    regression
    ${response}=    GET On Session    purplle    ${WISHLIST_ENDPOINT}    expected_status=any
    Should Be True    ${response.status_code} < 500
    Log    Wishlist (guest) status: ${response.status_code}

TC_API_PRODUCT_06 Response Time For Homepage Is Under 10 Seconds
    [Documentation]
    ...    Verify that the homepage HTTP response arrives within 10 seconds (basic performance check).
    [Tags]    api    performance    smoke
    ${response}=    GET On Session    purplle    /    expected_status=any
    ${elapsed}=    Set Variable    ${response.elapsed.total_seconds()}
    Should Be True    ${elapsed} < 10
    Log    Homepage response time: ${elapsed}s

TC_API_PRODUCT_07 HTTPS Connection Is Enforced
    [Documentation]
    ...    Verify that the site is served over HTTPS by checking the response URL contains https.
    [Tags]    api    security    smoke
    ${response}=    GET On Session    purplle    /    expected_status=any
    Should Contain    ${response.url}    https
    Log    Final URL: ${response.url}
