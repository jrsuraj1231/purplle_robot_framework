*** Variables ***
# Mobile OTP login
${MOBILE_INPUT}             xpath=//input[@type='tel' or contains(@placeholder,'mobile') or contains(@placeholder,'Mobile')]
${GET_OTP_BUTTON}           xpath=//button[contains(text(),'OTP') or contains(text(),'CONTINUE') or contains(text(),'Continue')]
${OTP_INPUT}                xpath=//input[contains(@placeholder,'OTP') or contains(@placeholder,'otp') or @name='otp']
${VERIFY_OTP_BUTTON}        xpath=//button[contains(text(),'VERIFY') or contains(text(),'Verify') or contains(text(),'SUBMIT')]

# Email / Password login
${EMAIL_LOGIN_TAB}          xpath=//a[contains(text(),'Email')] | xpath=//span[contains(text(),'Login with Email')]
${EMAIL_INPUT}              xpath=//input[@type='email' or @name='email']
${PASSWORD_INPUT}           xpath=//input[@type='password']
${LOGIN_SUBMIT_BTN}         xpath=//button[@type='submit']

# Page elements
${LOGIN_PAGE_TITLE}         xpath=//h1[contains(text(),'Login') or contains(text(),'Sign')]
${SIGNUP_LINK}              xpath=//a[contains(text(),'Sign Up') or contains(text(),'Register') or contains(text(),'New User')]

# Validation
${ERROR_MESSAGE}            xpath=//*[contains(@class,'error') or contains(@class,'Error') or contains(@class,'invalid')]
