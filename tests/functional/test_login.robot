*** Settings ***
Resource    ../../resources/pages/login_page.robot
Resource    ../../resources/common_resources.robot

Suite Setup     Open Application    https://www.purplle.com/login
Suite Teardown  Close Application
Test Setup      Go To    https://www.purplle.com/login

*** Test Cases ***
TC_FUNC_LOGIN_01 Verify Login Page Loads Successfully
    [Documentation]    Verify the purplle.com login page loads and shows the mobile input
    [Tags]    functional    smoke    login
    Verify Login Page Is Loaded

TC_FUNC_LOGIN_02 Verify Mobile Number Input Field Is Present
    [Documentation]    Verify the mobile number field is visible on the login page
    [Tags]    functional    smoke    login
    Element Should Be Visible    ${MOBILE_INPUT}

TC_FUNC_LOGIN_03 Verify Get OTP Button Is Present
    [Documentation]    Verify the Get OTP button is visible on the login page
    [Tags]    functional    smoke    login
    Element Should Be Visible    ${GET_OTP_BUTTON}

TC_FUNC_LOGIN_04 Verify Signup Link Is Present
    [Documentation]    Verify the new user registration link is present on the login page
    [Tags]    functional    regression    login
    Element Should Be Visible    ${SIGNUP_LINK}

TC_FUNC_LOGIN_05 Enter Invalid Short Mobile Number And Verify Error
    [Documentation]    Verify error message appears for an invalid mobile number (< 10 digits)
    [Tags]    functional    regression    login    negative
    Enter Mobile Number    12345
    Click Get OTP Button
    Verify Error Message Is Displayed

TC_FUNC_LOGIN_06 Submit Without Entering Mobile Number And Verify Error
    [Documentation]    Verify error message appears when OTP is requested with empty mobile field
    [Tags]    functional    regression    login    negative
    Click Get OTP Button
    Element Should Be Visible    ${ERROR_MESSAGE}

TC_FUNC_LOGIN_07 Enter Alphabetic Characters And Verify Error
    [Documentation]    Verify error message appears when alphabets are entered in mobile number field
    [Tags]    functional    regression    login    negative
    Enter Mobile Number    abcdefghij
    Click Get OTP Button
    Verify Error Message Is Displayed

TC_FUNC_LOGIN_08 Verify Mobile Input Accepts 10 Digit Number
    [Documentation]    Verify a valid 10-digit mobile number can be entered in the field
    [Tags]    functional    regression    login
    Enter Mobile Number    9876543210
    Element Attribute Value Should Be    ${MOBILE_INPUT}    value    9876543210
