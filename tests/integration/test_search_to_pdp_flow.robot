*** Settings ***
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/pages/search_page.robot
Resource    ../../resources/pages/product_detail_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Test Cases ***
TC_INT_SEARCH_PDP_01 Search Leads To Product Results
    [Documentation]    Verify the complete flow: homepage search bar → search results with product cards
    [Tags]    integration    search
    Go To    ${BASE_URL}
    Verify Homepage Is Loaded
    Search For Product From Homepage    lipstick
    Verify Search Results Are Displayed
    Page Should Contain Element    ${FIRST_PRODUCT_CARD}

TC_INT_SEARCH_PDP_02 Search Result Click Opens Correct PDP
    [Documentation]    Verify clicking a search result card navigates to a product detail page with a name heading
    [Tags]    integration    search    product_detail
    Go To    ${BASE_URL}
    Search For    foundation
    Verify Search Results Are Displayed
    ${product_name}=    Get First Product Name From Results
    Click First Product From Results
    Verify Product Detail Page Is Loaded
    ${pdp_name}=    Get Product Name
    Should Not Be Empty    ${pdp_name}

TC_INT_SEARCH_PDP_03 PDP Elements Are Present After Search Navigation
    [Documentation]    After navigating from search to PDP, verify name, price, and Add to Bag are all present
    [Tags]    integration    search    product_detail
    Go To    ${BASE_URL}
    Search For    serum
    Verify Search Results Are Displayed
    Click First Product From Results
    Verify Product Detail Page Is Loaded
    Element Should Be Visible    ${PRODUCT_PRICE}
    Verify Add To Bag Button Is Visible

TC_INT_SEARCH_PDP_04 Search For Multiple Keywords And Verify Each Opens A PDP
    [Documentation]    Search for two different keywords and verify both open a valid product detail page
    [Tags]    integration    search    product_detail
    # First search
    Go To    ${BASE_URL}
    Search For    kajal
    Verify Search Results Are Displayed
    Click First Product From Results
    Verify Product Detail Page Is Loaded
    # Second search
    Go To    ${BASE_URL}
    Search For    sunscreen
    Verify Search Results Are Displayed
    Click First Product From Results
    Verify Product Detail Page Is Loaded

TC_INT_SEARCH_PDP_05 Navigate Back From PDP To Search Results
    [Documentation]    Verify the browser back button from PDP returns to the search results page
    [Tags]    integration    search    product_detail
    Go To    ${BASE_URL}
    Search For    lipstick
    Verify Search Results Are Displayed
    Click First Product From Results
    Verify Product Detail Page Is Loaded
    Go Back
    Wait Until Element Is Visible    ${FIRST_PRODUCT_CARD}    timeout=15s
    Verify Search Results Are Displayed
