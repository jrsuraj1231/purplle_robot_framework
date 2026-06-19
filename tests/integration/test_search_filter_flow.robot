*** Settings ***
Resource    ../../resources/pages/search_page.robot
Resource    ../../resources/pages/product_listing_page.robot
Resource    ../../resources/pages/product_detail_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Variables ***
${MAKEUP_URL}    https://www.purplle.com/makeup

*** Test Cases ***
TC_INT_FILTER_01 Search Then Sort Results By Price Low To High
    [Documentation]    Search for "foundation", apply Price Low-to-High sort, verify products still appear
    [Tags]    integration    search    product_listing
    Go To    ${BASE_URL}
    Search For    foundation
    Verify Search Results Are Displayed
    Sort By Price Low To High
    Verify Search Results Are Displayed

TC_INT_FILTER_02 Search Then Sort Results By Price High To Low
    [Documentation]    Search for "foundation", apply Price High-to-Low sort, verify products still appear
    [Tags]    integration    search    product_listing
    Go To    ${BASE_URL}
    Search For    foundation
    Verify Search Results Are Displayed
    Sort By Price High To Low
    Verify Search Results Are Displayed

TC_INT_FILTER_03 Category Page Brand Filter Narrows Product List
    [Documentation]    Navigate to Makeup, expand Brand filter, select Lakme, verify filtered results load
    [Tags]    integration    product_listing
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Select Brand Filter    Lakme
    Wait Until Element Is Visible    ${FIRST_PRODUCT}    timeout=15s
    Verify Products Are Listed

TC_INT_FILTER_04 Category Page Price Filter Section Expands
    [Documentation]    Navigate to Makeup, expand the Price filter panel and verify it opens
    [Tags]    integration    product_listing
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Expand Price Filter
    Wait Until Element Is Visible    ${PRICE_FILTER_HEADING}
    Element Should Be Visible    ${PRICE_FILTER_HEADING}

TC_INT_FILTER_05 Sort And Then Open First Product Shows Correct PDP
    [Documentation]    Sort Makeup by popularity, then click the first product and verify PDP loads
    [Tags]    integration    product_listing    product_detail
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Sort By Popularity
    Verify Products Are Listed
    Click First Product
    Verify Product Detail Page Is Loaded
    Verify Add To Bag Button Is Visible
