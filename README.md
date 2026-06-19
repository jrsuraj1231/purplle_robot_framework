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
# 1. Clone the repository
git clone https://github.com/jrsuraj1231/purplle_robot_framework.git
cd purplle_robot_framework

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
purplle_robot_framework/
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
│   ├── common_resources.robot    # Browser lifecycle; BASE_URL, TIMEOUT, Title Should Contain
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
│   └── purplle_search_keywords.csv   # Keywords for data-driven search tests (RF variable format)
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
├── outputs/                      # Test result artifacts (gitignored — generated at runtime)
│
├── .gitignore
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

urls:
  wishlist: https://www.purplle.com/profile/myfavourites   # actual Purplle wishlist URL
  cart:     https://www.purplle.com/cart
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

```powershell
robot -d outputs tests/functional/
robot -d outputs tests/integration/
robot -d outputs tests/e2e/
robot -d outputs tests/api/
```

### Run a Single File

```powershell
robot -d outputs tests/functional/test_homepage.robot
robot -d outputs tests/functional/test_datadriven_search.robot
robot -d outputs tests/integration/test_search_to_pdp_flow.robot
robot -d outputs tests/api/test_search_api.robot
```

### Run by Tag

```powershell
robot -d outputs --include smoke tests/               # Quick smoke tests across all layers
robot -d outputs --include regression tests/          # Full regression suite
robot -d outputs --include functional tests/          # All functional tests
robot -d outputs --include integration tests/         # All integration tests
robot -d outputs --include e2e tests/                 # All E2E journey tests
robot -d outputs --include api tests/                 # All API tests
robot -d outputs --include data_driven tests/         # DataDriver CSV tests only
robot -d outputs --include negative tests/            # Negative / error-path tests
```

### Run in Parallel (pabot)

```powershell
pabot tests/
pabot --processes 4 tests/functional/
```

### Output Directory

Always pass `-d outputs` so all result files go to the `outputs/` folder instead of the project root:

```bash
robot -d outputs tests/
```

Output files land in:

```
outputs/
├── output.xml    ← machine-readable results
├── log.html      ← step-by-step detail
├── report.html   ← interactive summary
└── screenshots/  ← failure screenshots (captured automatically)
```

### Dry Run (validate without browser)

```bash
robot --dryrun tests/
robot --dryrun tests/functional/test_datadriven_search.robot
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
| `test_wishlist.robot` | Wishlist | Empty state, URL (`/profile/myfavourites`), guest behaviour |
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

```
┌─────────────────────────────────────────────────────────────────┐
│                        config/config.yaml                       │
│       (browser, URLs, timeouts, API endpoints, test data)       │
└────────────────────────┬────────────────────────────────────────┘
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
│    ${BASE_URL}, ${BROWSER}, ${TIMEOUT}, ${IMPLICIT_WAIT}        │
│    Open Application / Close Application / Title Should Contain  │
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
┌──────────────────────────────────────────────────────────────────────────┐
│                              tests/                                      │
│   functional/   │   integration/   │     e2e/       │      api/          │
│  (single page)  │  (A→B module)    │ (full journey) │ (HTTP, no browser) │
└───────────┬──────────────────────────────────────────┬───────────────────┘
            │  executes via                            │  executes via
            ▼                                          ▼
┌───────────────────────┐               ┌───────────────────────┐
│    SeleniumLibrary    │               │   RequestsLibrary     │
│  (WebDriver commands) │               │   (HTTP GET/POST)     │
└───────────┬───────────┘               └───────────┬───────────┘
            │                                       │
            ▼                                       ▼
┌───────────────────────┐               ┌───────────────────────┐
│   Chrome / Browser    │               │  purplle.com REST API │
│   purplle.com (UI)    │               │   (JSON responses)    │
└───────────┬───────────┘               └───────────┬───────────┘
            └──────────────────┬────────────────────┘
                               │  results written to
                               ▼
              ┌────────────────────────────────────┐
              │             outputs/               │
              │  log.html  report.html  output.xml │
              └────────────────────────────────────┘
