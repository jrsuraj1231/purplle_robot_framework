*** Settings ***
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/pages/product_listing_page.robot
Resource    ../../resources/pages/search_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application
Test Setup      Go To    ${BASE_URL}

*** Test Cases ***
TC_INT_HOME_CAT_01 Homepage Nav Click Opens Makeup PLP With Products
    [Documentation]    From homepage, click Makeup nav link and verify the category page shows products
    [Tags]    integration    homepage    product_listing
    Verify Homepage Is Loaded
    Navigate To Category    ${NAV_MAKEUP}
    Verify Category Heading Is Displayed
    Verify Products Are Listed

TC_INT_HOME_CAT_02 Homepage Nav Click Opens Skincare PLP With Products
    [Documentation]    From homepage, click Skincare nav link and verify the category page shows products
    [Tags]    integration    homepage    product_listing
    Verify Homepage Is Loaded
    Navigate To Category    ${NAV_SKINCARE}
    Verify Category Heading Is Displayed
    Verify Products Are Listed

TC_INT_HOME_CAT_03 Switch Categories From One To Another Via Nav Bar
    [Documentation]    Navigate from homepage to Makeup, then switch to Skincare via the nav bar
    [Tags]    integration    homepage    navigation    product_listing
    Navigate To Category    ${NAV_MAKEUP}
    Verify Products Are Listed
    Navigate To Category    ${NAV_SKINCARE}
    Verify Category Heading Is Displayed
    Verify Products Are Listed

TC_INT_HOME_CAT_04 Homepage Search Bar Leads To Filtered Product Results
    [Documentation]    Use the homepage search to search "kajal" and verify products appear
    [Tags]    integration    homepage    search
    Verify Homepage Is Loaded
    Search For Product From Homepage    kajal
    Verify Search Results Are Displayed

TC_INT_HOME_CAT_05 Login Link From Homepage Navigates To Login Page
    [Documentation]    Click the Login/Register header link and verify the login page loads with mobile input
    [Tags]    integration    homepage    login
    Verify Homepage Is Loaded
    Click Login Register Link
    Wait Until Page Contains    Login    timeout=10s
    Wait Until Element Is Visible    ${MOBILE_INPUT}    timeout=10s
    Element Should Be Visible    ${MOBILE_INPUT}

TC_INT_HOME_CAT_06 Cart Icon From Homepage Navigates To Cart Page
    [Documentation]    Click the cart icon in the header and verify the cart page loads
    [Tags]    integration    homepage    cart
    Verify Homepage Is Loaded
    Click Cart Icon
    Wait Until Page Contains    cart    timeout=10s
