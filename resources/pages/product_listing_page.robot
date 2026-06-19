*** Settings ***
Library    SeleniumLibrary
Resource   ../../locators/product_listing_page_locators.robot

*** Keywords ***
Verify Products Are Listed
    Wait Until Element Is Visible    ${FIRST_PRODUCT}    timeout=15s
    Page Should Contain Element    ${PRODUCT_CARDS}

Click First Product
    Wait Until Element Is Visible    ${FIRST_PRODUCT}
    Click Element    ${FIRST_PRODUCT}

Verify Category Heading Is Displayed
    Wait Until Element Is Visible    ${CATEGORY_HEADING}
    Element Should Be Visible    ${CATEGORY_HEADING}

Get Category Heading Text
    Wait Until Element Is Visible    ${CATEGORY_HEADING}
    ${heading}=    Get Text    ${CATEGORY_HEADING}
    RETURN    ${heading}

Open Sort Options
    Wait Until Element Is Visible    ${SORT_DROPDOWN}
    Click Element    ${SORT_DROPDOWN}
    Sleep    1s

Sort By Price Low To High
    Open Sort Options
    Wait Until Element Is Visible    ${SORT_PRICE_LOW_HIGH}
    Click Element    ${SORT_PRICE_LOW_HIGH}
    Wait Until Element Is Visible    ${FIRST_PRODUCT}

Sort By Price High To Low
    Open Sort Options
    Wait Until Element Is Visible    ${SORT_PRICE_HIGH_LOW}
    Click Element    ${SORT_PRICE_HIGH_LOW}
    Wait Until Element Is Visible    ${FIRST_PRODUCT}

Sort By Popularity
    Open Sort Options
    Wait Until Element Is Visible    ${SORT_POPULARITY}
    Click Element    ${SORT_POPULARITY}
    Wait Until Element Is Visible    ${FIRST_PRODUCT}

Expand Brand Filter
    Wait Until Element Is Visible    ${BRAND_FILTER_HEADING}
    Click Element    ${BRAND_FILTER_HEADING}
    Sleep    1s

Select Brand Filter
    [Arguments]    ${brand_name}
    Expand Brand Filter
    Click Element    xpath=//label[contains(text(),'${brand_name}')] | xpath=//span[text()='${brand_name}']

Expand Price Filter
    Wait Until Element Is Visible    ${PRICE_FILTER_HEADING}
    Click Element    ${PRICE_FILTER_HEADING}
    Sleep    1s

Click Load More
    Scroll Element Into View    ${LOAD_MORE_BTN}
    Click Element    ${LOAD_MORE_BTN}
    Wait Until Element Is Visible    ${FIRST_PRODUCT}
