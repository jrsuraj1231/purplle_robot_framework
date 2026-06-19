*** Settings ***
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/pages/search_page.robot
Resource    ../../resources/pages/product_listing_page.robot
Resource    ../../resources/pages/product_detail_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Test Cases ***
TC_E2E_SEARCH_01 Full Search To Product View Journey
    [Documentation]
    ...    Complete journey: Homepage → Search "lipstick" → View results → Sort → Open product → Verify PDP
    [Tags]    e2e    search    smoke

    # Step 1: Open homepage
    Go To    ${BASE_URL}
    Verify Homepage Is Loaded

    # Step 2: Search for a product
    Search For Product From Homepage    lipstick
    Verify Search Results Are Displayed

    # Step 3: Apply sort - Price Low to High
    Sort By Price Low To High
    Verify Search Results Are Displayed

    # Step 4: Click the first result
    Click First Product From Results
    Verify Product Detail Page Is Loaded

    # Step 5: Verify full PDP content
    ${name}=    Get Product Name
    Should Not Be Empty    ${name}
    Element Should Be Visible    ${PRODUCT_PRICE}
    Verify Add To Bag Button Is Visible
    Verify Product Images Are Displayed

TC_E2E_SEARCH_02 Search Multiple Products And Compare PDP Details
    [Documentation]
    ...    Search for two different products, open each, and verify PDP data is populated for both.
    [Tags]    e2e    search    regression

    # First product
    Go To    ${BASE_URL}
    Search For    foundation
    Verify Search Results Are Displayed
    Click First Product From Results
    Verify Product Detail Page Is Loaded
    ${name_1}=    Get Product Name
    Should Not Be Empty    ${name_1}

    # Second product
    Go To    ${BASE_URL}
    Search For    moisturizer
    Verify Search Results Are Displayed
    Click First Product From Results
    Verify Product Detail Page Is Loaded
    ${name_2}=    Get Product Name
    Should Not Be Empty    ${name_2}

    # The two product names should differ (different search terms)
    Should Not Be Equal    ${name_1}    ${name_2}

TC_E2E_SEARCH_03 Search Keyword Journey With Suggestion Click
    [Documentation]
    ...    Start typing in search, click an autocomplete suggestion, verify product results appear.
    [Tags]    e2e    search    regression

    # Step 1: Open homepage
    Go To    ${BASE_URL}
    Verify Homepage Is Loaded

    # Step 2: Type partial keyword to trigger suggestions
    Wait Until Element Is Visible    ${SEARCH_INPUT}
    Click Element    ${SEARCH_INPUT}
    Input Text    ${SEARCH_INPUT}    kajal

    # Step 3: If suggestions appear, click the first one; otherwise press ENTER
    ${suggestion_found}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${SEARCH_SUGGESTION_BOX}    timeout=5s
    IF    ${suggestion_found}
        Click First Search Suggestion
    ELSE
        Press Keys    ${SEARCH_INPUT}    RETURN
    END

    # Step 4: Verify results appeared
    Verify Search Results Are Displayed

TC_E2E_SEARCH_04 No Results Journey Shows Helpful State
    [Documentation]
    ...    Search for a nonsense keyword, verify no-results state appears, then search again with a valid term.
    [Tags]    e2e    search    negative    regression

    # Step 1: Search invalid keyword
    Go To    ${BASE_URL}
    Search For    xyzinvalidkeyword999

    # Step 2: Verify no results message
    Verify No Results Message Is Shown

    # Step 3: Search again with valid keyword from same page
    Search For    lipstick
    Verify Search Results Are Displayed
