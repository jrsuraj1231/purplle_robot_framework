*** Settings ***
Resource    ../../resources/pages/product_listing_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Variables ***
${MAKEUP_URL}       https://www.purplle.com/makeup
${SKINCARE_URL}     https://www.purplle.com/skincare
${HAIR_URL}         https://www.purplle.com/hair

*** Test Cases ***
TC_FUNC_PLP_01 Verify Makeup Category Page Loads With Products
    [Documentation]    Navigate to Makeup category and verify products are listed
    [Tags]    functional    smoke    product_listing
    Go To    ${MAKEUP_URL}
    Verify Category Heading Is Displayed
    Verify Products Are Listed

TC_FUNC_PLP_02 Verify Skincare Category Page Loads With Products
    [Documentation]    Navigate to Skincare category and verify products are listed
    [Tags]    functional    smoke    product_listing
    Go To    ${SKINCARE_URL}
    Verify Category Heading Is Displayed
    Verify Products Are Listed

TC_FUNC_PLP_03 Verify Hair Category Page Loads With Products
    [Documentation]    Navigate to Hair category and verify products are listed
    [Tags]    functional    smoke    product_listing
    Go To    ${HAIR_URL}
    Verify Category Heading Is Displayed
    Verify Products Are Listed

TC_FUNC_PLP_04 Verify Product Cards Contain Product Links
    [Documentation]    Verify that product cards contain links to product detail pages
    [Tags]    functional    regression    product_listing
    Go To    ${MAKEUP_URL}
    Wait Until Element Is Visible    ${FIRST_PRODUCT}
    Page Should Contain Element    ${PRODUCT_CARDS}

TC_FUNC_PLP_05 Verify Sort By Price Low To High Reloads Products
    [Documentation]    Sort Makeup products by price low to high and verify product list reloads
    [Tags]    functional    regression    product_listing
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Sort By Price Low To High
    Verify Products Are Listed

TC_FUNC_PLP_06 Verify Sort By Price High To Low Reloads Products
    [Documentation]    Sort Makeup products by price high to low and verify product list reloads
    [Tags]    functional    regression    product_listing
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Sort By Price High To Low
    Verify Products Are Listed

TC_FUNC_PLP_07 Verify Sort By Popularity Works
    [Documentation]    Sort Makeup products by popularity and verify product list reloads
    [Tags]    functional    regression    product_listing
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Sort By Popularity
    Verify Products Are Listed

TC_FUNC_PLP_08 Verify Brand Filter Section Is Present
    [Documentation]    Verify the Brand filter panel is displayed on Makeup listing page
    [Tags]    functional    regression    product_listing
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Wait Until Element Is Visible    ${BRAND_FILTER_HEADING}
    Element Should Be Visible    ${BRAND_FILTER_HEADING}

TC_FUNC_PLP_09 Verify Price Filter Section Is Present
    [Documentation]    Verify the Price filter panel is displayed on Skincare listing page
    [Tags]    functional    regression    product_listing
    Go To    ${SKINCARE_URL}
    Verify Products Are Listed
    Wait Until Element Is Visible    ${PRICE_FILTER_HEADING}
    Element Should Be Visible    ${PRICE_FILTER_HEADING}

TC_FUNC_PLP_10 Click First Product Navigates To PDP
    [Documentation]    Click the first product card and verify navigation to product detail page
    [Tags]    functional    regression    product_listing
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Click First Product
    Wait Until Element Is Visible    xpath=//h1    timeout=15s
    Element Should Be Visible    xpath=//h1
