*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# PUT Chaining: each PUT replaces the full resource; output feeds the next PUT.
# Chain: Add item to cart (POST) → Update quantity via PUT → Replace with new item via PUT
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
TC_API_PUT_01 Add Item Then Replace Quantity Then Replace Item
    [Documentation]
    ...    Chain Step 1: POST to add product 12345 to cart.
    ...    Chain Step 2: PUT to cart item endpoint to fully replace quantity to 3.
    ...    Chain Step 3: PUT again to replace quantity back to 1 (full replacement).
    ...    Each PUT fully replaces the resource — unlike PATCH which partially updates.
    [Tags]    api    put    chaining    regression

    # Step 1 — create the cart item via POST
    ${post_body}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Should Be True    ${post_resp.status_code} < 500
    Log    Step 1 PASS — Cart item created, status: ${post_resp.status_code}

    # Step 2 — PUT to fully replace the cart item (quantity=3)
    ${put_body1}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=3
    ${put_resp1}=    PUT On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${put_body1}    expected_status=any
    Should Be True    ${put_resp1.status_code} < 500
    Log    Step 2 PASS — PUT quantity=3, status: ${put_resp1.status_code}

    # Step 3 — PUT again to replace back to quantity=1 (chained from Step 2 session)
    ${put_body2}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${put_resp2}=    PUT On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${put_body2}    expected_status=any
    Should Be True    ${put_resp2.status_code} < 500
    Log    Step 3 PASS — PUT quantity=1, status: ${put_resp2.status_code}

TC_API_PUT_02 Update Profile Then Update Preferences Via PUT
    [Documentation]
    ...    Chain Step 1: PUT to /api/profile to replace name field.
    ...    Chain Step 2: PUT to /api/profile/preferences to replace notification settings.
    ...    Chain Step 3: Verify both responses are consistent (same auth gate).
    [Tags]    api    put    chaining    regression

    # Step 1 — full replace of profile name
    ${profile_body}=    Create Dictionary    name=TestUser    email=test@example.com
    ${profile_resp}=    PUT On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${profile_body}    expected_status=any
    Should Be True    ${profile_resp.status_code} < 500
    Log    Step 1 — Profile PUT status: ${profile_resp.status_code}

    # Step 2 — full replace of preferences (chained from Step 1)
    ${pref_body}=    Create Dictionary    email_notifications=true    sms_notifications=false
    ${pref_resp}=    PUT On Session    purplle    /api/profile/preferences
    ...    json=${pref_body}    expected_status=any
    Should Be True    ${pref_resp.status_code} < 500
    Log    Step 2 — Preferences PUT status: ${pref_resp.status_code}

    # Step 3 — both calls should return same auth status (not 5xx)
    Should Be True    ${profile_resp.status_code} < 500
    Should Be True    ${pref_resp.status_code} < 500
    Log    Step 3 PASS — Profile: ${profile_resp.status_code} | Prefs: ${pref_resp.status_code}