```

---

## Test Execution Flow

```
[1] robot tests/functional/test_datadriven_search.robot
         │
         ▼
[2] Robot Framework parses the .robot file
    └── Reads *** Settings *** (Library, Resource imports)
    └── DataDriver listener reads purplle_search_keywords.csv
    └── Generates 8 test cases at suite start
         │
         ▼
[3] Suite Setup: Open Application
    └── Opens Chrome via WebDriver
    └── Maximizes browser window
    └── Sets Implicit Wait (10s) and Timeout (15s)
         │
         ▼
[4] For each Test Case (sequential):
    │
    ├── [4a] Test Setup: Go To BASE_URL
    │
    ├── [4b] Execute template keyword: Search And Verify By Keyword
    │         └── Search For ${keyword}
    │               └── Navigates to /search?q=${keyword}
    │         └── Verify Search Results Are Displayed
    │               └── Waits for product cards (class=d-block, href=/product/)
    │
    ├── [4c] On FAIL → screenshot saved to outputs/
    │
    └── [4d] Result logged with timestamp
         │
         ▼
[5] Suite Teardown: Close Application
         │
         ▼
[6] Robot Framework generates outputs/log.html, report.html, output.xml
```

---

## Application Module Flows

### 1. Homepage Flow

```
User opens https://www.purplle.com
         │
         ▼
┌─────────────────────────────────────────┐
│               HOMEPAGE                  │
│                                         │
│  [Header]                               │
│   Logo | Search Bar | Profile | Cart    │
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
         ├── Click Profile icon ──────────► /profile  (redirects to login if guest)
         └── Click Cart 🛒 ──────────────► Cart Page
```

**Key locators verified on live site:**

| Element | Locator |
|---------|---------|
| Search input | `xpath=//input[@type='search']` |
| Logo | `xpath=//img[@alt='Purplle Logo']` |
| Profile/Login link | `xpath=//a[contains(@href,'/profile')]` |
| Cart icon | `xpath=//a[contains(@href,'/cart')]` |

**Tests:** `tests/functional/test_homepage.robot` · `tests/functional/test_navigation.robot`

---

### 2. Login Flow (OTP)

```
User clicks Profile icon in header
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
         ▼                     └─────────────────────┘
┌──────────────────┐
│  [ OTP Field ]   │
│  [ VERIFY ] btn  │
└──────────────────┘
         │
    ┌────┴───────────────┐
    │ Correct OTP        │ Wrong OTP
    ▼                    ▼
Logged In ✓         Error: "Invalid OTP"
```

> OTP cannot be automated — tests verify form element presence and input validation only.

**Tests:** `tests/functional/test_login.robot`

---

### 3. Search Flow

> **Implementation note:** Purplle.com is an Angular app. Pressing Enter in the search bar does not trigger page navigation. The `Search For` keyword navigates directly to `/search?q=${keyword}`, which reliably returns the search results page.

```
Navigate to https://www.purplle.com/search?q=lipstick
         │
         ▼
┌──────────────────────────────────────────────┐
│           SEARCH RESULTS                     │
│                                              │
│  Title: "Showing Results For lipstick"       │
│                                              │
│  [Sort Bar]  Popularity | Price ↑ | Price ↓  │
│                                              │
│  Product Cards  (class=d-block, href=/product/...):  │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐    │
│  │ Img  │  │ Img  │  │ Img  │  │ Img  │    │
│  │ Name │  │ Name │  │ Name │  │ Name │    │
│  │ ₹XXX │  │ ₹XXX │  │ ₹XXX │  │ ₹XXX │    │
│  └──────┘  └──────┘  └──────┘  └──────┘    │
└──────────────────────────────────────────────┘
         │
    ┌────┴──────────────────────────────────┐
    │ No results keyword                    │
    ▼                                       ▼
Product cards displayed           "No results found"
    │
    └── Click product card ──────────────────► Product Detail Page (PDP)
```

