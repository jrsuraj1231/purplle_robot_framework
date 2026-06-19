*** Settings ***
Library    SeleniumLibrary
Resource   ../../locators/search_page_locators.robot
Resource   ../common_resources.robot

*** Keywords ***
Search For
    [Arguments]    ${keyword}
    Go To    ${BASE_URL}/search?q=${keyword}

Verify Search Results Are Displayed
    Wait Until Element Is Visible    ${FIRST_PRODUCT_CARD}    timeout=15s
    Page Should Contain Element    ${PRODUCT_CARDS}

Verify No Results Message Is Shown
    Wait Until Element Is Visible    ${NO_RESULTS_MESSAGE}    timeout=15s
    Element Should Be Visible    ${NO_RESULTS_MESSAGE}

Get First Product Name From Results
    Wait Until Element Is Visible    ${FIRST_PRODUCT_CARD}
    ${name}=    Get Text    ${FIRST_PRODUCT_NAME}
    RETURN    ${name}

Click First Product From Results
    Wait Until Element Is Visible    ${FIRST_PRODUCT_CARD}
    Click Element    ${FIRST_PRODUCT_CARD}

Verify Search Suggestions Are Shown
    Wait Until Element Is Visible    ${SEARCH_SUGGESTION_BOX}    timeout=5s
    Element Should Be Visible    ${SEARCH_SUGGESTION_BOX}

Click First Search Suggestion
    Wait Until Element Is Visible    ${SEARCH_SUGGESTION_ITEM}
    Click Element    ${SEARCH_SUGGESTION_ITEM}

Get Result Count Text
    Wait Until Element Is Visible    ${SEARCH_RESULTS_COUNT}
    ${count}=    Get Text    ${SEARCH_RESULTS_COUNT}
    RETURN    ${count}
