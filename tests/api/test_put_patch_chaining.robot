*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# PUT + PATCH Chaining: full replace (PUT) followed by partial update (PATCH).
# Shows the difference: PUT replaces the whole resource, PATCH only touches named fields.
# NOTE: Guest requests return 401/403 — acceptable. 5xx means server error.

Suite Setup     Create Purplle API Session
Suite Teardown  Delete All Sessions

*** Variables ***
${API_BASE_URL}       https://www.purplle.com
${CART_ENDPOINT}      /api/cart
${CART_ITEM_ENDPOINT} /api/cart/items/12345
${PROFILE_ENDPOINT}   /api/profile
${PRODUCT_ID}         12345

*** Keywords ***
Create Purplle API Session
    ${headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
    Create Session    purplle    ${API_BASE_URL}    headers=${headers}    verify=True

*** Test Cases ***
TC_API_PUT_PATCH_01 Add Item Then Full Replace Then Partial Update
    [Documentation]
    ...    Chain Step 1: POST to add product to cart.
    ...    Chain Step 2: PUT to fully replace the cart item (all fields sent).
    ...    Chain Step 3: PATCH to partially update only the quantity (other fields untouched).
    ...    Shows PUT vs PATCH difference on the same resource chained together.
    [Tags]    api    put    patch    chaining    regression

    # Step 1 — POST: create the resource
    ${post_body}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Should Be True    ${post_resp.status_code} < 500
    Log    Step 1 PASS — POST: ${post_resp.status_code}

    # Step 2 — PUT: full replace (send all fields, replaces entire resource)
    ${put_body}=     Create Dictionary    product_id=${PRODUCT_ID}    quantity=3    gift_wrap=false
    ${put_resp}=     PUT On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${put_body}    expected_status=any
    Should Be True    ${put_resp.status_code} < 500
    Log    Step 2 PASS — PUT (full replace): ${put_resp.status_code}

    # Step 3 — PATCH: partial update (only quantity field, gift_wrap stays from PUT)
    ${patch_body}=   Create Dictionary    quantity=1
    ${patch_resp}=   PATCH On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${patch_body}    expected_status=any
    Should Be True    ${patch_resp.status_code} < 500
    Log    Step 3 PASS — PATCH (partial, quantity only): ${patch_resp.status_code}

TC_API_PUT_PATCH_02 Full Profile Replace Then Partial Name Correction
    [Documentation]
    ...    Chain Step 1: PUT to /api/profile to fully replace all profile fields.
    ...    Chain Step 2: PATCH to /api/profile to correct only the name (other fields stay).
    ...    Chain Step 3: PATCH to /api/profile to correct only the phone (name stays from Step 2).
    ...    Realistic scenario: bulk update via PUT then fine-tune via PATCH.
    [Tags]    api    put    patch    chaining    regression

    # Step 1 — PUT: full profile replace
    ${put_body}=      Create Dictionary
    ...    name=OldName
    ...    email=old@example.com
    ...    phone=1111111111
    ${put_resp}=      PUT On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${put_body}    expected_status=any
    Should Be True    ${put_resp.status_code} < 500
    Log    Step 1 — PUT full profile: ${put_resp.status_code}

    # Step 2 — PATCH: correct only the name (email and phone stay from PUT)
    ${name_patch}=    Create Dictionary    name=Suraj
    ${patch_resp1}=   PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${name_patch}    expected_status=any
    Should Be True    ${patch_resp1.status_code} < 500
    Log    Step 2 — PATCH name only: ${patch_resp1.status_code}

    # Step 3 — PATCH: correct only the phone (name from Step 2 is preserved)
    ${phone_patch}=   Create Dictionary    phone=9876543210
    ${patch_resp2}=   PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${phone_patch}    expected_status=any
    Should Be True    ${patch_resp2.status_code} < 500
    Log    Step 3 PASS — PATCH phone only: ${patch_resp2.status_code}
    Log    Summary — PUT: ${put_resp.status_code} | PATCH1: ${patch_resp1.status_code} | PATCH2: ${patch_resp2.status_code}
