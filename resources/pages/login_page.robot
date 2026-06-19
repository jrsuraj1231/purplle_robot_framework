*** Settings ***
Library    SeleniumLibrary
Resource   ../../locators/login_page_locators.robot

*** Keywords ***
Verify Login Page Is Loaded
    Wait Until Element Is Visible    ${MOBILE_INPUT}
    Element Should Be Visible    ${MOBILE_INPUT}

Enter Mobile Number
    [Arguments]    ${mobile}
    Wait Until Element Is Visible    ${MOBILE_INPUT}
    Clear Element Text    ${MOBILE_INPUT}
    Input Text    ${MOBILE_INPUT}    ${mobile}

Click Get OTP Button
    Wait Until Element Is Visible    ${GET_OTP_BUTTON}
    Click Button    ${GET_OTP_BUTTON}

Enter OTP
    [Arguments]    ${otp}
    Wait Until Element Is Visible    ${OTP_INPUT}
    Input Text    ${OTP_INPUT}    ${otp}

Verify OTP And Login
    Wait Until Element Is Visible    ${VERIFY_OTP_BUTTON}
    Click Button    ${VERIFY_OTP_BUTTON}

Login With Mobile And OTP
    [Arguments]    ${mobile}    ${otp}
    Enter Mobile Number    ${mobile}
    Click Get OTP Button
    Enter OTP    ${otp}
    Verify OTP And Login

Login With Email And Password
    [Arguments]    ${email}    ${password}
    Wait Until Element Is Visible    ${EMAIL_LOGIN_TAB}
    Click Element    ${EMAIL_LOGIN_TAB}
    Wait Until Element Is Visible    ${EMAIL_INPUT}
    Input Text    ${EMAIL_INPUT}    ${email}
    Input Text    ${PASSWORD_INPUT}    ${password}
    Click Button    ${LOGIN_SUBMIT_BTN}

Verify Error Message Is Displayed
    Wait Until Element Is Visible    ${ERROR_MESSAGE}
    Element Should Be Visible    ${ERROR_MESSAGE}

Get Error Message Text
    Wait Until Element Is Visible    ${ERROR_MESSAGE}
    ${message}=    Get Text    ${ERROR_MESSAGE}
    RETURN    ${message}
