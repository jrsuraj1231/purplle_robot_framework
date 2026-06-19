*** Settings ***
Resource    ../../resources/pages/search_page.robot
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application
Test Setup      Go To    ${BASE_URL}

*** Test Cases ***
TC_FUNC_SEARCH_01 Search For A Valid Product And Verify Results
    [Documentation]    Search for "lipstick" and verify product result cards are displayed
    [Tags]    functional    smoke    search
    Search For    lipstick
    Verify Search Results Are Displayed

TC_FUNC_SEARCH_02 Search For A Brand Name And Verify Results
    [Documentation]    Search for "Lakme" brand and verify brand products appear in results
    [Tags]    functional    smoke    search
    Search For    Lakme
    Verify Search Results Are Displayed

TC_FUNC_SEARCH_03 Search For A Skincare Product
    [Documentation]    Search for "moisturizer" and verify skincare products appear
    [Tags]    functional    regression    search
    Search For    moisturizer
    Verify Search Results Are Displayed

TC_FUNC_SEARCH_04 Search For A Haircare Product
    [Documentation]    Search for "shampoo" and verify haircare products appear
    [Tags]    functional    regression    search
    Search For    shampoo
    Verify Search Results Are Displayed

TC_FUNC_SEARCH_05 Search For A Fragrance Product
    [Documentation]    Search for "perfume" and verify fragrance products appear
    [Tags]    functional    regression    search
    Search For    perfume
    Verify Search Results Are Displayed

TC_FUNC_SEARCH_06 Verify No Results Message For Invalid Keyword
    [Documentation]    Search for a nonsense term and verify a "no results" message is shown
    [Tags]    functional    regression    search    negative
    Search For    xyzabc123invalidproduct
    Verify No Results Message Is Shown

TC_FUNC_SEARCH_07 Verify Search Suggestions Appear While Typing
    [Documentation]    Verify that autocomplete suggestions show up when user starts typing
    [Tags]    functional    regression    search
    Wait Until Element Is Visible    ${SEARCH_INPUT}
    Click Element    ${SEARCH_INPUT}
    Input Text    ${SEARCH_INPUT}    lipst
    Verify Search Suggestions Are Shown

TC_FUNC_SEARCH_08 Click First Product From Search Results Opens PDP
    [Documentation]    Verify clicking a search result card navigates to the product detail page
    [Tags]    functional    regression    search
    Search For    lipstick
    Verify Search Results Are Displayed
    Click First Product From Results
    Wait Until Element Is Visible    xpath=//h1    timeout=15s
    Element Should Be Visible    xpath=//h1
