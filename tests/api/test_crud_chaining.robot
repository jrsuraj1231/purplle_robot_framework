*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# Full CRUD Chaining: POST → GET → PUT → PATCH → DELETE on the same resource.
# This is the complete lifecycle of a resource in a single chained test.
#
# STATUS CODE GUIDE BY METHOD:
#   POST   → 201 Created | 200 OK | 401/403 guest
#   GET    → 200 OK | 401/403 guest
#   PUT    → 200 OK | 204 No Content | 401/403 guest
#   PATCH  → 200 OK | 204 No Content | 401/403 guest
#   DELETE → 200 OK | 204 No Content | 401/403 guest | 404 already gone

Suite Setup     Create Purplle API Session
Suite Teardown  Delete All Sessions

*** Variables ***
${API_BASE_URL}            https://www.purplle.com
${CART_ENDPOINT}           /api/cart
${CART_ITEM_ENDPOINT}      /api/cart/items/12345
${WISHLIST_ENDPOINT}       /api/wishlist
${WISHLIST_ITEM_ENDPOINT}  /api/wishlist/items/12345
${PROFILE_ENDPOINT}        /api/profile
${PRODUCT_ID}              12345

*** Keywords ***
Create Purplle API Session
    ${headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
    Create Session    purplle    ${API_BASE_URL}    headers=${headers}    verify=True

Assert POST Status
    [Arguments]    ${response}    ${step_label}
    Should Be True    ${response.status_code} in [200, 201, 401, 403]
    Log    ${step_label}: ${response.status_code}

Assert GET Status
    [Arguments]    ${response}    ${step_label}
    Should Be True    ${response.status_code} in [200, 401, 403]
    Log    ${step_label}: ${response.status_code}

Assert PUT Status
    [Arguments]    ${response}    ${step_label}
    Should Be True    ${response.status_code} in [200, 204, 401, 403]
    Log    ${step_label}: ${response.status_code}

Assert PATCH Status
    [Arguments]    ${response}    ${step_label}
    Should Be True    ${response.status_code} in [200, 204, 401, 403]
    Log    ${step_label}: ${response.status_code}

Assert DELETE Status
    [Arguments]    ${response}    ${step_label}
    Should Be True    ${response.status_code} in [200, 204, 401, 403, 404]
    Log    ${step_label}: ${response.status_code}

*** Test Cases ***
TC_API_CRUD_01 Full Cart Item Lifecycle POST GET PUT PATCH DELETE
    [Documentation]
    ...    Step 1 POST   — Add product 12345 to cart — expect 201/401/403.
    ...    Step 2 GET    — Fetch current cart — expect 200/401/403.
    ...    Step 3 PUT    — Fully replace cart item (quantity=5) — expect 200/204/401/403.
    ...    Step 4 PATCH  — Partially update quantity to 2 — expect 200/204/401/403.
    ...    Step 5 DELETE — Remove the cart item — expect 200/204/401/403/404.
    [Tags]    api    crud    chaining    post    get    put    patch    delete    regression

    # Step 1 — CREATE (POST)
    ${post_body}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST (Create)

    # Step 2 — READ (GET)
    ${get_resp}=     GET On Session    purplle    ${CART_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert GET Status    ${get_resp}    Step 2 GET (Read)

    # Step 3 — UPDATE full (PUT)
    ${put_body}=     Create Dictionary    product_id=${PRODUCT_ID}    quantity=5    gift_wrap=false
    ${put_resp}=     PUT On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${put_body}    expected_status=any
    Run Keyword    Assert PUT Status    ${put_resp}    Step 3 PUT (Full Update)

    # Step 4 — UPDATE partial (PATCH)
    ${patch_body}=   Create Dictionary    quantity=2
    ${patch_resp}=   PATCH On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${patch_body}    expected_status=any
    Run Keyword    Assert PATCH Status    ${patch_resp}    Step 4 PATCH (Partial Update)

    # Step 5 — DELETE
    ${del_resp}=     DELETE On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${del_resp}    Step 5 DELETE (Remove)

    Log    CRUD Chain complete — POST:${post_resp.status_code} GET:${get_resp.status_code} PUT:${put_resp.status_code} PATCH:${patch_resp.status_code} DELETE:${del_resp.status_code}

TC_API_CRUD_02 Full Wishlist Item Lifecycle POST GET PUT PATCH DELETE
    [Documentation]
    ...    Step 1 POST   — Add product to wishlist — expect 201/401/403.
    ...    Step 2 GET    — Fetch wishlist — expect 200/401/403.
    ...    Step 3 PUT    — Full replace wishlist item metadata — expect 200/204/401/403.
    ...    Step 4 PATCH  — Partially update note field — expect 200/204/401/403.
    ...    Step 5 DELETE — Remove item from wishlist — expect 200/204/401/403/404.
    [Tags]    api    crud    chaining    post    get    put    patch    delete    regression

    # Step 1 — CREATE (POST)
    ${post_body}=    Create Dictionary    product_id=${PRODUCT_ID}
    ${post_resp}=    POST On Session    purplle    ${WISHLIST_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST (Create)

    # Step 2 — READ (GET)
    ${get_resp}=     GET On Session    purplle    ${WISHLIST_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert GET Status    ${get_resp}    Step 2 GET (Read)

    # Step 3 — UPDATE full (PUT)
    ${put_body}=     Create Dictionary    product_id=${PRODUCT_ID}    priority=high    note=Favourite
    ${put_resp}=     PUT On Session    purplle    ${WISHLIST_ITEM_ENDPOINT}
    ...    json=${put_body}    expected_status=any
    Run Keyword    Assert PUT Status    ${put_resp}    Step 3 PUT (Full Update)

    # Step 4 — UPDATE partial (PATCH)
    ${patch_body}=   Create Dictionary    note=Top Pick
    ${patch_resp}=   PATCH On Session    purplle    ${WISHLIST_ITEM_ENDPOINT}
    ...    json=${patch_body}    expected_status=any
    Run Keyword    Assert PATCH Status    ${patch_resp}    Step 4 PATCH (Partial Update)

    # Step 5 — DELETE
    ${del_resp}=     DELETE On Session    purplle    ${WISHLIST_ITEM_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${del_resp}    Step 5 DELETE (Remove)

    Log    CRUD Chain complete — POST:${post_resp.status_code} GET:${get_resp.status_code} PUT:${put_resp.status_code} PATCH:${patch_resp.status_code} DELETE:${del_resp.status_code}

TC_API_CRUD_03 Profile Full CRUD Cycle POST GET PUT PATCH DELETE
    [Documentation]
    ...    Step 1 POST   — Attempt to create profile — expect 201/401/403.
    ...    Step 2 GET    — Read current profile — expect 200/401/403.
    ...    Step 3 PUT    — Full profile replace — expect 200/204/401/403.
    ...    Step 4 PATCH  — Partial update name only — expect 200/204/401/403.
    ...    Step 5 DELETE — Attempt account deletion — expect 200/204/401/403/404.
    [Tags]    api    crud    chaining    post    get    put    patch    delete    regression

    # Step 1 — POST
    ${post_body}=    Create Dictionary    name=TestUser    email=test@example.com
    ${post_resp}=    POST On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST (Create)

    # Step 2 — GET
    ${get_resp}=     GET On Session    purplle    ${PROFILE_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert GET Status    ${get_resp}    Step 2 GET (Read)

    # Step 3 — PUT
    ${put_body}=     Create Dictionary    name=FullName    email=full@example.com    phone=9999999999
    ${put_resp}=     PUT On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${put_body}    expected_status=any
    Run Keyword    Assert PUT Status    ${put_resp}    Step 3 PUT (Full Update)

    # Step 4 — PATCH
    ${patch_body}=   Create Dictionary    name=Suraj
    ${patch_resp}=   PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${patch_body}    expected_status=any
    Run Keyword    Assert PATCH Status    ${patch_resp}    Step 4 PATCH (Partial)

    # Step 5 — DELETE
    ${del_resp}=     DELETE On Session    purplle    ${PROFILE_ENDPOINT}
    ...    expected_status=any
    Run Keyword    Assert DELETE Status    ${del_resp}    Step 5 DELETE (Remove)

    Log    CRUD Chain complete — POST:${post_resp.status_code} GET:${get_resp.status_code} PUT:${put_resp.status_code} PATCH:${patch_resp.status_code} DELETE:${del_resp.status_code}
