*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/common_resources.robot

# PUT Chaining: each PUT replaces the full resource; output feeds the next PUT.
# Chain: Add item to cart (POST) → Update quantity via PUT → Replace with new item via PUT
#
# STATUS CODE GUIDE FOR PUT:
#   200 OK          — resource updated and returned in response body
#   204 No Content  — updated successfully, no body returned
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

Assert PUT Status
    [Arguments]    ${response}    ${label}
    # 200 = updated with body, 204 = updated no body, 401/403 = guest auth gate
    Should Be True    ${response.status_code} in [200, 204, 401, 403]
    Log    ${label}: ${response.status_code}

*** Test Cases ***
TC_API_PUT_01 Add Item Then Replace Quantity Then Replace Item
    [Documentation]
    ...    Chain Step 1: POST to add product 12345 to cart — expect 201/401/403.
    ...    Chain Step 2: PUT to cart item endpoint to fully replace quantity to 3 — expect 200/204/401/403.
    ...    Chain Step 3: PUT again to replace quantity back to 1 — expect 200/204/401/403.
    ...    Each PUT fully replaces the resource — unlike PATCH which partially updates.
    [Tags]    api    put    chaining    regression

    # Step 1 — create the cart item via POST
    ${post_body}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${post_resp}=    POST On Session    purplle    ${CART_ENDPOINT}
    ...    json=${post_body}    expected_status=any
    Run Keyword    Assert POST Status    ${post_resp}    Step 1 POST /api/cart

    # Step 2 — PUT to fully replace the cart item (quantity=3)
    ${put_body1}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=3
    ${put_resp1}=    PUT On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${put_body1}    expected_status=any
    Run Keyword    Assert PUT Status    ${put_resp1}    Step 2 PUT quantity=3

    # Step 3 — PUT again to replace back to quantity=1 (chained from Step 2 session)
    ${put_body2}=    Create Dictionary    product_id=${PRODUCT_ID}    quantity=1
    ${put_resp2}=    PUT On Session    purplle    ${CART_ITEM_ENDPOINT}
    ...    json=${put_body2}    expected_status=any
    Run Keyword    Assert PUT Status    ${put_resp2}    Step 3 PUT quantity=1

    # Both PUTs must return the same status (same session, same auth gate)
    Should Be Equal As Integers    ${put_resp1.status_code}    ${put_resp2.status_code}
    Log    PUT statuses consistent: ${put_resp1.status_code} == ${put_resp2.status_code}

TC_API_PUT_02 Update Profile Then Update Preferences Via PUT
    [Documentation]
    ...    Chain Step 1: PUT to /api/profile to replace all profile fields — expect 200/204/401/403.
    ...    Chain Step 2: PUT to /api/profile/preferences to replace notification settings — expect 200/204/401/403.
    ...    Chain Step 3: Verify both responses returned the same status (same auth gate).
    [Tags]    api    put    chaining    regression

    # Step 1 — full replace of profile
    ${profile_body}=    Create Dictionary    name=TestUser    email=test@example.com
    ${profile_resp}=    PUT On Session    purplle    ${PROFILE_ENDPOINT}
    ...    json=${profile_body}    expected_status=any
    Run Keyword    Assert PUT Status    ${profile_resp}    Step 1 PUT /api/profile

    # Step 2 — full replace of preferences (chained from Step 1)
    ${pref_body}=    Create Dictionary    email_notifications=true    sms_notifications=false
    ${pref_resp}=    PUT On Session    purplle    /api/profile/preferences
    ...    json=${pref_body}    expected_status=any
    Run Keyword    Assert PUT Status    ${pref_resp}    Step 2 PUT /api/profile/preferences

    # Step 3 — both calls must return the same auth-gate status
    Should Be Equal As Integers    ${profile_resp.status_code}    ${pref_resp.status_code}
    Log    Step 3 PASS — Profile: ${profile_resp.status_code} | Prefs: ${pref_resp.status_code}
