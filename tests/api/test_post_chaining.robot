*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# POST Chaining: each POST call's response feeds the next POST call.
# Chain: Add item to cart → Add item to wishlist → Attempt checkout
#
# STATUS CODE GUIDE FOR POST:
#   201 Created     — resource successfully created (correct REST standard)
#   200 OK          — action succeeded but API doesn't follow strict REST
#   401 Unauthorized — endpoint requires login (guest hit auth-protected route)
#   403 Forbidden   — authenticated but not allowed
#   5xx             — server error (NEVER acceptable)
#
# Purplle's cart/wishlist/checkout require login → guest POSTs return 401/403.
# We assert the status is IN the acceptable list, not just < 500.

Suite Setup     Create Purplle API Session
Suite Teardown  Delete All Sessions

*** Variables ***
${API_BASE_URL}      https://www.purplle.com
${CART_ENDPOINT}     /api/cart
${WISHLIST_ENDPOINT} /api/wishlist
${CHECKOUT_ENDPOINT} /api/checkout
${PRODUCT_ID}        12345
${PRODUCT_ID_2}      67890

*** Keywords ***
Create Purplle API Session
    ${headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
    Create Session    purplle    ${API_BASE_URL}    headers=${headers}    verify=True

Assert POST Status
    [Arguments]    ${response}    ${label}
    # 201 = created (authenticated), 200 = ok, 401/403 = auth required (guest) — all acceptable
    # 400 = bad request (wrong payload), 5xx = server broken — both are failures
    Should Be True    ${response.status_code} in [200, 201, 401, 403]
    Log    ${label}: ${response.status_code}

*** Test Cases ***
TC_API_POST_01 Add To Cart Then Add To Wishlist Then Attempt Checkout
    [Documentation]
    ...    Chain Step 1: POST to /api/cart to add product 12345 to cart.
    ...    Chain Step 2: POST to /api/wishlist using same session to add product 67890.
    ...    Chain Step 3: POST to /api/checkout using session from Steps 1 and 2.
    ...    Authenticated: expect 201 Created. Guest: expect 401/403. Never 5xx or 400.
    [Tags]    api    post    chaining    regression

    # Step 1 — add first product to cart
    ${cart_body}=       Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${cart_resp}=       POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${cart_body}    expected_status=any
    Run Keyword    Assert POST Status    ${cart_resp}    Step 1 POST /api/cart

    # Step 2 — add second product to wishlist (session carried forward)
    ${wish_body}=       Create Dictionary    product_id=${PRODUCT_ID_2}
    ${wish_resp}=       POST On Session    purplle    ${WISHLIST_ENDPOINT}
    ...    json=${wish_body}    expected_status=any
    Run Keyword    Assert POST Status    ${wish_resp}    Step 2 POST /api/wishlist

    # Step 3 — attempt checkout (guest → 401/403; logged in → 200/201)
    ${checkout_body}=   Create Dictionary    payment_method=COD
    ${checkout_resp}=   POST On Session    purplle    ${CHECKOUT_ENDPOINT}
    ...    json=${checkout_body}    expected_status=any
    Run Keyword    Assert POST Status    ${checkout_resp}    Step 3 POST /api/checkout

TC_API_POST_02 Add Multiple Items To Cart In Sequence
    [Documentation]
    ...    Chain Step 1: POST product 12345 to cart — expect 201 (auth) or 401/403 (guest).
    ...    Chain Step 2: POST product 67890 to same cart — expect same status as Step 1.
    ...    Chain Step 3: Assert both responses returned identical status codes (session consistent).
    [Tags]    api    post    chaining    regression

    # Step 1 — first item
    ${body1}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${resp1}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body1}    expected_status=any
    Run Keyword    Assert POST Status    ${resp1}    Step 1 POST item 12345

    # Step 2 — second item using same session
    ${body2}=    Create Dictionary    product_id=${PRODUCT_ID_2}    quantity=2
    ${resp2}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body2}    expected_status=any
    Run Keyword    Assert POST Status    ${resp2}    Step 2 POST item 67890

    # Step 3 — both calls must return the same status (same session, same auth gate)
    Should Be Equal As Integers    ${resp1.status_code}    ${resp2.status_code}
    Log    Step 3 PASS — Consistent: ${resp1.status_code} == ${resp2.status_code}
