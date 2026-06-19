*** Settings ***
Library    SeleniumLibrary
Resource   ../../locators/product_detail_page_locators.robot

*** Keywords ***
Verify Product Detail Page Is Loaded
    Wait Until Element Is Visible    ${PRODUCT_NAME}    timeout=15s
    Element Should Be Visible    ${PRODUCT_NAME}

Get Product Name
    Wait Until Element Is Visible    ${PRODUCT_NAME}
    ${name}=    Get Text    ${PRODUCT_NAME}
    RETURN    ${name}

Get Product Brand
    Wait Until Element Is Visible    ${PRODUCT_BRAND}
    ${brand}=    Get Text    ${PRODUCT_BRAND}
    RETURN    ${brand}

Get Product Price
    Wait Until Element Is Visible    ${PRODUCT_PRICE}
    ${price}=    Get Text    ${PRODUCT_PRICE}
    RETURN    ${price}

Verify Add To Bag Button Is Visible
    Wait Until Element Is Visible    ${ADD_TO_BAG_BTN}
    Element Should Be Visible    ${ADD_TO_BAG_BTN}

Click Add To Bag
    Wait Until Element Is Visible    ${ADD_TO_BAG_BTN}
    Click Element    ${ADD_TO_BAG_BTN}

Add Product To Wishlist
    Wait Until Element Is Visible    ${WISHLIST_ICON}
    Click Element    ${WISHLIST_ICON}

Verify Product Images Are Displayed
    Wait Until Element Is Visible    ${PRODUCT_IMAGE}
    Element Should Be Visible    ${PRODUCT_IMAGE}

Verify Product Description Is Displayed
    Wait Until Element Is Visible    ${PRODUCT_DESCRIPTION}
    Element Should Be Visible    ${PRODUCT_DESCRIPTION}

Verify Reviews Section Is Displayed
    Scroll Element Into View    ${REVIEWS_SECTION}
    Wait Until Element Is Visible    ${REVIEWS_SECTION}
    Element Should Be Visible    ${REVIEWS_SECTION}

Get Product Rating
    Wait Until Element Is Visible    ${RATING_VALUE}
    ${rating}=    Get Text    ${RATING_VALUE}
    RETURN    ${rating}

Increase Quantity
    Wait Until Element Is Visible    ${QUANTITY_PLUS}
    Click Element    ${QUANTITY_PLUS}

Decrease Quantity
    Wait Until Element Is Visible    ${QUANTITY_MINUS}
    Click Element    ${QUANTITY_MINUS}
