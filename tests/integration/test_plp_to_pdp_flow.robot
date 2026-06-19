*** Settings ***
Resource    ../../resources/pages/product_listing_page.robot
Resource    ../../resources/pages/product_detail_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Variables ***
${MAKEUP_URL}       https://www.purplle.com/makeup
${SKINCARE_URL}     https://www.purplle.com/skincare

*** Test Cases ***
TC_INT_PLP_PDP_01 Makeup PLP Loads And First Product Opens Correct PDP
    [Documentation]    Navigate to Makeup category, click first product, verify PDP loads with product name
    [Tags]    integration    product_listing    product_detail
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Click First Product
    Verify Product Detail Page Is Loaded
    ${name}=    Get Product Name
    Should Not Be Empty    ${name}

TC_INT_PLP_PDP_02 Skincare PLP Loads And First Product Opens PDP With Price
    [Documentation]    Navigate to Skincare, click first product, verify PDP shows price and Add to Bag
    [Tags]    integration    product_listing    product_detail
    Go To    ${SKINCARE_URL}
    Verify Products Are Listed
    Click First Product
    Verify Product Detail Page Is Loaded
    Element Should Be Visible    ${PRODUCT_PRICE}
    Verify Add To Bag Button Is Visible

TC_INT_PLP_PDP_03 Navigate Back From PDP Returns To PLP With Products Intact
    [Documentation]    Open a product from Makeup PLP, go back, verify PLP still shows products
    [Tags]    integration    product_listing    product_detail
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Click First Product
    Verify Product Detail Page Is Loaded
    Go Back
    Wait Until Element Is Visible    ${FIRST_PRODUCT}    timeout=15s
    Verify Products Are Listed

TC_INT_PLP_PDP_04 Apply Sort Then Click Product Opens Correct PDP
    [Documentation]    Sort Makeup products by price low-to-high, then click first result and verify PDP
    [Tags]    integration    product_listing    product_detail
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Sort By Price Low To High
    Verify Products Are Listed
    Click First Product
    Verify Product Detail Page Is Loaded
    Element Should Be Visible    ${PRODUCT_PRICE}

TC_INT_PLP_PDP_05 Product Brand On PDP Links Back To Brand Listing
    [Documentation]    Open a product from Makeup PLP and verify the brand link on PDP is clickable
    [Tags]    integration    product_listing    product_detail
    Go To    ${MAKEUP_URL}
    Verify Products Are Listed
    Click First Product
    Verify Product Detail Page Is Loaded
    Wait Until Element Is Visible    ${PRODUCT_BRAND}
    ${brand}=    Get Product Brand
    Should Not Be Empty    ${brand}
    Click Element    ${PRODUCT_BRAND}
    Wait Until Element Is Visible    xpath=//h1    timeout=15s
