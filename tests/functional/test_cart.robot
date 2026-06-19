*** Settings ***
Resource    ../../resources/pages/cart_page.robot
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Test Cases ***
TC_FUNC_CART_01 Verify Cart Page Loads
    [Documentation]    Navigate directly to the cart URL and verify the page loads
    [Tags]    functional    smoke    cart
    Navigate To Cart
    Verify Cart Page Is Loaded

TC_FUNC_CART_02 Verify Empty Cart State For Guest User
    [Documentation]    Verify guest users see an empty cart message or login prompt
    [Tags]    functional    smoke    cart
    Navigate To Cart
    Wait Until Page Contains Element    ${EMPTY_CART_MESSAGE}    timeout=15s
    Element Should Be Visible    ${EMPTY_CART_MESSAGE}

TC_FUNC_CART_03 Verify Cart Icon Is Visible In Header
    [Documentation]    Verify the cart bag icon is present in the site header
    [Tags]    functional    smoke    cart
    Go To    ${BASE_URL}
    Wait Until Element Is Visible    ${CART_ICON}
    Element Should Be Visible    ${CART_ICON}

TC_FUNC_CART_04 Verify Clicking Cart Icon Navigates To Cart Page
    [Documentation]    Verify clicking the header cart icon redirects to the cart page
    [Tags]    functional    regression    cart
    Go To    ${BASE_URL}
    Click Cart Icon
    Wait Until Page Contains    cart    timeout=10s

TC_FUNC_CART_05 Verify Continue Shopping Button Is Present On Empty Cart
    [Documentation]    Verify the "Continue Shopping" call-to-action is visible on an empty cart
    [Tags]    functional    regression    cart
    Navigate To Cart
    Wait Until Element Is Visible    ${CONTINUE_SHOPPING_BTN}    timeout=15s
    Element Should Be Visible    ${CONTINUE_SHOPPING_BTN}

TC_FUNC_CART_06 Verify Continue Shopping Returns To Homepage
    [Documentation]    Verify clicking "Continue Shopping" from empty cart navigates back to homepage
    [Tags]    functional    regression    cart
    Navigate To Cart
    Click Continue Shopping
    Wait Until Page Contains    Purplle    timeout=10s

TC_FUNC_CART_07 Verify Checkout Button Is Absent On Empty Cart
    [Documentation]    Verify the Proceed to Checkout button is not shown on an empty cart
    [Tags]    functional    regression    cart    negative
    Navigate To Cart
    Wait Until Page Contains Element    ${EMPTY_CART_MESSAGE}    timeout=15s
    Page Should Not Contain Element    ${PROCEED_TO_CHECKOUT_BTN}
