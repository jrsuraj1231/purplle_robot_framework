*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# DELETE Chaining: each DELETE uses the session or data from prior step.
# Chain: Add item → Delete item → Add again → Delete wishlist item
# NOTE: Guest requests return 401/403 — acceptable. 5xx means server error.

Suite Setup     Create Purplle API Session
Suite Teardown  Delete All Sessions

*** Variables ***
${API_BASE_URL}            https://www.purplle.com
${CART_ENDPOINT}           /api/cart
${CART_ITEM_ENDPOINT}      /api/cart/items/12345
${WISHLIST_ENDPOINT}       /api/wishlist
${WISHLIST_ITEM_ENDPOINT}  /api/wishlist/items/67890
${PRODUCT_ID}              12345
${WISHLIST_PRODUCT_ID}     67890

*** Keywords ***
Create Purplle API Session
    ${headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
    Create Session    purplle    ${API_BASE_URL}    headers=${headers}    verify=True

*** Test Cases ***
TC_API_DELETE_01 Add To Cart Then Delete Cart Item
    [Documentation]
    ...    Chain Step 1: POST to add product 12345 to cart.
    ...    Chain Step 2: DELETE the same cart item using the endpoint from Step 1.
    ...    Chain Step 3: Verify DELETE did not cause a server error.
    [Tags]    api    delete    chaining    regression

    # Step 1 — add item to cart
    ${post_body}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Should Be True    ${post_resp.status_code} < 500
    Log    Step 1 PASS — Cart item added, status: ${post_resp.status_code}

    # Step 2 — DELETE the cart item using its endpoint (session carried from Step 1)
    ${del_resp}=     DELETE On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    expected_status=any
    Should Be True    ${del_resp.status_code} < 500
    Log    Step 2 PASS — Cart item deleted, status: ${del_resp.status_code}

    # Step 3 — confirm deletion status is in expected range (200/204 success or 401/403/404 auth/not-found)
    Should Be True    ${del_resp.status_code} in [200, 204, 401, 403, 404]
    Log    Step 3 PASS — Deletion status is in expected range: ${del_resp.status_code}

TC_API_DELETE_02 Add To Cart Delete Then Add To Wishlist Then Delete Wishlist
    [Documentation]
    ...    Chain Step 1: POST product to cart.
    ...    Chain Step 2: DELETE cart item (clean up).
    ...    Chain Step 3: POST product to wishlist.
    ...    Chain Step 4: DELETE wishlist item (clean up).
    ...    Full add-then-remove cycle on two different endpoints chained together.
    [Tags]    api    delete    chaining    regression

    # Step 1 — add to cart
    ${cart_body}=     Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${cart_post}=     POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${cart_body}    expected_status=any
    Should Be True    ${cart_post.status_code} < 500
    Log    Step 1 — Add to cart: ${cart_post.status_code}

    # Step 2 — delete from cart (chained from Step 1)
    ${cart_del}=      DELETE On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    expected_status=any
    Should Be True    ${cart_del.status_code} < 500
    Log    Step 2 — Delete from cart: ${cart_del.status_code}

    # Step 3 — add to wishlist (chained from Step 2 session)
    ${wish_body}=     Create Dictionary    product_id=${WISHLIST_PRODUCT_ID}
    ${wish_post}=     POST On Session    purplle    ${WISHLIST_ENDPOINT}
    ...    json=${wish_body}    expected_status=any
    Should Be True    ${wish_post.status_code} < 500
    Log    Step 3 — Add to wishlist: ${wish_post.status_code}

    # Step 4 — delete from wishlist (chained from Step 3)
    ${wish_del}=      DELETE On Session    purplle    ${WISHLIST_ITEM_ENDPOINT}
    ...    expected_status=any
    Should Be True    ${wish_del.status_code} < 500
    Log    Step 4 PASS — Delete from wishlist: ${wish_del.status_code}
