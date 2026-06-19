*** Settings ***
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/pages/product_listing_page.robot
Resource    ../../resources/pages/product_detail_page.robot
Resource    ../../resources/pages/cart_page.robot
Resource    ../../resources/pages/wishlist_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Test Cases ***
TC_E2E_GUEST_01 Guest User Full Browse Journey - Homepage To Cart
    [Documentation]
    ...    Complete end-to-end journey for a guest (unauthenticated) user:
    ...    Homepage → Makeup Category → Product Detail → Cart (empty state)
    [Tags]    e2e    guest    smoke

    # Step 1: Land on homepage and verify it loads
    Go To    ${BASE_URL}
    Verify Homepage Is Loaded

    # Step 2: Navigate to Makeup category via nav bar
    Navigate To Category    ${NAV_MAKEUP}
    Verify Category Heading Is Displayed
    Verify Products Are Listed

    # Step 3: Open the first product
    Click First Product
    Verify Product Detail Page Is Loaded

    # Step 4: Verify key PDP elements are present
    Element Should Be Visible    ${PRODUCT_PRICE}
    Verify Add To Bag Button Is Visible
    Element Should Be Visible    ${WISHLIST_ICON}

    # Step 5: Navigate to Cart
    Navigate To Cart
    Verify Cart Page Is Loaded

    # Step 6: Verify empty cart state for guest
    Wait Until Page Contains Element    ${EMPTY_CART_MESSAGE}    timeout=15s
    Element Should Be Visible    ${EMPTY_CART_MESSAGE}

TC_E2E_GUEST_02 Guest User Browse Journey - Homepage To Wishlist
    [Documentation]
    ...    End-to-end journey: Homepage → Skincare Category → Product Detail → Wishlist (empty/login state)
    [Tags]    e2e    guest    regression

    # Step 1: Open homepage
    Go To    ${BASE_URL}
    Verify Homepage Is Loaded

    # Step 2: Navigate to Skincare category
    Navigate To Category    ${NAV_SKINCARE}
    Verify Products Are Listed

    # Step 3: Open first product
    Click First Product
    Verify Product Detail Page Is Loaded

    # Step 4: Navigate to Wishlist
    Navigate To Wishlist
    Verify Wishlist Page Is Loaded

TC_E2E_GUEST_03 Guest User Multi-Category Browse Journey
    [Documentation]
    ...    Guest browses through three categories (Makeup, Skincare, Hair) and views a product from each.
    [Tags]    e2e    guest    regression

    # Makeup category
    Go To    ${BASE_URL}
    Navigate To Category    ${NAV_MAKEUP}
    Verify Products Are Listed
    Click First Product
    Verify Product Detail Page Is Loaded

    # Skincare category
    Go To    ${BASE_URL}
    Navigate To Category    ${NAV_SKINCARE}
    Verify Products Are Listed
    Click First Product
    Verify Product Detail Page Is Loaded

    # Hair category
    Go To    ${BASE_URL}
    Navigate To Category    ${NAV_HAIR}
    Verify Products Are Listed
    Click First Product
    Verify Product Detail Page Is Loaded
