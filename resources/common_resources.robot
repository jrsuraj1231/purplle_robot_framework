*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${BROWSER}              chrome
${BASE_URL}             https://www.purplle.com
${TIMEOUT}              15s
${IMPLICIT_WAIT}        10s
${HEADLESS}             false
${OUTPUT_DIR}           ${CURDIR}${/}..${/}outputs
${SCREENSHOT_DIR}       ${OUTPUT_DIR}${/}screenshots

*** Keywords ***
Open Application
    [Arguments]    ${url}=${BASE_URL}
    IF    '${HEADLESS}' == 'true'
        Open Browser    ${url}    ${BROWSER}
        ...    options=add_argument("--headless=new");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--disable-gpu")
    ELSE
        Open Browser    ${url}    ${BROWSER}
    END
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
