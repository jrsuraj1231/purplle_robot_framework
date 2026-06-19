*** Settings ***
Resource    ../../resources/pages/search_page.robot
Resource    ../../resources/common_resources.robot
Library     DataDriver    ../../testdata/purplle_search_keywords.csv    encoding=UTF-8

Suite Setup      Open Application
Suite Teardown   Close Application
Test Template    Search And Verify By Keyword

*** Test Cases ***
Search and verify results for ${search_keyword}
    [Documentation]    Data-driven: search each keyword from purplle_search_keywords.csv and verify product results appear
    [Tags]    functional    data_driven    search

*** Keywords ***
Search And Verify By Keyword
    [Arguments]    ${search_keyword}
    Search For    ${search_keyword}
    Verify Search Results Are Displayed
