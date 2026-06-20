*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# POST → DELETE Chaining: create a resource then immediately remove it.
# Validates that add and remove operations work on the same session.
#
# STATUS CODE GUIDE:
#   POST  → 201 Created (auth) | 200 OK | 401/403 guest
#   DELETE → 200 OK | 204 No Content | 401/403 guest | 404 already gone

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

Assert POST Status
    [Arguments]    ${response}    ${label}
    Should Be True    ${response.status_code} in [200, 201, 401, 403]
    Log    ${label}: ${response.status_code}

Assert DELETE Status
    [Arguments]    ${response}    ${label}
    Should Be True    ${response.status_code} in [200, 204, 401, 403, 404]
    Log    ${label}: ${response.status_code}

*** Test Cases ***
TC_API_POST_DEL_01 Add To Cart Then Remove From Cart
    [Documentation]
    ...    Chain Step 1: POST product 12345 to /api/cart — expect 201 (auth) or 401/403 (guest).
    ...    Chain Step 2: DELETE product from /api/cart/items/12345 — expect 200/204 (auth) or 401/403/404 (guest).
    ...    Chain Step 3: Assert auth gate was consistent between POST and DELETE.
    [Tags]    api    post    delete    chaining    regression

    # Step 1 — POST: add product to cart
    ${body}=       Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=  POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body}    expected_status=any
    Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST /api/cart

    # Step 2 — DELETE: remove the same product (session is same as Step 1)
    ${del_resp}=   DELETE On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${del_resp}    Step 2 DELETE /api/cart/items/12345

    # Step 3 — both must be in the same auth lane (both auth-gated or both open)
    ${both_auth_gated}=    Evaluate    ${post_resp.status_code} in [401,403] and ${del_resp.status_code} in [401,403,404]
    ${both_succeeded}=     Evaluate    ${post_resp.status_code} in [200,201] and ${del_resp.status_code} in [200,204]
    Should Be True    ${both_auth_gated} or ${both_succeeded}
    Log    Step 3 PASS — POST: ${post_resp.status_code} | DELETE: ${del_resp.status_code}

TC_API_POST_DEL_02 Add To Wishlist Then Remove From Wishlist
    [Documentation]
    ...    Chain Step 1: POST product 12345 to /api/wishlist — expect 201/401/403.
    ...    Chain Step 2: DELETE product from /api/wishlist/items/12345 — expect 200/204/401/403/404.
    ...    Chain Step 3: Assert both calls were in the same auth state.
    [Tags]    api    post    delete    chaining    regression

    # Step 1 — POST to wishlist
    ${body}=       Create Dictionary    product_id=${PRODUCT_ID}
    ${post_resp}=  POST On Session    purplle    ${WISHLIST_ENDPOINT}
    ...    json=${body}    expected_status=any
    Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST /api/wishlist

    # Step 2 — DELETE from wishlist using session from Step 1
    ${del_resp}=   DELETE On Session    purplle    ${WISHLIST_ITEM_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${del_resp}    Step 2 DELETE /api/wishlist/items/12345

    # Step 3 — auth gate consistency check
    ${both_auth_gated}=    Evaluate    ${post_resp.status_code} in [401,403] and ${del_resp.status_code} in [401,403,404]
    ${both_succeeded}=     Evaluate    ${post_resp.status_code} in [200,201] and ${del_resp.status_code} in [200,204]
    Should Be True    ${both_auth_gated} or ${both_succeeded}
    Log    Step 3 PASS — POST: ${post_resp.status_code} | DELETE: ${del_resp.status_code}

TC_API_POST_DEL_03 Add Two Items To Cart Then Delete Both Sequentially
    [Documentation]
    ...    Chain Step 1: POST product 12345 to cart — expect 201/401/403.
    ...    Chain Step 2: POST product 67890 to cart — expect same status as Step 1.
    ...    Chain Step 3: DELETE product 12345 from cart — expect 200/204/401/403/404.
    ...    Chain Step 4: DELETE product 67890 from cart — expect same status as Step 3.
    [Tags]    api    post    delete    chaining    regression

    # Step 1 — add first product
    ${body1}=     Create Dictionary    product_id=12345    quantity=1
    ${resp1}=     POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body1}    expected_status=any
    Run Keyword    Assert POST Status    ${resp1}    Step 1 POST item 12345

    # Step 2 — add second product (chained session)
    ${body2}=     Create Dictionary    product_id=67890    quantity=1
    ${resp2}=     POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${body2}    expected_status=any
    Run Keyword    Assert POST Status    ${resp2}    Step 2 POST item 67890

    # Both POSTs must return the same status
    Should Be Equal As Integers    ${resp1.status_code}    ${resp2.status_code}

    # Step 3 — delete first product
    ${del1}=      DELETE On Session    purplle    /api/cart/items/12345
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${del1}    Step 3 DELETE item 12345

    # Step 4 — delete second product (chained from Step 3)
    ${del2}=      DELETE On Session    purplle    /api/cart/items/67890
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${del2}    Step 4 DELETE item 67890

    # Both DELETEs must return the same status
    Should Be Equal As Integers    ${del1.status_code}    ${del2.status_code}
    Log    Step 4 PASS — POST: ${resp1.status_code} | DELETE: ${del1.status_code}
