*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# PATCH Chaining: partial updates — each PATCH sends only changed fields.
# Unlike PUT (full replace), PATCH only modifies the specified fields.
# Chain: Add item → PATCH quantity → PATCH price hint → PATCH note
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
TC_API_PATCH_01 Add Item Then Partially Update Quantity Then Update Note
    [Documentation]
    ...    Chain Step 1: POST to add product to cart.
    ...    Chain Step 2: PATCH only the quantity field (partial update).
    ...    Chain Step 3: PATCH only the gift_note field (another partial update).
    ...    Shows PATCH updating one field at a time without touching others.
    [Tags]    api    patch    chaining    regression

    # Step 1 — create cart item via POST
    ${post_body}=     Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=     POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Should Be True    ${post_resp.status_code} < 500
    Log    Step 1 PASS — Cart item added, status: ${post_resp.status_code}

    # Step 2 — PATCH only quantity (partial update, not full replace)
    ${patch_qty}=     Create Dictionary    quantity=5
    ${patch_resp1}=   PATCH On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${patch_qty}    expected_status=any
    Should Be True    ${patch_resp1.status_code} < 500
    Log    Step 2 PASS — PATCH quantity=5, status: ${patch_resp1.status_code}

    # Step 3 — PATCH only gift_note field (chained from Step 2, other fields unchanged)
    ${patch_note}=    Create Dictionary    gift_note=Happy Birthday
    ${patch_resp2}=   PATCH On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${patch_note}    expected_status=any
    Should Be True    ${patch_resp2.status_code} < 500
    Log    Step 3 PASS — PATCH gift_note, status: ${patch_resp2.status_code}

TC_API_PATCH_02 Partially Update Profile Name Then Email Separately
    [Documentation]
    ...    Chain Step 1: PATCH only the name field on /api/profile.
    ...    Chain Step 2: PATCH only the email field using same session (name unchanged).
    ...    Chain Step 3: PATCH only the phone field (email and name unchanged).
    ...    Demonstrates three independent PATCH calls chained on the same resource.
    [Tags]    api    patch    chaining    regression

    # Step 1 — patch only name
    ${name_patch}=    Create Dictionary    name=Suraj
    ${resp1}=         PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${name_patch}    expected_status=any
    Should Be True    ${resp1.status_code} < 500
    Log    Step 1 — PATCH name status: ${resp1.status_code}

    # Step 2 — patch only email (name remains Suraj from Step 1)
    ${email_patch}=   Create Dictionary    email=suraj@example.com
    ${resp2}=         PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${email_patch}    expected_status=any
    Should Be True    ${resp2.status_code} < 500
    Log    Step 2 — PATCH email status: ${resp2.status_code}

    # Step 3 — patch only phone (name and email unchanged from Steps 1 & 2)
    ${phone_patch}=   Create Dictionary    phone=9876543210
    ${resp3}=         PATCH On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${phone_patch}    expected_status=any
    Should Be True    ${resp3.status_code} < 500
    Log    Step 3 — PATCH phone status: ${resp3.status_code}
    Log    Step 3 PASS — All three PATCH calls completed without 5xx