**Tests:** `tests/functional/test_search.robot` · `tests/functional/test_datadriven_search.robot` · `tests/integration/test_search_to_pdp_flow.robot`

---

### 4. Product Listing Page (PLP) Flow

```
User clicks a category (e.g., Makeup) via nav bar
         │
         ▼
https://www.purplle.com/makeup
         │
         ▼
┌───────────────────────────────────────────────────────────┐
│                PRODUCT LISTING PAGE                       │
│                                                           │
│  ┌──────────────┐  ┌──────────────────────────────────┐  │
│  │   FILTERS    │  │         PRODUCT GRID             │  │
│  │  ▶ Brand     │  │  ┌──────┐ ┌──────┐ ┌──────┐     │  │
│  │  ▶ Price     │  │  │ Img  │ │ Img  │ │ Img  │     │  │
│  │  ▶ Rating    │  │  │ Name │ │ Name │ │ Name │     │  │
│  └──────────────┘  │  │ ₹XXX │ │ ₹XXX │ │ ₹XXX │     │  │
│                    │  └──────┘ └──────┘ └──────┘     │  │
│                    │  [Sort: Popularity ▼]            │  │
│                    └──────────────────────────────────┘  │
└───────────────────────────────────────────────────────────┘
         │
    ┌────┴────────────────────────────────┐
    │ Apply filter / sort                 │
    ▼                                     ▼
Products filtered/re-ordered         Click product card → PDP
```

**Tests:** `tests/functional/test_product_listing.robot` · `tests/integration/test_plp_to_pdp_flow.robot`

---

### 5. Product Detail Page (PDP) Flow

```
User arrives from PLP or Search results
         │
         ▼
https://www.purplle.com/product/<product-slug>
         │
         ▼
┌──────────────────────────────────────────────────────────┐
│                  PRODUCT DETAIL PAGE                     │
│                                                          │
│  Product Name (h1)                                       │
│  Brand Name  ────────────► Brand PLP                     │
│  ★ Rating  (N Reviews)                                   │
│                                                          │
│  MRP:  ₹799                                              │
│  Price: ₹599  (25% OFF)                                  │
│                                                          │
│  [ ♡ Add to Wishlist ]                                   │
│  [ ADD TO BAG ]                                          │
│                                                          │
│  [ Description ] [ Ingredients ] [ How to Use ]         │
│                                                          │
│  Ratings & Reviews                                       │
│  Similar Products / You May Also Like                    │
└──────────────────────────────────────────────────────────┘
         │
    ┌────┴────────────────────────────────────┐
    │ Click ADD TO BAG   │ Click ♡ Wishlist   │
    ▼                    ▼                    │
(Guest) → Login     (Guest) → Login          │
(Logged in) →       (Logged in) →            │
  Cart updated ✓      Wishlist updated ✓     │
                                             │
    └── Click Similar Product ───────────────► New PDP
```

> Purplle uses **"ADD TO BAG"** not "Add to Cart". All locators reflect this.

**Tests:** `tests/functional/test_product_detail.robot` · `tests/integration/test_plp_to_pdp_flow.robot`

---

### 6. Cart Flow

```
User clicks Cart icon  OR  clicks ADD TO BAG on PDP
         │
         ▼
https://www.purplle.com/cart
         │
         ▼
┌──────────────────────────────────────────────────────────┐
│                       CART PAGE                          │
│                                                          │
│  ┌──────────────────────────┐  ┌──────────────────────┐  │
│  │       CART ITEMS         │  │    ORDER SUMMARY     │  │
│  │  Product  Qty  Price     │  │  Subtotal:  ₹1,198   │  │
│  │  [Remove]                │  │  Discount:  -₹200    │  │
│  └──────────────────────────┘  │  Total:     ₹998     │  │
│                                │  [PROCEED TO         │  │
│  Empty state:                  │   CHECKOUT]          │  │
│  "Your bag is empty"           └──────────────────────┘  │
│  [Continue Shopping]                                     │
└──────────────────────────────────────────────────────────┘
```

