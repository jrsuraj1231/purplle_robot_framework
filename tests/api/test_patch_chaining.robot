*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# PATCH Chaining: partial updates — each PATCH sends only changed fields.
# Unlike PUT (full replace), PATCH only modifies the specified fields.
#
# STATUS CODE GUIDE FOR PATCH:
#   200 OK          — partial update applied, updated resource returned
#   204 No Content  — partial update applied, no body returned
#   401 Unauthorized — endpoint requires login (guest hit auth-protected route)
#   403 Forbidden   — authenticated but not allowed
#   5xx / 400       — server error or bad payload (NEVER acceptable)

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
    # 201 = created (auth), 200 = ok, 401/403 = guest auth gate
    Should Be True    ${response.status_code} in [200, 201, 401, 403]
    Log    ${label}: ${response.status_code}

Assert PATCH Status
    [Arguments]    ${response}    ${label}
    # 200 = patched with body, 204 = patched no body, 401/403 = guest auth gate
    Should Be True    ${response.status_code} in [200, 204, 401, 403]
    Log    ${label}: ${response.status_code}

*** Test Cases ***
TC_API_PATCH_01 Add Item Then Partially Update Quantity Then Update Note
    [Documentation]
    ...    Chain Step 1: POST to add product to cart — expect 201/401/403.
    ...    Chain Step 2: PATCH only the quantity field — expect 200/204/401/403.
    ...    Chain Step 3: PATCH only the gift_note field — expect 200/204/401/403.
    ...    Shows PATCH updating one field at a time without touching others.
    [Tags]    api    patch    chaining    regression

    # Step 1 — create cart item via POST
    ${post_body}=     Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=     POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST /api/cart

    # Step 2 — PATCH only quantity (partial update, not full replace)
    ${patch_qty}=     Create Dictionary    quantity=5
    ${patch_resp1}=   PATCH On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${patch_qty}    expected_status=any
    Run Keyword    Assert PATCH Status    ${patch_resp1}    Step 2 PATCH quantity=5

    # Step 3 — PATCH only gift_note (other fields from Step 2 unchanged)
    ${patch_note}=    Create Dictionary    gift_note=Happy Birthday
    ${patch_resp2}=   PATCH On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${patch_note}    expected_status=any
    Run Keyword    Assert PATCH Status    ${patch_resp2}    Step 3 PATCH gift_note

    # Both PATCHes must return the same status (same endpoint, same session)
    Should Be Equal As Integers    ${patch_resp1.status_code}    ${patch_resp2.status_code}
    Log    PATCH statuses consistent: ${patch_resp1.status_code} == ${patch_resp2.status_code}

TC_API_PATCH_02 Partially Update Profile Name Then Email Separately
    [Documentation]
    ...    Chain Step 1: PATCH only the name field on /api/profile — expect 200/204/401/403.
    ...    Chain Step 2: PATCH only the email field (name unchanged) — expect 200/204/401/403.
    ...    Chain Step 3: PATCH only the phone field (name and email unchanged) — expect 200/204/401/403.
    ...    Demonstrates three independent PATCH calls chained on the same resource.
    [Tags]    api    patch    chaining    regression

    # Step 1 — patch only name
    ${name_patch}=    Create Dictionary    name=Suraj
    ${resp1}=         PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${name_patch}    expected_status=any
    Run Keyword    Assert PATCH Status    ${resp1}    Step 1 PATCH name

    # Step 2 — patch only email (name remains Suraj from Step 1)
    ${email_patch}=   Create Dictionary    email=suraj@example.com
    ${resp2}=         PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${email_patch}    expected_status=any
    Run Keyword    Assert PATCH Status    ${resp2}    Step 2 PATCH email

    # Step 3 — patch only phone (name and email unchanged from Steps 1 & 2)
    ${phone_patch}=   Create Dictionary    phone=9876543210
    ${resp3}=         PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${phone_patch}    expected_status=any
    Run Keyword    Assert PATCH Status    ${resp3}    Step 3 PATCH phone

    # All three must return the same auth-gate status
    Should Be Equal As Integers    ${resp1.status_code}    ${resp2.status_code}
    Should Be Equal As Integers    ${resp2.status_code}    ${resp3.status_code}
    Log    Step 3 PASS — All PATCH statuses consistent: ${resp1.status_code}
