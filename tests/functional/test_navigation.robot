*** Settings ***
Resource    ../../resources/pages/home_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application
Suite Teardown  Close Application
Test Setup      Go To    ${BASE_URL}

*** Test Cases ***
TC_FUNC_NAV_01 Navigate To Makeup Category Via Nav Bar
    [Documentation]    Click Makeup in the main nav and verify the Makeup category page opens
    [Tags]    functional    smoke    navigation
    Wait Until Element Is Visible    ${NAV_MAKEUP}
    Click Element    ${NAV_MAKEUP}
    Wait Until Page Contains    Makeup    timeout=15s
    Element Should Be Visible    xpath=//h1

TC_FUNC_NAV_02 Navigate To Skincare Category Via Nav Bar
    [Documentation]    Click Skincare in the main nav and verify the Skincare category page opens
    [Tags]    functional    smoke    navigation
    Wait Until Element Is Visible    ${NAV_SKINCARE}
    Click Element    ${NAV_SKINCARE}
    Wait Until Page Contains    Skincare    timeout=15s
    Element Should Be Visible    xpath=//h1

TC_FUNC_NAV_03 Navigate To Hair Category Via Nav Bar
    [Documentation]    Click Hair in the main nav and verify the Hair category page opens
    [Tags]    functional    regression    navigation
    Wait Until Element Is Visible    ${NAV_HAIR}
    Click Element    ${NAV_HAIR}
    Wait Until Page Contains    Hair    timeout=15s
    Element Should Be Visible    xpath=//h1

TC_FUNC_NAV_04 Navigate To Offers Page Via Nav Bar
    [Documentation]    Click Offers in the main nav and verify the Offers page loads
    [Tags]    functional    regression    navigation
    Wait Until Element Is Visible    ${NAV_OFFERS}
    Click Element    ${NAV_OFFERS}
    Wait Until Page Contains    Offer    timeout=15s

TC_FUNC_NAV_05 Navigate To Brands Page Via Nav Bar
    [Documentation]    Click Brands in the main nav and verify the Brands listing page loads
    [Tags]    functional    regression    navigation
    Wait Until Element Is Visible    ${NAV_BRANDS}
    Click Element    ${NAV_BRANDS}
    Wait Until Page Contains    Brand    timeout=15s

TC_FUNC_NAV_06 Click Logo Returns To Homepage
    [Documentation]    From a category page, click the Purplle logo and verify return to homepage
    [Tags]    functional    regression    navigation
    Go To    https://www.purplle.com/makeup
    Wait Until Element Is Visible    ${LOGO}
    Click Element    ${LOGO}
    Wait Until Page Contains    Purplle    timeout=10s
    Location Should Be    https://www.purplle.com/

TC_FUNC_NAV_07 Browser Back Button Returns From Category To Homepage
    [Documentation]    Navigate to Skincare then use browser back to return to homepage
    [Tags]    functional    regression    navigation
    Click Element    ${NAV_SKINCARE}
    Wait Until Page Contains    Skincare    timeout=15s
    Go Back
    Wait Until Page Contains    Purplle    timeout=10s

TC_FUNC_NAV_08 Navigate To New Launches Section
    [Documentation]    Click New in nav bar and verify New Launches page opens
    [Tags]    functional    regression    navigation
    Wait Until Element Is Visible    ${NAV_NEW}
    Click Element    ${NAV_NEW}
    Wait Until Element Is Visible    xpath=//h1    timeout=15s

TC_FUNC_NAV_09 Navigate To Splurge Premium Section
    [Documentation]    Click Splurge in nav bar and verify the premium section loads
    [Tags]    functional    regression    navigation
    Wait Until Element Is Visible    ${NAV_SPLURGE}
    Click Element    ${NAV_SPLURGE}
    Wait Until Element Is Visible    xpath=//h1    timeout=15s

TC_FUNC_NAV_10 Verify All Main Navigation Links Are Visible Together
    [Documentation]    Single test to verify all key nav links are present at the same time
    [Tags]    functional    smoke    navigation
    Verify Navigation Links Are Visible
