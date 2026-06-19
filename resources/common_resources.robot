*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${BROWSER}              chrome
${BASE_URL}             https://www.purplle.com
${TIMEOUT}              15s
${IMPLICIT_WAIT}        10s
${OUTPUT_DIR}           ${CURDIR}${/}..${/}outputs
${SCREENSHOT_DIR}       ${OUTPUT_DIR}${/}screenshots

*** Keywords ***
Open Application
    [Arguments]    ${url}=${BASE_URL}
    Open Browser    ${url}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Set Selenium Timeout    ${TIMEOUT}
    Set Screenshot Directory    ${SCREENSHOT_DIR}

Close Application
    Close All Browsers

Title Should Contain
    [Arguments]    ${expected}
    ${title}=    Get Title
    Should Contain    ${title}    ${expected}
