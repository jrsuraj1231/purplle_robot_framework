*** Settings ***
Library    SeleniumLibrary
Resource   ../../locators/wishlist_page_locators.robot

*** Keywords ***
Navigate To Wishlist
    Go To    https://www.purplle.com/profile/myfavourites

Verify Wishlist Page Is Loaded
    Wait Until Element Is Visible    ${WISHLIST_PAGE_HEADING}    timeout=15s
    Element Should Be Visible    ${WISHLIST_PAGE_HEADING}

Verify Wishlist Is Empty
    Wait Until Element Is Visible    ${EMPTY_WISHLIST_MESSAGE}    timeout=15s
    Element Should Be Visible    ${EMPTY_WISHLIST_MESSAGE}

Verify Wishlist Has Items
    Wait Until Element Is Visible    ${FIRST_WISHLIST_ITEM}    timeout=15s
    Page Should Contain Element    ${WISHLIST_ITEMS}

Get Number Of Wishlist Items
    Wait Until Element Is Visible    ${WISHLIST_ITEMS}
    ${items}=    Get WebElements    ${WISHLIST_ITEMS}
    ${count}=    Get Length    ${items}
    RETURN    ${count}

Move First Item To Bag
    Wait Until Element Is Visible    ${MOVE_TO_BAG_BTN}
    Click Element    ${MOVE_TO_BAG_BTN}
    Sleep    2s

Remove First Item From Wishlist
    Wait Until Element Is Visible    ${REMOVE_FROM_WISHLIST_BTN}
    Click Element    ${REMOVE_FROM_WISHLIST_BTN}
    Sleep    2s

Verify Login Prompt Is Shown
    Wait Until Element Is Visible    ${LOGIN_TO_VIEW_WISHLIST}    timeout=10s
    Element Should Be Visible    ${LOGIN_TO_VIEW_WISHLIST}
