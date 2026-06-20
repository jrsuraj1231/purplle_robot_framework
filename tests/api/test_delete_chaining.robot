*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# DELETE Chaining: each DELETE uses the session or data from prior step.
# Chain: Add item → Delete item → Add again → Delete wishlist item
#
# STATUS CODE GUIDE FOR DELETE:
#   200 OK          — deleted successfully, deleted resource returned in body
#   204 No Content  — deleted successfully, no body returned (most common)
#   401 Unauthorized — endpoint requires login (guest hit auth-protected route)
#   403 Forbidden   — authenticated but not allowed
#   404 Not Found   — item already deleted or never existed (acceptable)
#   5xx / 400       — server error or bad payload (NEVER acceptable)

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

Assert POST Status
    [Arguments]    ${response}    ${label}
    # 201 = created (auth), 200 = ok, 401/403 = guest auth gate
    Should Be True    ${response.status_code} in [200, 201, 401, 403]
    Log    ${label}: ${response.status_code}

Assert DELETE Status
    [Arguments]    ${response}    ${label}
    # 200/204 = deleted, 401/403 = guest auth gate, 404 = already gone (all acceptable)
    Should Be True    ${response.status_code} in [200, 204, 401, 403, 404]
    Log    ${label}: ${response.status_code}

*** Test Cases ***
TC_API_DELETE_01 Add To Cart Then Delete Cart Item
    [Documentation]
    ...    Chain Step 1: POST to add product 12345 to cart — expect 201/401/403.
    ...    Chain Step 2: DELETE the same cart item — expect 200/204/401/403/404.
    ...    Chain Step 3: Verify DELETE returned an explicitly accepted status code.
    [Tags]    api    delete    chaining    regression

    # Step 1 — add item to cart
    ${post_body}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST /api/cart

    # Step 2 — DELETE the cart item (session carried from Step 1)
    ${del_resp}=     DELETE On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${del_resp}    Step 2 DELETE /api/cart/items/12345

    # Step 3 — confirm deletion was accepted (not a server error)
    Log    Step 3 PASS — POST: ${post_resp.status_code} | DELETE: ${del_resp.status_code}

TC_API_DELETE_02 Add To Cart Delete Then Add To Wishlist Then Delete Wishlist
    [Documentation]
    ...    Chain Step 1: POST product to cart — expect 201/401/403.
    ...    Chain Step 2: DELETE cart item — expect 200/204/401/403/404.
    ...    Chain Step 3: POST product to wishlist — expect 201/401/403.
    ...    Chain Step 4: DELETE wishlist item — expect 200/204/401/403/404.
    ...    Full add-then-remove cycle on two endpoints chained together.
    [Tags]    api    delete    chaining    regression

    # Step 1 — add to cart
    ${cart_body}=     Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${cart_post}=     POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${cart_body}    expected_status=any
    Run Keyword    Assert POST Status    ${cart_post}    Step 1 POST /api/cart

    # Step 2 — delete from cart (chained from Step 1)
    ${cart_del}=      DELETE On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${cart_del}    Step 2 DELETE cart item

    # Step 3 — add to wishlist (chained from Step 2 session)
    ${wish_body}=     Create Dictionary    product_id=${WISHLIST_PRODUCT_ID}
    ${wish_post}=     POST On Session    purplle    ${WISHLIST_ENDPOINT}
    ...    json=${wish_body}    expected_status=any
    Run Keyword    Assert POST Status    ${wish_post}    Step 3 POST /api/wishlist

    # Step 4 — delete from wishlist (chained from Step 3)
    ${wish_del}=      DELETE On Session    purplle    ${WISHLIST_ITEM_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${wish_del}    Step 4 DELETE wishlist item

    Log    Step 4 PASS — All statuses: Cart POST=${cart_post.status_code} DEL=${cart_del.status_code} | Wish POST=${wish_post.status_code} DEL=${wish_del.status_code}
