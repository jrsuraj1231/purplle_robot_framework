*** Settings ***
Library    SeleniumLibrary
Resource   ../../locators/cart_page_locators.robot

*** Keywords ***
Navigate To Cart
    Go To    https://www.purplle.com/cart

Verify Cart Page Is Loaded
    Wait Until Element Is Visible    ${CART_PAGE_HEADING}    timeout=15s
    Element Should Be Visible    ${CART_PAGE_HEADING}

Verify Cart Is Empty
    Wait Until Element Is Visible    ${EMPTY_CART_MESSAGE}    timeout=15s
    Element Should Be Visible    ${EMPTY_CART_MESSAGE}

Verify Cart Has Items
    Wait Until Element Is Visible    ${FIRST_CART_ITEM}    timeout=15s
    Page Should Contain Element    ${CART_ITEMS}

Get Number Of Cart Items
    Wait Until Element Is Visible    ${CART_ITEMS}
    ${items}=    Get WebElements    ${CART_ITEMS}
    ${count}=    Get Length    ${items}
    RETURN    ${count}

Remove First Cart Item
    Wait Until Element Is Visible    ${REMOVE_BTN}
    Click Element    ${REMOVE_BTN}
    Sleep    2s

Get Cart Total Text
    Wait Until Element Is Visible    ${CART_TOTAL}
    ${total}=    Get Text    ${CART_TOTAL}
    RETURN    ${total}

Proceed To Checkout
    Wait Until Element Is Visible    ${PROCEED_TO_CHECKOUT_BTN}
    Click Element    ${PROCEED_TO_CHECKOUT_BTN}

Click Continue Shopping
    Wait Until Element Is Visible    ${CONTINUE_SHOPPING_BTN}
    Click Element    ${CONTINUE_SHOPPING_BTN}

Apply Coupon
    [Arguments]    ${coupon_code}
    Wait Until Element Is Visible    ${COUPON_INPUT}
    Input Text    ${COUPON_INPUT}    ${coupon_code}
    Click Element    ${APPLY_COUPON_BTN}
