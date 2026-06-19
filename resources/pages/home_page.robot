*** Settings ***
Library    SeleniumLibrary
Resource   ../../locators/home_page_locators.robot

*** Keywords ***
Verify Homepage Is Loaded
    Title Should Contain    Purplle
    Wait Until Element Is Visible    ${SEARCH_INPUT}

Search For Product From Homepage
    [Arguments]    ${keyword}
    Wait Until Element Is Visible    ${SEARCH_INPUT}
    Click Element    ${SEARCH_INPUT}
    Input Text    ${SEARCH_INPUT}    ${keyword}
    Press Keys    ${SEARCH_INPUT}    RETURN

Navigate To Category
    [Arguments]    ${category_locator}
    Wait Until Element Is Visible    ${category_locator}
    Click Element    ${category_locator}

Click Login Register Link
    Wait Until Element Is Visible    ${LOGIN_REGISTER_LINK}
    Click Element    ${LOGIN_REGISTER_LINK}

Click Cart Icon
    Wait Until Element Is Visible    ${CART_ICON}
    Click Element    ${CART_ICON}

Verify Header Elements Are Visible
    Element Should Be Visible    ${LOGO}
    Element Should Be Visible    ${SEARCH_INPUT}
    Element Should Be Visible    ${LOGIN_REGISTER_LINK}
    Element Should Be Visible    ${CART_ICON}

Verify Navigation Links Are Visible
    Wait Until Element Is Visible    ${NAV_MAKEUP}
    Element Should Be Visible    ${NAV_SKINCARE}
    Element Should Be Visible    ${NAV_OFFERS}
    Element Should Be Visible    ${NAV_BRANDS}

Search And Wait For Results
    [Arguments]    ${keyword}
    Search For Product From Homepage    ${keyword}
    Wait Until Element Is Visible    ${FIRST_FEATURED_PRODUCT}
