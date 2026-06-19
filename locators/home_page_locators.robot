*** Variables ***
# Header elements
${SEARCH_INPUT}             xpath=//input[@type='search']
${CART_ICON}                xpath=//a[contains(@href,'/cart')]
${LOGIN_REGISTER_LINK}      xpath=//a[contains(@href,'/profile')]
${LOGO}                     xpath=//img[@alt='Purplle Logo']

# Main navigation
${NAV_MAKEUP}               xpath=//a[contains(text(),'Makeup')]
${NAV_SKINCARE}             xpath=//a[contains(text(),'Skincare')]
${NAV_HAIR}                 xpath=//a[contains(text(),'Hair')]
${NAV_BATH_BODY}            xpath=//a[contains(text(),'Bath')]
${NAV_WELLNESS}             xpath=//a[contains(text(),'Wellness')]
${NAV_BRANDS}               xpath=//a[contains(text(),'Brands')]
${NAV_OFFERS}               xpath=//a[contains(text(),'Offers')]
${NAV_NEW}                  xpath=//a[text()='New']
${NAV_SPLURGE}              xpath=//a[contains(text(),'Splurge')]

# Homepage sections
${BANNER_SECTION}           xpath=//div[contains(@class,'slider') or contains(@class,'banner') or contains(@class,'carousel')]
${CATEGORY_TILES}           xpath=//a[contains(@href,'/makeup') or contains(@href,'/skincare') or contains(@href,'/hair')]
${FIRST_FEATURED_PRODUCT}   xpath=(//a[contains(@href,'/product/')])[1]
