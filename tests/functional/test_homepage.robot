*** Settings ***
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application
Test Setup      Go To    ${BASE_URL}

*** Test Cases ***
TC_FUNC_HOME_01 Verify Homepage Title
    [Documentation]    Verify the purplle.com homepage loads with the correct title
    [Tags]    functional    smoke    homepage
    Title Should Contain    Purplle

TC_FUNC_HOME_02 Verify Search Bar Is Visible
    [Documentation]    Verify the search bar is present in the header
    [Tags]    functional    smoke    homepage
    Wait Until Element Is Visible    ${SEARCH_INPUT}
    Element Should Be Visible    ${SEARCH_INPUT}

TC_FUNC_HOME_03 Verify Login Register Link Is Visible
    [Documentation]    Verify the Login/Register link is accessible from the header
    [Tags]    functional    smoke    homepage
    Wait Until Element Is Visible    ${LOGIN_REGISTER_LINK}
    Element Should Be Visible    ${LOGIN_REGISTER_LINK}

TC_FUNC_HOME_04 Verify Cart Icon Is Visible
    [Documentation]    Verify the cart icon is present in the header
    [Tags]    functional    smoke    homepage
    Wait Until Element Is Visible    ${CART_ICON}
    Element Should Be Visible    ${CART_ICON}

TC_FUNC_HOME_05 Verify Logo Is Displayed
    [Documentation]    Verify the Purplle logo is displayed in the header
    [Tags]    functional    smoke    homepage
    Wait Until Element Is Visible    ${LOGO}
    Element Should Be Visible    ${LOGO}

TC_FUNC_HOME_06 Verify All Header Elements Are Present
    [Documentation]    Verify logo, search bar, login link, and cart icon all exist together
    [Tags]    functional    regression    homepage
    Verify Header Elements Are Visible

TC_FUNC_HOME_07 Verify Main Navigation Links Are Present
    [Documentation]    Verify Makeup, Skincare, Offers, and Brands nav links are visible
    [Tags]    functional    regression    homepage
    Verify Navigation Links Are Visible

TC_FUNC_HOME_08 Verify Makeup Category Link Is Clickable
    [Documentation]    Verify clicking the Makeup nav link navigates to the Makeup category page
    [Tags]    functional    regression    homepage
    Wait Until Element Is Visible    ${NAV_MAKEUP}
    Click Element    ${NAV_MAKEUP}
    Wait Until Page Contains    Makeup    timeout=15s

TC_FUNC_HOME_09 Verify Search Navigates To Results Page
    [Documentation]    Verify that searching a keyword from the homepage shows product results
    [Tags]    functional    regression    homepage
    Search And Wait For Results    lipstick
    Page Should Contain Element    ${FIRST_FEATURED_PRODUCT}

TC_FUNC_HOME_10 Verify Clicking Login Link Opens Login Page
    [Documentation]    Verify that clicking the Login/Register link redirects to the login page
    [Tags]    functional    regression    homepage
    Click Login Register Link
    Wait Until Page Contains    Login    timeout=10s
