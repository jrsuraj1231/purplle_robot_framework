# Purplle.com Test Automation Framework

A Robot Framework test automation suite for [Purplle.com](https://www.purplle.com) — India's leading online beauty store. The framework covers UI automation (Selenium), API testing (RequestsLibrary), and data-driven testing across four organized test layers.

---

## Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| Robot Framework | 7.4.2 | Core test framework |
| SeleniumLibrary | 6.8.0 | Browser automation |
| RequestsLibrary | 0.9.7 | HTTP / API testing |
| DataDriver | 1.11.2 | CSV-driven test generation |
| pabot | 5.2.2 | Parallel test execution |
| Python | 3.x | Runtime |
| Chrome | Latest | Default browser |

---

## Prerequisites

- Python 3.8 or higher
- Google Chrome browser
- ChromeDriver (auto-managed by `webdriver-manager`)

---

## Installation

```bash
# 1. Clone or download the repository
cd Robot_framework_project

# 2. (Recommended) Create a virtual environment
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS / Linux

# 3. Install all dependencies
pip install -r requirements.txt
```

---

## Project Structure

```
Robot_framework_project/
│
├── config/
│   ├── config.yaml               # Central config: URLs, browser, API endpoints, test data
│   └── readme.py                 # RF Python library — exposes config.yaml as keywords
│
├── locators/                     # Element locators as RF variables (one file per page)
│   ├── home_page_locators.robot
│   ├── login_page_locators.robot
│   ├── search_page_locators.robot
│   ├── product_listing_page_locators.robot
│   ├── product_detail_page_locators.robot
│   ├── cart_page_locators.robot
│   └── wishlist_page_locators.robot
│
├── resources/
│   ├── common_resources.robot    # Browser lifecycle; BASE_URL, TIMEOUT variables
│   └── pages/                   # Page Object keywords (one file per page/module)
│       ├── home_page.robot
│       ├── login_page.robot
│       ├── search_page.robot
│       ├── product_listing_page.robot
│       ├── product_detail_page.robot
│       ├── cart_page.robot
│       └── wishlist_page.robot
│
├── testdata/
│   └── purplle_search_keywords.csv   # Keywords for data-driven search tests
│
├── tests/
│   ├── functional/               # Single-feature tests (one module at a time)
│   │   ├── test_homepage.robot
│   │   ├── test_login.robot
│   │   ├── test_search.robot
│   │   ├── test_product_listing.robot
│   │   ├── test_product_detail.robot
│   │   ├── test_cart.robot
│   │   ├── test_wishlist.robot
│   │   ├── test_navigation.robot
│   │   └── test_datadriven_search.robot
│   │
│   ├── integration/              # Multi-module interaction tests
│   │   ├── test_search_to_pdp_flow.robot
│   │   ├── test_plp_to_pdp_flow.robot
│   │   ├── test_homepage_to_category_flow.robot
│   │   └── test_search_filter_flow.robot
│   │
│   ├── e2e/                      # Full end-to-end user journey tests
│   │   ├── test_guest_browse_journey.robot
│   │   ├── test_search_and_view_journey.robot
│   │   └── test_category_navigation_journey.robot
│   │
│   └── api/                      # HTTP-level tests (no browser)
│       ├── test_search_api.robot
│       └── test_product_api.robot
│
├── outputs/                      # Test result artifacts (gitignored)
│   ├── log.html
│   ├── report.html
│   └── output.xml
│
├── requirements.txt
├── CLAUDE.md
└── README.md
```

---

## Configuration

All settings live in **`config/config.yaml`**. Edit this file to change the browser, timeouts, URLs, or test data — no changes to test files needed.

```yaml
browser:
  name: chrome       # change to firefox, edge, etc.
  headless: false    # set true for CI / headless execution
  timeout: 15
  implicit_wait: 10

base_url: https://www.purplle.com
```

### Using Config Values in Tests

Import `config/readme.py` as a Robot Framework Library to read config values:

```robot
Library    ../../config/readme.py

${url}=        Get Base Url
${timeout}=    Get Timeout
${mobile}=     Get Test Credential    mobile
```

---

## Running Tests

### Run an Entire Layer

```bash
robot tests/functional/
robot tests/integration/
robot tests/e2e/
robot tests/api/
```

### Run a Single File

```bash
robot tests/functional/test_homepage.robot
robot tests/integration/test_search_to_pdp_flow.robot
robot tests/e2e/test_guest_browse_journey.robot
robot tests/api/test_search_api.robot
```

### Run by Tag

```bash
robot --tag smoke tests/               # Quick smoke tests across all layers
robot --tag regression tests/          # Full regression suite
robot --tag functional tests/          # All functional tests
robot --tag integration tests/         # All integration tests
robot --tag e2e tests/                 # All E2E journey tests
robot --tag api tests/                 # All API tests
robot --tag negative tests/            # Negative / error-path tests
robot --tag login tests/               # Login-related tests only
robot --tag search tests/              # Search-related tests only
robot --tag cart tests/                # Cart-related tests only
```

### Run in Parallel (pabot)

```bash
pabot tests/
pabot --processes 4 tests/functional/
```

### Save Results to a Custom Directory

```bash
robot --outputdir outputs/ tests/
```

### Run Headless (CI / No Display)

Set `headless: true` in `config/config.yaml`, then:

```bash
robot tests/
```

---

## Test Layers Explained

### Functional (`tests/functional/`)

Tests a **single module in isolation**. Each file maps 1-to-1 with a page or feature.

| File | Module | Key Scenarios |
|------|--------|--------------|
| `test_homepage.robot` | Homepage | Title, header elements, nav links, search |
| `test_login.robot` | Login (OTP) | Form presence, invalid inputs, error messages |
| `test_search.robot` | Search | Valid/invalid searches, suggestions, result click |
| `test_product_listing.robot` | Category PLP | Products listed, sort, filters |
| `test_product_detail.robot` | Product PDP | Name, price, MRP, Add to Bag, reviews |
| `test_cart.robot` | Cart | Empty state, cart icon, continue shopping |
| `test_wishlist.robot` | Wishlist | Empty state, URL, guest behaviour |
| `test_navigation.robot` | Navigation | All nav links, logo, browser back |
| `test_datadriven_search.robot` | Search (DD) | 8 keywords from CSV, each verified |

### Integration (`tests/integration/`)

Tests **how two or more modules work together** in a single browser flow.

| File | Flow |
|------|------|
| `test_search_to_pdp_flow.robot` | Search → PDP → Back to results |
| `test_plp_to_pdp_flow.robot` | Category PLP → PDP → Brand page |
| `test_homepage_to_category_flow.robot` | Homepage nav → PLP → Login/Cart links |
| `test_search_filter_flow.robot` | Search → Sort → Filter → PDP |

### E2E (`tests/e2e/`)

Tests **complete realistic user journeys** from start to finish.

| File | Journey |
|------|---------|
| `test_guest_browse_journey.robot` | Homepage → Category → PDP → Cart → Wishlist |
| `test_search_and_view_journey.robot` | Search → Sort → Open product → Compare two products |
| `test_category_navigation_journey.robot` | Multiple categories → Filter → Search → Brands |

### API (`tests/api/`)

Tests **HTTP-level behaviour** using `RequestsLibrary` — no browser required.

| File | What it checks |
|------|---------------|
| `test_search_api.robot` | Search and autocomplete endpoints: status codes, JSON, no 5xx |
| `test_product_api.robot` | Products, categories, cart, wishlist endpoints: status codes, HTTPS, response time |

> **Note:** API endpoint paths in `config/config.yaml → api.endpoints` are best-guess patterns. Verify the actual paths from **Chrome DevTools → Network tab** before running `tests/api/`.

---

## Framework Architecture Flow

Shows how every component connects — from config file down to the browser and back to the report.

```
┌─────────────────────────────────────────────────────────────────┐
│                        config/config.yaml                       │
│       (browser, URLs, timeouts, API endpoints, test data)       │
└────────────────────────────┬────────────────────────────────────┘
                             │  read by
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                        config/readme.py                         │
│          (Python RF Library — exposes config as keywords)       │
└───────────┬─────────────────────────────────────────────────────┘
            │  imported by
            ▼
┌─────────────────────────────────────────────────────────────────┐
│               resources/common_resources.robot                  │
│         (${BASE_URL}, ${BROWSER}, ${TIMEOUT}, ${IMPLICIT_WAIT}) │
│                Open Application / Close Application             │
└───────────┬─────────────────────────────────────────────────────┘
            │  Resource'd by
            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    locators/*_locators.robot                    │
│           (${SEARCH_INPUT}, ${ADD_TO_BAG_BTN}, etc.)            │
└───────────┬─────────────────────────────────────────────────────┘
            │  Resource'd by
            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    resources/pages/*.robot                      │
│      (Search For, Click First Product, Verify PDP Loaded …)     │
└───────────┬─────────────────────────────────────────────────────┘
            │  Resource'd by
            ▼
┌──────────────────────────────────────────────────────────────────────────────────┐
│                              tests/                                              │
│   functional/   │   integration/   │       e2e/       │         api/            │
│  (single page)  │  (A→B module)    │  (full journey)  │  (HTTP, no browser)     │
└───────────┬─────────────────────────────────────────────┬────────────────────────┘
            │  executes via                               │  executes via
            ▼                                             ▼
┌───────────────────────┐                  ┌───────────────────────┐
│    SeleniumLibrary    │                  │   RequestsLibrary     │
│  (WebDriver commands) │                  │   (HTTP GET/POST)     │
└───────────┬───────────┘                  └───────────┬───────────┘
            │                                          │
            ▼                                          ▼
┌───────────────────────┐                  ┌───────────────────────┐
│   Chrome / Browser    │                  │  purplle.com REST API │
│   purplle.com (UI)    │                  │   (JSON responses)    │
└───────────┬───────────┘                  └───────────┬───────────┘
            └──────────────────┬───────────────────────┘
                               │  results written to
                               ▼
              ┌────────────────────────────────┐
              │           outputs/             │
              │  log.html  report.html  output.xml │
              └────────────────────────────────┘
```

---

## Test Execution Flow

Step-by-step of what happens when you run `robot tests/functional/test_search.robot`.

```
[1] robot tests/functional/test_search.robot
         │
         ▼
[2] Robot Framework parses the .robot file
    └── Reads *** Settings *** (Library, Resource imports)
    └── Loads SeleniumLibrary, common_resources, page resources, locators
         │
         ▼
[3] Suite Setup: Open Application
    └── Opens Chrome via WebDriver
    └── Maximizes browser window
    └── Sets Implicit Wait (10s) and Timeout (15s)
    └── Navigates to https://www.purplle.com
         │
         ▼
[4] For each Test Case (sequential):
    │
    ├── [4a] Test Setup: Go To <URL>
    │         └── Navigates to the test's starting page
    │
    ├── [4b] Execute test keywords
    │         └── Keyword calls SeleniumLibrary actions
    │               └── WebDriver sends commands to Chrome
    │                     └── Chrome interacts with purplle.com DOM
    │                           └── RF captures result (PASS / FAIL)
    │
    ├── [4c] On FAIL → screenshot saved to outputs/
    │
    └── [4d] Test result logged with timestamp
         │
         ▼
[5] Suite Teardown: Close Application
    └── Closes all browser windows
    └── WebDriver session terminated
         │
         ▼
[6] Robot Framework generates:
    ├── outputs/log.html     ← detailed step-by-step log
    ├── outputs/report.html  ← summary with PASS/FAIL counts
    └── outputs/output.xml   ← machine-readable results
```

---

## Application Module Flows

Detailed step-by-step flows for every module tested on purplle.com.

---

### 1. Homepage Flow

```
User opens https://www.purplle.com
         │
         ▼
┌─────────────────────────────────────────┐
│               HOMEPAGE                  │
│                                         │
│  [Header]                               │
│   Logo | Search Bar | Login | Cart 🛒   │
│                                         │
│  [Navigation Bar]                       │
│   Makeup | Skincare | Hair | Bath &     │
│   Body | Wellness | Brands | Offers |   │
│   New | Splurge                         │
│                                         │
│  [Promotional Banner / Slider]          │
│                                         │
│  [Category Tiles]                       │
│   Makeup  Skincare  Gifting  Hair …     │
│                                         │
│  [Featured / Trending Products]         │
│   Product cards with image + price      │
└─────────────────────────────────────────┘
         │
         ├── Click nav link ──────────────► Product Listing Page (PLP)
         ├── Type in Search Bar ──────────► Search Results Page
         ├── Click Login ────────────────► Login Page
         └── Click Cart 🛒 ──────────────► Cart Page
```

**Tests covering this flow:** `tests/functional/test_homepage.robot` · `tests/functional/test_navigation.robot`

---

### 2. Login Flow (OTP)

```
User clicks "Login or Register"
         │
         ▼
https://www.purplle.com/login
         │
         ▼
┌──────────────────────────────────┐
│           LOGIN PAGE             │
│                                  │
│  [ Mobile Number Field ]         │
│       Enter 10-digit number      │
│                                  │
│  [ GET OTP ] button              │
└──────────────────────────────────┘
         │
    ┌────┴────────────────────────────────┐
    │ Valid 10-digit number               │ Invalid / empty number
    ▼                                     ▼
OTP sent to mobile             ┌─────────────────────┐
         │                     │  Error message shown │
         ▼                     │  "Enter valid mobile"│
┌──────────────────┐           └─────────────────────┘
│  [ OTP Field ]   │
│  Enter 4/6 digit │
│  [ VERIFY ] btn  │
└──────────────────┘
         │
    ┌────┴───────────────┐
    │ Correct OTP        │ Wrong OTP
    ▼                    ▼
Logged In ✓         Error: "Invalid OTP"
    │
    ▼
Redirected to Homepage / Previous Page
```

**Tests covering this flow:** `tests/functional/test_login.robot`
> OTP cannot be automated — tests verify form validation and UI element presence only.

---

### 3. Search Flow

```
User clicks Search Bar in header
         │
         ▼
Types keyword (e.g., "lipstick")
         │
         ▼
Autocomplete suggestions appear
         │
    ┌────┴──────────────────┐
    │ Click suggestion      │ Press ENTER
    ▼                       ▼
         Search Results Page
         │
         ▼
┌──────────────────────────────────────────────┐
│           SEARCH RESULTS (PLP-like)          │
│                                              │
│  "X products found for 'lipstick'"           │
│                                              │
│  [Sort Bar]  Popularity | Price ↑ | Price ↓  │
│                                              │
│  Product Cards:                              │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐    │
│  │ Img  │  │ Img  │  │ Img  │  │ Img  │    │
│  │ Name │  │ Name │  │ Name │  │ Name │    │
│  │ ₹XXX │  │ ₹XXX │  │ ₹XXX │  │ ₹XXX │    │
│  └──────┘  └──────┘  └──────┘  └──────┘    │
└──────────────────────────────────────────────┘
         │
    ┌────┴──────────────────────────────────┐
    │ Invalid / gibberish keyword           │
    ▼                                       ▼
Product cards displayed           "No results found"
    │                             message displayed
    └── Click product card ──────────────────► Product Detail Page (PDP)
```

**Tests covering this flow:** `tests/functional/test_search.robot` · `tests/functional/test_datadriven_search.robot` · `tests/integration/test_search_to_pdp_flow.robot` · `tests/integration/test_search_filter_flow.robot`

---

### 4. Product Listing Page (PLP) Flow

```
User clicks a category (e.g., Makeup) OR arrives from search
         │
         ▼
https://www.purplle.com/makeup
         │
         ▼
┌───────────────────────────────────────────────────────────┐
│                PRODUCT LISTING PAGE                       │
│                                                           │
│  Heading: "Makeup"                                        │
│                                                           │
│  ┌──────────────┐  ┌──────────────────────────────────┐  │
│  │   FILTERS    │  │         PRODUCT GRID             │  │
│  │              │  │  ┌──────┐ ┌──────┐ ┌──────┐     │  │
│  │  ▶ Brand     │  │  │ Img  │ │ Img  │ │ Img  │     │  │
│  │    □ Lakme   │  │  │ Name │ │ Name │ │ Name │     │  │
│  │    □ MAC     │  │  │Brand │ │Brand │ │Brand │     │  │
│  │    □ Mayb.   │  │  │ ₹XXX │ │ ₹XXX │ │ ₹XXX │     │  │
│  │              │  │  │ ★4.2 │ │ ★3.9 │ │ ★4.5 │     │  │
│  │  ▶ Price     │  │  └──────┘ └──────┘ └──────┘     │  │
│  │    ₹0-₹500   │  │                                  │  │
│  │    ₹500-₹1k  │  │  [Sort: Popularity ▼]            │  │
│  │              │  │                                  │  │
│  │  ▶ Rating    │  │  [ Load More ]                   │  │
│  └──────────────┘  └──────────────────────────────────┘  │
└───────────────────────────────────────────────────────────┘
         │
    ┌────┴──────────────────────────────────────────┐
    │ Apply Brand filter      Apply sort (Price ↑)  │
    ▼                         ▼                     │
Products filtered          Products re-ordered      │
         │                                          │
         └── Click product card ────────────────────► PDP
```

**Tests covering this flow:** `tests/functional/test_product_listing.robot` · `tests/integration/test_plp_to_pdp_flow.robot` · `tests/integration/test_search_filter_flow.robot`

---

### 5. Product Detail Page (PDP) Flow

```
User lands on PDP from PLP or Search
         │
         ▼
https://www.purplle.com/product/<product-slug>
         │
         ▼
┌──────────────────────────────────────────────────────────┐
│                  PRODUCT DETAIL PAGE                     │
│                                                          │
│  [Breadcrumb] Home > Makeup > Lipstick > Product Name    │
│                                                          │
│  ┌──────────────┐   Product Name (h1)                   │
│  │              │   Brand Name  ────────────► Brand PLP  │
│  │   Product    │   ★ 4.2  (312 Reviews)                │
│  │   Images     │                                        │
│  │   (gallery)  │   MRP:  ₹799                          │
│  │              │   Price: ₹599  (25% OFF)              │
│  └──────────────┘                                        │
│                     Shade Selector (if applicable)       │
│                     Size Selector  (if applicable)       │
│                                                          │
│                     Qty: [ - ] [1] [ + ]                 │
│                                                          │
│                     [ ♡ Add to Wishlist ]                │
│                     [ ADD TO BAG ]                       │
│                                                          │
│  ─────────────────────────────────────────────────────   │
│  [ Description ] [ Ingredients ] [ How to Use ]         │
│  (accordion tabs)                                        │
│                                                          │
│  ─────────────────────────────────────────────────────   │
│  Ratings & Reviews                                       │
│  ★★★★☆  4.2 overall    312 reviews                      │
│                                                          │
│  ─────────────────────────────────────────────────────   │
│  Similar Products / You May Also Like                    │
└──────────────────────────────────────────────────────────┘
         │
    ┌────┴───────────────────────────────────────────┐
    │ Click ADD TO BAG   │ Click ♡ Wishlist           │
    ▼                    ▼                            │
(Guest) → Login     (Guest) → Login   (Logged in) →  │
(Logged in) →        (Logged in) →    Saved ✓         │
  Cart updated ✓      Wishlist updated ✓              │
                                                      │
    └── Click Similar Product ────────────────────────► New PDP
```

**Tests covering this flow:** `tests/functional/test_product_detail.robot` · `tests/integration/test_plp_to_pdp_flow.robot` · `tests/integration/test_search_to_pdp_flow.robot`

---

### 6. Cart Flow

```
User clicks Cart 🛒 icon in header  OR  clicks ADD TO BAG on PDP
         │
         ▼
https://www.purplle.com/cart
         │
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                         CART PAGE                               │
│                                                                 │
│  ┌──────────────────────────────────┐  ┌─────────────────────┐ │
│  │         CART ITEMS               │  │   ORDER SUMMARY     │ │
│  │                                  │  │                     │ │
│  │  ┌──────┬──────────────────────┐ │  │  Subtotal:  ₹1,198  │ │
│  │  │ Img  │ Product Name         │ │  │  Discount:  -₹200   │ │
│  │  │      │ Brand                │ │  │  Delivery:  FREE    │ │
│  │  │      │ ₹599                 │ │  │  ─────────────────  │ │
│  │  │      │ Qty: [-][1][+]       │ │  │  Total:    ₹998     │ │
│  │  │      │ [Remove]             │ │  │                     │ │
│  │  └──────┴──────────────────────┘ │  │  [ Coupon Code ]    │ │
│  │                                  │  │  [    APPLY    ]    │ │
│  │  ┌──────┬──────────────────────┐ │  │                     │ │
│  │  │ Img  │ Product Name 2 …     │ │  │ [PROCEED TO        │ │
│  │  └──────┴──────────────────────┘ │  │  CHECKOUT]         │ │
│  └──────────────────────────────────┘  └─────────────────────┘ │
│                                                                 │
│  Empty cart state:  "Your bag is empty"  [Continue Shopping]   │
└─────────────────────────────────────────────────────────────────┘
         │
    ┌────┴──────────────────────────────────────────────────────┐
    │ Update Qty        │ Remove Item    │ Proceed to Checkout  │
    ▼                   ▼                ▼                      │
  Total updates     Item removed      Checkout Page            │
                    Cart refreshes     (address → payment)     │
                                                               │
    └── Click Continue Shopping ────────────────────────────────► Homepage
```

**Tests covering this flow:** `tests/functional/test_cart.robot` · `tests/e2e/test_guest_browse_journey.robot`

---

### 7. Wishlist Flow

```
User clicks ♡ on PDP or PLP card
         │
    ┌────┴──────────────────────┐
    │ Not logged in             │ Logged in
    ▼                           ▼
Login prompt shown          Item saved to Wishlist ✓
         │                       │
         ▼                       ▼
User navigates to:    https://www.purplle.com/wishlist
         │
         ▼
┌─────────────────────────────────────────────────────┐
│                    WISHLIST PAGE                    │
│                                                     │
│  My Wishlist  (X items)                             │
│                                                     │
│  ┌──────┬──────────────────────────────────────┐   │
│  │ Img  │ Product Name                         │   │
│  │      │ Brand                                │   │
│  │      │ ₹599          [♡ Remove]             │   │
│  │      │ [Move to Bag / ADD TO BAG]           │   │
│  └──────┴──────────────────────────────────────┘   │
│                                                     │
│  Empty state: "Your wishlist is empty"              │
└─────────────────────────────────────────────────────┘
         │
    ┌────┴──────────────────────────────────┐
    │ Click Move to Bag  │ Click Remove ♡   │
    ▼                    ▼                  │
 Item added to Cart   Removed from wishlist │
 Cart count updates   Wishlist refreshes   │
```

**Tests covering this flow:** `tests/functional/test_wishlist.robot` · `tests/e2e/test_guest_browse_journey.robot`

---

### 8. Checkout Flow *(post-login, manual verification)*

```
User clicks [PROCEED TO CHECKOUT] from Cart
         │
         ▼
┌──────────────────────────────────────────┐
│           STEP 1: DELIVERY ADDRESS       │
│                                          │
│  Saved addresses shown                  │
│  ○ Home   ○ Office   + Add New          │
│                                          │
│  [ CONTINUE ]                            │
└──────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│          STEP 2: DELIVERY OPTIONS        │
│                                          │
│  ○ Standard Delivery (3-5 days) FREE     │
│  ○ Express Delivery  (1-2 days) ₹99      │
│                                          │
│  [ CONTINUE ]                            │
└──────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│          STEP 3: PAYMENT                 │
│                                          │
│  ○ UPI / QR Code                         │
│  ○ Net Banking                           │
│  ○ Credit / Debit Card                   │
│  ○ Cash on Delivery (COD)                │
│                                          │
│  Order Summary (right panel)            │
│  Items: ₹998  Delivery: FREE  Total:₹998 │
│                                          │
│  [ PLACE ORDER ]                         │
└──────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│        ORDER CONFIRMATION                │
│                                          │
│  ✓ Order placed successfully!            │
│  Order ID: #PURP-XXXXXXXXXX              │
│  Estimated delivery: DD MMM YYYY         │
│                                          │
│  [ Continue Shopping ]  [ Track Order ]  │
└──────────────────────────────────────────┘
```

> This flow requires a logged-in session and live payment — **not automated** in this framework.

---

## Integration Test Flows

How each integration test chains modules together.

### Search → PDP (`test_search_to_pdp_flow.robot`)

```
Homepage
  └─► Type in Search Bar → Press ENTER
         └─► Search Results (PLP)
                └─► Click First Product Card
                       └─► PDP loads ✓
                              └─► Verify name, price, Add to Bag
                                     └─► Go Back → Search Results still visible ✓
```

### PLP → PDP → Brand Page (`test_plp_to_pdp_flow.robot`)

```
https://www.purplle.com/makeup
  └─► Products Listed ✓
         └─► Click First Product
                └─► PDP loads ✓
                       └─► Verify price + Add to Bag ✓
                              └─► Go Back → PLP still shows products ✓
                                     └─► [Optional] Click Brand Name → Brand PLP ✓
```

### Homepage → Category (`test_homepage_to_category_flow.robot`)

```
Homepage (verify loaded)
  ├─► Click Makeup nav  → Makeup PLP  ✓
  ├─► Click Skincare nav → Skincare PLP ✓
  ├─► Search from homepage → Results page ✓
  ├─► Click Login link → Login page ✓
  └─► Click Cart icon  → Cart page ✓
```

### Search → Sort → Filter → PDP (`test_search_filter_flow.robot`)

```
Homepage
  └─► Search "foundation"
         └─► Results displayed ✓
                ├─► Sort: Price Low→High → Results re-order ✓
                ├─► Sort: Price High→Low → Results re-order ✓
                └─► Category PLP: Select Brand Filter "Lakme"
                       └─► Filtered products displayed ✓
                              └─► Click first filtered product
                                     └─► PDP loads + Add to Bag visible ✓
```

---

## E2E Journey Flows

Complete user journeys from first page to final destination.

### Journey 1 — Guest Browse (`test_guest_browse_journey.robot`)

```
START: https://www.purplle.com
  │
  ▼ Homepage verified ✓
  │
  ▼ Click "Makeup" in nav bar
  │
  ▼ Makeup PLP — heading + products visible ✓
  │
  ▼ Click first product card
  │
  ▼ PDP — name, price, Add to Bag, Wishlist icon verified ✓
  │
  ▼ Navigate to https://www.purplle.com/cart
  │
  ▼ Cart Page — empty cart message displayed ✓
  │
  ▼ Navigate to https://www.purplle.com/wishlist
  │
  ▼ Wishlist Page — empty wishlist / login prompt displayed ✓
  │
END ✓
```

### Journey 2 — Search and View (`test_search_and_view_journey.robot`)

```
START: https://www.purplle.com
  │
  ▼ Homepage verified ✓
  │
  ▼ Search "lipstick" → Search results shown ✓
  │
  ▼ Sort: Price Low → High → Products re-ordered ✓
  │
  ▼ Click first result → PDP loads ✓
  │
  ▼ Verify: name (not empty), price visible, Add to Bag visible, images visible ✓
  │
  ▼ Go To homepage → Search "moisturizer" → Click first result → PDP loads ✓
  │
  ▼ Assert: product name is different from the lipstick product ✓
  │
END ✓
```

### Journey 3 — Category Navigation (`test_category_navigation_journey.robot`)

```
START: https://www.purplle.com
  │
  ▼ Homepage verified ✓
  │
  ▼ Click "Makeup" nav  → Makeup PLP ✓
  │
  ▼ Sort: Price Low → High → re-ordered ✓
  │
  ▼ Click first product → PDP ✓  →  name + price captured ✓
  │
  ▼ Go Back → PLP still has products ✓
  │
  ▼ Click "Skincare" nav → Skincare PLP ✓
  │
  ▼ Open first Skincare product → PDP ✓
  │
  ▼ Navigate to Offers page via nav → Offers page loads ✓
  │
END ✓
```

---

## API Test Flow

No browser. HTTP requests sent directly to purplle.com endpoints.

```
Suite Setup: Create Session "purplle"  (base URL + Accept/Content-Type headers)
         │
         ▼
For each API Test Case:
         │
         ├── Build params dict  { q: "lipstick" }
         │
         ├── GET On Session  purplle  /api/search  params=${params}
         │
         ├── Assert: status_code == 200  (or non-5xx)
         │
         ├── Assert: response body is valid JSON  (if 200)
         │
         └── Log: status code + response snippet
         │
         ▼
Suite Teardown: Delete All Sessions
```

### API Assertions Pyramid

```
    /api/ endpoint responds          ← checked for all endpoints (no 5xx)
         │
    Response arrives < 10s          ← performance smoke check
         │
    Response body is JSON           ← structure check (when status == 200)
         │
    Site served over HTTPS          ← security check (URL starts with https)
```

---

## Data-Driven Search Flow

How `test_datadriven_search.robot` generates 8 tests from a single CSV file.

```
testdata/purplle_search_keywords.csv
  ┌──────────────────┐
  │ search_keyword   │
  │ lipstick         │  ─────► TC 1: Search "lipstick"    → results ✓
  │ foundation       │  ─────► TC 2: Search "foundation"  → results ✓
  │ moisturizer      │  ─────► TC 3: Search "moisturizer" → results ✓
  │ serum            │  ─────► TC 4: Search "serum"       → results ✓
  │ shampoo          │  ─────► TC 5: Search "shampoo"     → results ✓
  │ kajal            │  ─────► TC 6: Search "kajal"       → results ✓
  │ sunscreen        │  ─────► TC 7: Search "sunscreen"   → results ✓
  └──────────────────┘

DataDriver reads CSV → generates 7 test cases at runtime
Each test case:
  [Setup]   Go To https://www.purplle.com
  Step 1:   Search For  ${search_keyword}
  Step 2:   Verify Search Results Are Displayed
  [Result]  PASS if product cards appear, FAIL if no results / error
```

---

## Tag Reference

| Tag | Scope |
|-----|-------|
| `smoke` | Critical, fast checks — run before every deploy |
| `regression` | Full feature coverage — run nightly or before releases |
| `functional` | Tests in `tests/functional/` |
| `integration` | Tests in `tests/integration/` |
| `e2e` | Tests in `tests/e2e/` |
| `api` | Tests in `tests/api/` |
| `negative` | Error-path and invalid-input tests |
| `login` | Login page tests |
| `search` | Search feature tests |
| `product_listing` | Category listing page tests |
| `product_detail` | Product detail page tests |
| `cart` | Cart page tests |
| `wishlist` | Wishlist page tests |
| `navigation` | Navigation / header tests |
| `data_driven` | DataDriver CSV-based tests |
| `performance` | Response time checks (API layer) |
| `security` | HTTPS / security checks (API layer) |

---

## Writing New Tests

1. **Add a locator** → `locators/<page>_locators.robot`
2. **Add a keyword** → `resources/pages/<page>.robot`
3. **Choose the right layer**:
   - One feature = `tests/functional/`
   - Two modules together = `tests/integration/`
   - Full user journey = `tests/e2e/`
   - HTTP only = `tests/api/`
4. **Use the naming convention**: `TC_<LAYER>_<MODULE>_<NN>`
   - Example: `TC_FUNC_HOME_11`, `TC_INT_FILTER_06`, `TC_E2E_GUEST_04`, `TC_API_SEARCH_08`
5. **Tag every test** with at least `functional/integration/e2e/api` + feature tag + `smoke` or `regression`

---

## Test Reports

After a run, open `outputs/report.html` in a browser for an interactive summary.

```bash
robot --outputdir outputs/ tests/
start outputs\report.html     # Windows
open outputs/report.html      # macOS
```

---

## Important Notes

- **OTP Login**: Purplle uses phone OTP authentication. OTP cannot be automated, so all login tests cover only form validation and UI element presence. Any tests requiring a logged-in session must be run manually.
- **Dynamic Locators**: Purplle.com is a React/Next.js app with JavaScript-rendered content. All element waits use `Wait Until Element Is Visible` with a 15-second timeout — never `Sleep`.
- **"Add to Bag"**: Purplle uses this label instead of "Add to Cart". Locators in `product_detail_page_locators.robot` reflect this.
