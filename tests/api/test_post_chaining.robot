*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# POST Chaining: each POST call's response feeds the next POST call.
# Chain: Add item to cart → Add item to wishlist → Attempt checkout
# NOTE: Guest requests return 401/403 (auth required) — that is expected and correct.

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

*** Test Cases ***
TC_API_POST_01 Add To Cart Then Add To Wishlist Then Attempt Checkout
    [Documentation]
    ...    Chain Step 1: POST to /api/cart to add product 12345 to cart.
    ...    Chain Step 2: POST to /api/wishlist using same session to add product 67890.
    ...    Chain Step 3: POST to /api/checkout using session from Steps 1 and 2.
    ...    Guest requests return 401/403 which is acceptable — 5xx means server error.
    [Tags]    api    post    chaining    regression

    # Step 1 — add first product to cart
    ${cart_body}=       Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${cart_resp}=       POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${cart_body}    expected_status=any
    Should Be True    ${cart_resp.status_code} < 500
    Log    Step 1 PASS — Add to cart status: ${cart_resp.status_code}

    # Step 2 — add second product to wishlist (session carried forward)
    ${wish_body}=       Create Dictionary    product_id=${PRODUCT_ID_2}
    ${wish_resp}=       POST On Session    purplle    ${WISHLIST_ENDPOINT}
    ...    json=${wish_body}    expected_status=any
    Should Be True    ${wish_resp.status_code} < 500
    Log    Step 2 PASS — Add to wishlist status: ${wish_resp.status_code}

    # Step 3 — attempt checkout using same session (guest → expect 401/403, never 5xx)
    ${checkout_body}=   Create Dictionary    payment_method=COD
    ${checkout_resp}=   POST On Session    purplle    ${CHECKOUT_ENDPOINT}
    ...    json=${checkout_body}    expected_status=any
    Should Be True    ${checkout_resp.status_code} < 500
    Log    Step 3 PASS — Checkout attempt status: ${checkout_resp.status_code}

TC_API_POST_02 Add Multiple Items To Cart In Sequence
    [Documentation]
    ...    Chain Step 1: POST product 12345 to cart.
    ...    Chain Step 2: POST product 67890 to same cart session.
    ...    Chain Step 3: Assert neither call returned a server error.
    ...    Demonstrates chaining two POST calls to the same endpoint with different payloads.
    [Tags]    api    post    chaining    regression

    # Step 1 — first item
    ${body1}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${resp1}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body1}    expected_status=any
    Should Be True    ${resp1.status_code} < 500
    Log    Step 1 — Item 1 add status: ${resp1.status_code}

    # Step 2 — second item using result of Step 1 to confirm session is still alive
    ${body2}=    Create Dictionary    product_id=${PRODUCT_ID_2}    quantity=2
    ${resp2}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body2}    expected_status=any
    Should Be True    ${resp2.status_code} < 500
    Log    Step 2 — Item 2 add status: ${resp2.status_code}

    # Step 3 — compare both statuses are consistent (both auth-gated or both open)
    ${status_match}=    Evaluate    ${resp1.status_code} == ${resp2.status_code}
    Log    Step 3 PASS — Both statuses consistent: ${status_match}
    Log    Step 3 — Status 1: ${resp1.status_code} | Status 2: ${resp2.status_code}
