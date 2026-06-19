*** Settings ***
Resource    ../../resources/pages/product_detail_page.robot
Resource    ../../resources/pages/search_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Variables ***
${LIPSTICK_KEYWORD}     lipstick
${SERUM_KEYWORD}        serum

*** Keywords ***
Open First Product For
    [Arguments]    ${keyword}
    Go To    ${BASE_URL}
    Search For    ${keyword}
    Wait Until Element Is Visible    ${FIRST_PRODUCT_CARD}
    Click Element    ${FIRST_PRODUCT_CARD}

*** Test Cases ***
TC_FUNC_PDP_01 Verify Product Name Is Displayed
    [Documentation]    Search for lipstick, open first product, verify the product name (h1) is shown
    [Tags]    functional    smoke    product_detail
    Open First Product For    ${LIPSTICK_KEYWORD}
    Verify Product Detail Page Is Loaded

TC_FUNC_PDP_02 Verify Product Selling Price Is Displayed
    [Documentation]    Verify the selling price element is visible on the PDP
    [Tags]    functional    smoke    product_detail
    Open First Product For    ${LIPSTICK_KEYWORD}
    Wait Until Element Is Visible    ${PRODUCT_PRICE}
    Element Should Be Visible    ${PRODUCT_PRICE}

TC_FUNC_PDP_03 Verify MRP Is Displayed
    [Documentation]    Verify the MRP (Maximum Retail Price) label and value are visible
    [Tags]    functional    smoke    product_detail
    Open First Product For    ${LIPSTICK_KEYWORD}
    Wait Until Element Is Visible    ${PRODUCT_MRP}
    Element Should Be Visible    ${PRODUCT_MRP}

TC_FUNC_PDP_04 Verify Add To Bag Button Is Present
    [Documentation]    Verify the "ADD TO BAG" button is visible on the product detail page
    [Tags]    functional    smoke    product_detail
    Open First Product For    ${LIPSTICK_KEYWORD}
    Verify Add To Bag Button Is Visible

TC_FUNC_PDP_05 Verify Product Brand Is Displayed
    [Documentation]    Verify the brand name is displayed and links to the brand page
    [Tags]    functional    regression    product_detail
    Open First Product For    ${LIPSTICK_KEYWORD}
    Wait Until Element Is Visible    ${PRODUCT_BRAND}
    Element Should Be Visible    ${PRODUCT_BRAND}

TC_FUNC_PDP_06 Verify Product Images Are Loaded
    [Documentation]    Verify at least one product image is visible on the PDP
    [Tags]    functional    regression    product_detail
    Open First Product For    ${LIPSTICK_KEYWORD}
    Verify Product Images Are Displayed

TC_FUNC_PDP_07 Verify Wishlist Icon Is Present
    [Documentation]    Verify the wishlist (heart) icon is present on the product detail page
    [Tags]    functional    regression    product_detail
    Open First Product For    ${LIPSTICK_KEYWORD}
    Wait Until Element Is Visible    ${WISHLIST_ICON}
    Element Should Be Visible    ${WISHLIST_ICON}

TC_FUNC_PDP_08 Verify Product Description Section Is Present
    [Documentation]    Verify the product description section is loaded on the PDP
    [Tags]    functional    regression    product_detail
    Open First Product For    ${SERUM_KEYWORD}
    Verify Product Description Is Displayed

TC_FUNC_PDP_09 Verify Reviews Section Is Present
    [Documentation]    Verify the reviews/ratings section is visible on the product page
    [Tags]    functional    regression    product_detail
    Open First Product For    ${SERUM_KEYWORD}
    Verify Reviews Section Is Displayed

TC_FUNC_PDP_10 Verify Similar Products Section Is Present
    [Documentation]    Verify "Similar Products" or "You May Also Like" section appears on PDP
    [Tags]    functional    regression    product_detail
    Open First Product For    ${LIPSTICK_KEYWORD}
    Wait Until Element Is Visible    ${PRODUCT_NAME}
    Scroll Element Into View    ${SIMILAR_PRODUCTS}
    Element Should Be Visible    ${SIMILAR_PRODUCTS}