**Tests:** `tests/functional/test_cart.robot` · `tests/e2e/test_guest_browse_journey.robot`

---

### 7. Wishlist Flow

```
User clicks ♡ on PDP or PLP card
         │
    ┌────┴──────────────────────┐
    │ Not logged in             │ Logged in
    ▼                           ▼
Login prompt shown          Item saved to Wishlist ✓
         │
         ▼
https://www.purplle.com/profile/myfavourites
         │
         ▼
┌─────────────────────────────────────────────────────┐
│                    WISHLIST PAGE                    │
│                                                     │
│  My Wishlist  (X items)                             │
│                                                     │
│  Product Image | Name | Price                       │
│  [Move to Bag]  [♡ Remove]                          │
│                                                     │
│  Empty state: "Your wishlist is empty"              │
└─────────────────────────────────────────────────────┘
```

> **Actual URL is `/profile/myfavourites`** — not `/wishlist`. Config and tests reflect this.

**Tests:** `tests/functional/test_wishlist.robot` · `tests/e2e/test_guest_browse_journey.robot`

---

## Integration Test Flows

### Search → PDP (`test_search_to_pdp_flow.robot`)

```
Navigate to /search?q=lipstick
  └─► Search Results: product cards visible ✓
         └─► Click first product card
                └─► PDP loads ✓
                       └─► Verify name, price, Add to Bag
                              └─► Go Back → Search Results still visible ✓
```

### PLP → PDP (`test_plp_to_pdp_flow.robot`)

```
https://www.purplle.com/makeup
  └─► Products Listed ✓
         └─► Click First Product → PDP loads ✓
                └─► Verify price + Add to Bag ✓
                       └─► Go Back → PLP still shows products ✓
```

### Homepage → Category (`test_homepage_to_category_flow.robot`)

```
Homepage (verify loaded)
  ├─► Click Makeup nav  → Makeup PLP  ✓
  ├─► Click Skincare nav → Skincare PLP ✓
  ├─► Search from homepage → Results page ✓
  ├─► Click Login link → /profile page ✓
  └─► Click Cart icon  → Cart page ✓
```

### Search → Sort → Filter → PDP (`test_search_filter_flow.robot`)

```
Navigate to /search?q=foundation
  └─► Results displayed ✓
         ├─► Sort: Price Low→High → Results re-order ✓
         └─► Category PLP: Select Brand Filter
                └─► Filtered products displayed ✓
                       └─► Click first filtered product → PDP ✓
```

---

## E2E Journey Flows

### Journey 1 — Guest Browse (`test_guest_browse_journey.robot`)

```
START: https://www.purplle.com
  ▼  Homepage verified ✓
  ▼  Click "Makeup" in nav bar → Makeup PLP ✓
  ▼  Click first product card → PDP ✓
  ▼  Navigate to https://www.purplle.com/cart
  ▼  Cart Page — empty cart message displayed ✓
  ▼  Navigate to https://www.purplle.com/profile/myfavourites
  ▼  Wishlist Page — empty wishlist / login prompt displayed ✓
END ✓
```

### Journey 2 — Search and View (`test_search_and_view_journey.robot`)

```
START: https://www.purplle.com
  ▼  Homepage verified ✓
  ▼  Navigate to /search?q=lipstick → Results shown ✓
  ▼  Sort: Price Low → High → Products re-ordered ✓
  ▼  Click first result → PDP loads ✓
  ▼  Verify: name, price, Add to Bag, images visible ✓
  ▼  Navigate to /search?q=moisturizer → Click first result → PDP ✓
END ✓
```

### Journey 3 — Category Navigation (`test_category_navigation_journey.robot`)

```
START: https://www.purplle.com
  ▼  Homepage verified ✓
  ▼  Click "Makeup" nav → PLP ✓ → Click first product → PDP ✓
  ▼  Go Back → PLP still has products ✓
  ▼  Click "Skincare" nav → Skincare PLP ✓
  ▼  Open first Skincare product → PDP ✓
  ▼  Navigate to Offers page → loads ✓
END ✓
```

