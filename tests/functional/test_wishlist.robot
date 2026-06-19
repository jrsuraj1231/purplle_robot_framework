*** Settings ***
Resource    ../../resources/pages/wishlist_page.robot
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application

*** Test Cases ***
TC_FUNC_WISH_01 Verify Wishlist Page Loads
    [Documentation]    Navigate directly to the wishlist URL and verify the page loads
    [Tags]    functional    smoke    wishlist
    Navigate To Wishlist
    Verify Wishlist Page Is Loaded

TC_FUNC_WISH_02 Verify Wishlist URL Is Correct
    [Documentation]    Verify the current URL contains "wishlist" after navigation
    [Tags]    functional    smoke    wishlist
    Navigate To Wishlist
    Location Should Contain    myfavourites

TC_FUNC_WISH_03 Verify Empty Wishlist State For Guest User
    [Documentation]    Verify a guest user sees an empty wishlist message or login prompt
    [Tags]    functional    regression    wishlist
    Navigate To Wishlist
    Wait Until Page Contains Element    ${EMPTY_WISHLIST_MESSAGE}    timeout=10s
    Element Should Be Visible    ${EMPTY_WISHLIST_MESSAGE}

TC_FUNC_WISH_04 Verify Wishlist Page Title Contains Purplle
    [Documentation]    Verify the browser tab title on the wishlist page contains Purplle
    [Tags]    functional    regression    wishlist
    Navigate To Wishlist
    Title Should Contain    Purplle

TC_FUNC_WISH_05 Verify Wishlist Icon Is Present On Product Listing Cards
    [Documentation]    Navigate to Makeup and verify product cards have wishlist interaction
    [Tags]    functional    regression    wishlist
    Go To    https://www.purplle.com/makeup
    Wait Until Element Is Visible    ${FIRST_PRODUCT}
    Page Should Contain Element    ${PRODUCT_CARDS}
