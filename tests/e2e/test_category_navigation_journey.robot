*** Settings ***
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/pages/product_listing_page.robot
Resource    ../../resources/pages/product_detail_page.robot
Resource    ../../resources/pages/search_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Test Cases ***
TC_E2E_CAT_01 Full Category Browse With Sort And Product View Journey
    [Documentation]
    ...    Complete journey: Homepage → Makeup → Sort by Price Low-High → Open Product → Verify PDP → Go Back
    [Tags]    e2e    navigation    product_listing    smoke

    # Step 1: Open homepage
    Go To    ${BASE_URL}
    Verify Homepage Is Loaded

    # Step 2: Navigate to Makeup category
    Navigate To Category    ${NAV_MAKEUP}
    Verify Category Heading Is Displayed
    Verify Products Are Listed

    # Step 3: Sort products
    Sort By Price Low To High
    Verify Products Are Listed

    # Step 4: Open first product
    Click First Product
    Verify Product Detail Page Is Loaded

    # Step 5: Verify PDP details
    ${name}=    Get Product Name
    Should Not Be Empty    ${name}
    Element Should Be Visible    ${PRODUCT_PRICE}

    # Step 6: Navigate back to category listing
    Go Back
    Wait Until Element Is Visible    ${FIRST_PRODUCT}    timeout=15s
    Verify Products Are Listed

TC_E2E_CAT_02 Multi-Category Switch Journey With Product Views
    [Documentation]
    ...    Journey: View Makeup products → Switch to Skincare via nav → View a product → Return to Offers
    [Tags]    e2e    navigation    regression

    # Step 1: Open Makeup category
    Go To    ${BASE_URL}
    Navigate To Category    ${NAV_MAKEUP}
    Verify Products Are Listed

    # Step 2: Open first Makeup product
    Click First Product
    Verify Product Detail Page Is Loaded

    # Step 3: Switch to Skincare via nav (from PDP)
    Navigate To Category    ${NAV_SKINCARE}
    Verify Products Are Listed

    # Step 4: Open first Skincare product
    Click First Product
    Verify Product Detail Page Is Loaded

    # Step 5: Navigate to Offers page
    Navigate To Category    ${NAV_OFFERS}
    Wait Until Page Contains    Offer    timeout=15s

TC_E2E_CAT_03 Category Filter And Search Combined Journey
    [Documentation]
    ...    Journey: Navigate to Makeup category → Filter by brand → Go back to homepage → Search for same brand
    [Tags]    e2e    navigation    search    regression

    # Step 1: Navigate to Makeup
    Go To    ${BASE_URL}
    Navigate To Category    ${NAV_MAKEUP}
    Verify Products Are Listed

    # Step 2: Expand brand filter
    Expand Brand Filter
    Wait Until Element Is Visible    ${BRAND_FILTER_HEADING}

    # Step 3: Return to homepage
    Navigate To Category    ${LOGO}
    Wait Until Page Contains    Purplle    timeout=10s

    # Step 4: Search for a specific brand from homepage
    Search For Product From Homepage    Lakme
    Verify Search Results Are Displayed

TC_E2E_CAT_04 Brands Page Browse Journey
    [Documentation]
    ...    Journey: Homepage → Brands page via nav → Verify brand listing page loads
    [Tags]    e2e    navigation    regression

    Go To    ${BASE_URL}
    Verify Homepage Is Loaded
    Navigate To Category    ${NAV_BRANDS}
    Wait Until Page Contains    Brand    timeout=15s
    Wait Until Element Is Visible    xpath=//h1    timeout=15s
    Element Should Be Visible    xpath=//h1