---

## API Test Flow

```
Suite Setup: Create Session "purplle"  (base URL + headers)
         │
For each API Test Case:
         ├── GET /api/search?q=lipstick  →  assert status not 5xx
         ├── GET /api/products           →  assert status not 5xx
         ├── GET homepage               →  assert response time < 10s
         └── Assert HTTPS enforced      →  URL starts with https://
         │
Suite Teardown: Delete All Sessions
```

> API endpoint paths (`/api/search`, `/api/products`, etc.) are best-guess patterns. Confirm actual paths via **Chrome DevTools → Network tab** before running `tests/api/`.

---

## Data-Driven Search Flow

How DataDriver generates 8 separate test cases from one CSV file.

```
testdata/purplle_search_keywords.csv
  ┌───────────────────┐
  │ ${search_keyword} │   ← RF variable format required by DataDriver
  │ lipstick          │  ─────► TC 1: Search "lipstick"    → results ✓
  │ foundation        │  ─────► TC 2: Search "foundation"  → results ✓
  │ moisturizer       │  ─────► TC 3: Search "moisturizer" → results ✓
  │ serum             │  ─────► TC 4: Search "serum"       → results ✓
  │ shampoo           │  ─────► TC 5: Search "shampoo"     → results ✓
  │ perfume           │  ─────► TC 6: Search "perfume"     → results ✓
  │ kajal             │  ─────► TC 7: Search "kajal"       → results ✓
  │ sunscreen         │  ─────► TC 8: Search "sunscreen"   → results ✓
  └───────────────────┘

DataDriver reads CSV → generates 8 test cases at runtime
Each test case:
  [Setup]   Go To https://www.purplle.com
  Step 1:   Go To https://www.purplle.com/search?q=${search_keyword}
  Step 2:   Wait Until Element Visible  (//a[href=/product/ and class=d-block])[1]
  [Result]  PASS if product cards appear, FAIL if no results / timeout
```

### DataDriver + RF 7 Compatibility Notes

| Requirement | Detail |
|-------------|--------|
| CSV column header format | Must use `${variable}` syntax (e.g., `${search_keyword}`), not plain text |
| Template keyword location | Must be in the test file's own `*** Keywords ***` section — DataDriver cannot find keywords from imported Resource files at listener init time |
| Template declaration | Use `Test Template` in `*** Settings ***` (global) — both global and per-test `[Template]` set `test.template` correctly in RF 7 |

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
   - `TC_FUNC_HOME_11`, `TC_INT_FILTER_06`, `TC_E2E_GUEST_04`, `TC_API_SEARCH_08`
5. **Tag every test** with at least `functional/integration/e2e/api` + feature tag + `smoke` or `regression`

---

## Test Reports

After a run, open `outputs/reports/report.html` in a browser for an interactive summary.

```powershell
robot -d outputs tests/
start outputs\reports\report.html     # Windows
```

---

## Important Notes

- **OTP Login**: Purplle uses phone OTP authentication. OTP cannot be automated, so all login tests cover only form validation and UI element presence. Tests requiring a logged-in session must be run manually.
- **Angular / Dynamic Content**: Purplle.com is an Angular app with JavaScript-rendered content. All element waits use `Wait Until Element Is Visible` with a 15-second timeout — never `Sleep`. The search bar does not respond to keyboard `ENTER` for navigation; the framework uses direct URL navigation to `/search?q=keyword` instead.
- **Wishlist URL**: The actual wishlist page is at `/profile/myfavourites`, not `/wishlist`. Config and all tests use this correct path.
- **"ADD TO BAG"**: Purplle uses this label instead of "Add to Cart". All locators in `product_detail_page_locators.robot` reflect this.
- **`Title Should Contain`**: SeleniumLibrary only provides `Title Should Be` (exact match). A custom `Title Should Contain` keyword is defined in `common_resources.robot` and is available to all tests.
