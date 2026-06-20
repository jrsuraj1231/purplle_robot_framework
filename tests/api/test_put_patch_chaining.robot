*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# PUT + PATCH Chaining: full replace (PUT) followed by partial update (PATCH).
# Shows the difference: PUT replaces the whole resource, PATCH only touches named fields.
#
# STATUS CODE GUIDE:
#   POST  → 201 Created | 200 OK | 401/403 guest
#   PUT   → 200 OK (body returned) | 204 No Content | 401/403 guest
#   PATCH → 200 OK (body returned) | 204 No Content | 401/403 guest

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

Assert POST Status
    [Arguments]    ${response}    ${label}
    Should Be True    ${response.status_code} in [200, 201, 401, 403]
    Log    ${label}: ${response.status_code}

Assert PUT Status
    [Arguments]    ${response}    ${label}
    Should Be True    ${response.status_code} in [200, 204, 401, 403]
    Log    ${label}: ${response.status_code}

Assert PATCH Status
    [Arguments]    ${response}    ${label}
    Should Be True    ${response.status_code} in [200, 204, 401, 403]
    Log    ${label}: ${response.status_code}

*** Test Cases ***
TC_API_PUT_PATCH_01 Add Item Then Full Replace Then Partial Update
    [Documentation]
    ...    Chain Step 1: POST to add product to cart — expect 201/401/403.
    ...    Chain Step 2: PUT to fully replace the cart item (all fields) — expect 200/204/401/403.
    ...    Chain Step 3: PATCH to partially update only quantity — expect 200/204/401/403.
    ...    Shows PUT vs PATCH on the same resource: PUT sends all fields, PATCH sends one.
    [Tags]    api    put    patch    chaining    regression

    # Step 1 — POST: create the resource
    ${post_body}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST /api/cart

    # Step 2 — PUT: full replace (all fields sent, entire resource replaced)
    ${put_body}=     Create Dictionary    product_id=${PRODUCT_ID}    quantity=3    gift_wrap=false
    ${put_resp}=     PUT On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${put_body}    expected_status=any
    Run Keyword    Assert PUT Status    ${put_resp}    Step 2 PUT (full replace)

    # Step 3 — PATCH: partial update (only quantity, gift_wrap untouched from Step 2)
    ${patch_body}=   Create Dictionary    quantity=1
    ${patch_resp}=   PATCH On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${patch_body}    expected_status=any
    Run Keyword    Assert PATCH Status    ${patch_resp}    Step 3 PATCH quantity only

    # PUT and PATCH must return same auth-gate status
    Should Be Equal As Integers    ${put_resp.status_code}    ${patch_resp.status_code}
    Log    Step 3 PASS — PUT: ${put_resp.status_code} | PATCH: ${patch_resp.status_code}

TC_API_PUT_PATCH_02 Full Profile Replace Then Partial Name Correction
    [Documentation]
    ...    Chain Step 1: PUT to /api/profile to fully replace all profile fields — expect 200/204/401/403.
    ...    Chain Step 2: PATCH to correct only the name (email and phone from PUT stay) — expect 200/204/401/403.
    ...    Chain Step 3: PATCH to correct only the phone (name from Step 2 is preserved) — expect 200/204/401/403.
    ...    Realistic scenario: bulk update via PUT then fine-tune individual fields via PATCH.
    [Tags]    api    put    patch    chaining    regression

    # Step 1 — PUT: full profile replace
    ${put_body}=      Create Dictionary
    ...    name=OldName
    ...    email=old@example.com
    ...    phone=1111111111
    ${put_resp}=      PUT On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${put_body}    expected_status=any
    Run Keyword    Assert PUT Status    ${put_resp}    Step 1 PUT /api/profile (full replace)

    # Step 2 — PATCH: correct only the name (email and phone stay from PUT)
    ${name_patch}=    Create Dictionary    name=Suraj
    ${patch_resp1}=   PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${name_patch}    expected_status=any
    Run Keyword    Assert PATCH Status    ${patch_resp1}    Step 2 PATCH name only

    # Step 3 — PATCH: correct only the phone (name from Step 2 is preserved)
    ${phone_patch}=   Create Dictionary    phone=9876543210
    ${patch_resp2}=   PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${phone_patch}    expected_status=any
    Run Keyword    Assert PATCH Status    ${patch_resp2}    Step 3 PATCH phone only

    # All three must be in the same auth lane
    Should Be Equal As Integers    ${put_resp.status_code}    ${patch_resp1.status_code}
    Should Be Equal As Integers    ${patch_resp1.status_code}    ${patch_resp2.status_code}
    Log    Step 3 PASS — PUT: ${put_resp.status_code} | PATCH1: ${patch_resp1.status_code} | PATCH2: ${patch_resp2.status_code}
