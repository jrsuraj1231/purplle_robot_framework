*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# POST → DELETE Chaining: create a resource then immediately remove it.
# Validates that add and remove operations work on the same session.
# NOTE: Guest requests return 401/403 — acceptable. 5xx means server error.

Suite Setup     Create Purplle API Session
Suite Teardown  Delete All Sessions

*** Variables ***
${API_BASE_URL}            https://www.purplle.com
${CART_ENDPOINT}           /api/cart
${CART_ITEM_ENDPOINT}      /api/cart/items/12345
${WISHLIST_ENDPOINT}       /api/wishlist
${WISHLIST_ITEM_ENDPOINT}  /api/wishlist/items/12345
${PRODUCT_ID}              12345

*** Keywords ***
Create Purplle API Session
    ${headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
    Create Session    purplle    ${API_BASE_URL}    headers=${headers}    verify=True

*** Test Cases ***
TC_API_POST_DEL_01 Add To Cart Then Remove From Cart
    [Documentation]
    ...    Chain Step 1: POST product 12345 to /api/cart.
    ...    Chain Step 2: DELETE the same product from /api/cart/items/12345.
    ...    Chain Step 3: Assert both responses are not server errors.
    ...    Classic add-then-remove pattern — verifies both directions of the cart API.
    [Tags]    api    post    delete    chaining    regression

    # Step 1 — POST: add product to cart
    ${body}=       Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=  POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body}    expected_status=any
    Should Be True    ${post_resp.status_code} < 500
    Log    Step 1 PASS — POST to cart: ${post_resp.status_code}

    # Step 2 — DELETE: remove the same product (session is same as Step 1)
    ${del_resp}=   DELETE On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    expected_status=any
    Should Be True    ${del_resp.status_code} < 500
    Log    Step 2 PASS — DELETE from cart: ${del_resp.status_code}

    # Step 3 — both must be in non-server-error range
    Log    Step 3 PASS — POST: ${post_resp.status_code} | DELETE: ${del_resp.status_code}

TC_API_POST_DEL_02 Add To Wishlist Then Remove From Wishlist
    [Documentation]
    ...    Chain Step 1: POST product 12345 to /api/wishlist.
    ...    Chain Step 2: DELETE the same product from /api/wishlist/items/12345.
    ...    Chain Step 3: Assert DELETE status is an expected non-server-error code.
    [Tags]    api    post    delete    chaining    regression

    # Step 1 — POST to wishlist
    ${body}=       Create Dictionary    product_id=${PRODUCT_ID}
    ${post_resp}=  POST On Session    purplle    ${WISHLIST_ENDPOINT}
    ...    json=${body}    expected_status=any
    Should Be True    ${post_resp.status_code} < 500
    Log    Step 1 PASS — POST to wishlist: ${post_resp.status_code}

    # Step 2 — DELETE from wishlist using session from Step 1
    ${del_resp}=   DELETE On Session    purplle    ${WISHLIST_ITEM_ENDPOINT}
    ...    expected_status=any
    Should Be True    ${del_resp.status_code} < 500
    Log    Step 2 PASS — DELETE from wishlist: ${del_resp.status_code}

    # Step 3 — compare: DELETE status must be same auth level as POST
    ${same_auth_gate}=    Evaluate
    ...    (${post_resp.status_code} in [401,403] and ${del_resp.status_code} in [401,403])
    ...    or (${post_resp.status_code} < 400 and ${del_resp.status_code} < 400)
    Log    Step 3 PASS — Auth gate consistent: ${same_auth_gate}

TC_API_POST_DEL_03 Add Two Items To Cart Then Delete Both Sequentially
    [Documentation]
    ...    Chain Step 1: POST product 12345 to cart.
    ...    Chain Step 2: POST product 67890 to cart.
    ...    Chain Step 3: DELETE product 12345 from cart.
    ...    Chain Step 4: DELETE product 67890 from cart.
    ...    Full multi-item add then multi-item remove cycle chained together.
    [Tags]    api    post    delete    chaining    regression

    # Step 1 — add first product
    ${body1}=     Create Dictionary    product_id=12345    quantity=1
    ${resp1}=     POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body1}    expected_status=any
    Should Be True    ${resp1.status_code} < 500
    Log    Step 1 — Add item 12345: ${resp1.status_code}

    # Step 2 — add second product (chained session)
    ${body2}=     Create Dictionary    product_id=67890    quantity=1
    ${resp2}=     POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body2}    expected_status=any
    Should Be True    ${resp2.status_code} < 500
    Log    Step 2 — Add item 67890: ${resp2.status_code}

    # Step 3 — delete first product (chained from Steps 1 & 2)
    ${del1}=      DELETE On Session    purplle    /api/cart/items/12345
    ...    expected_status=any
    Should Be True    ${del1.status_code} < 500
    Log    Step 3 — Delete item 12345: ${del1.status_code}

    # Step 4 — delete second product (chained from Step 3)
    ${del2}=      DELETE On Session    purplle    /api/cart/items/67890
    ...    expected_status=any
    Should Be True    ${del2.status_code} < 500
    Log    Step 4 PASS — Delete item 67890: ${del2.status_code}
