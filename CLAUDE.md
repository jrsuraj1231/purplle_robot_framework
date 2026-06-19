# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Setup

```bash
# Install all dependencies (including API testing and config support)
pip install -r requirements.txt
```

## Running Tests

```bash
# Run an entire category
robot -d outputs tests/functional/
robot -d outputs tests/integration/
robot -d outputs tests/e2e/
robot -d outputs tests/api/

# Run a single file
robot -d outputs tests/functional/test_homepage.robot
robot -d outputs tests/api/test_search_api.robot

# Run by tag (use --include, not --tag)
robot -d outputs --include smoke tests/
robot -d outputs --include regression tests/
robot -d outputs --include functional tests/
robot -d outputs --include data_driven tests/

# Headless mode — required on Linux CI / servers without a display
robot -d outputs -v HEADLESS:true tests/

# Dry run (validate keywords without launching browser)
robot -d outputs --dryrun tests/

# Run all test suites in parallel
pabot tests/
```

## Output Folder Structure

```
outputs/
├── output.xml    ← machine-readable results
├── log.html      ← step-by-step detail
├── report.html   ← interactive summary
└── screenshots/  ← selenium screenshots on failure (set automatically by Open Application)
```

The application under test is **https://www.purplle.com** — an Indian beauty e-commerce website.

---

## Project Structure

```
config/
  config.yaml          ← Single source of truth: URLs, browser, API endpoints, test data
  readme.py            ← Robot Framework Python library that reads config.yaml

locators/              ← Element locators as RF variables (one file per page)
resources/
  common_resources.robot   ← Browser open/close; BASE_URL, TIMEOUT variables
  pages/               ← Page-level keyword definitions (one file per page/module)

testdata/
  purplle_search_keywords.csv   ← Keywords for data-driven search tests

tests/
  functional/          ← Single-feature tests (one module at a time)
  integration/         ← Multi-module flow tests (module A → module B)
  e2e/                 ← Full user journey tests (start to finish)
  api/                 ← HTTP-level tests via RequestsLibrary (no browser)
```

## Test Layer Responsibilities

| Layer | What it tests | Imports |
|-------|--------------|---------|
| `functional/` | One feature/page in isolation | 1–2 page resources |
| `integration/` | Two or more modules working together end-to-end within the browser | 2+ page resources |
| `e2e/` | Complete realistic user journeys (guest browse, search-to-PDP, category-to-cart) | All relevant page resources |
| `api/` | HTTP responses, status codes, HTTPS enforcement, response time | `RequestsLibrary` only |

## Architecture

**Dependency flow (UI tests):**
```
tests/**/*.robot  →  resources/pages/*.robot  →  locators/*_locators.robot
```

**Key libraries:**
- `SeleniumLibrary` — browser automation (Chrome by default; `${BROWSER}` in `common_resources.robot`)
- `RequestsLibrary` — HTTP API testing in `tests/api/`
- `DataDriver` (CSV) — generates test cases from `testdata/purplle_search_keywords.csv`
- `pabot` — parallel suite execution

## Configuration (`config/config.yaml`)

All URLs, browser settings, API endpoints, and test credentials live in `config/config.yaml`. Import `config/readme.py` as a Robot Framework Library to read values:

```robot
Library    ../../config/readme.py

${url}=    Get Base Url
${timeout}=    Get Timeout
${mobile}=    Get Test Credential    mobile
```

## Key Conventions

- **Paths**: Tests in `tests/functional/`, `integration/`, `e2e/` use `../../resources/` and `../../locators/`. Tests in `tests/` root (legacy) use `../resources/`.
- **Locators**: Always go in `locators/*_locators.robot` — never inline in keywords or test cases.
- **Waits**: Use `Wait Until Element Is Visible` with explicit timeout. Never use `Sleep` as a substitute for proper waits.
- **Authentication**: Purplle uses phone OTP login which cannot be automated. Tests requiring login state are tagged `requires_login` and skipped in CI; functional/integration/e2e tests cover only guest (unauthenticated) flows.
- **Purplle-specific**: The site says "ADD TO BAG" not "Add to Cart". All relevant locators in `product_detail_page_locators.robot` reflect this.
- **API tests**: Endpoints in `config/config.yaml` under `api.endpoints` are best guesses — verify actual paths from browser DevTools Network tab before running `tests/api/`.
- **Test IDs**: Format is `TC_<LAYER>_<MODULE>_<NN>` — e.g. `TC_FUNC_HOME_01`, `TC_INT_FILTER_03`, `TC_E2E_GUEST_02`, `TC_API_SEARCH_06`.
