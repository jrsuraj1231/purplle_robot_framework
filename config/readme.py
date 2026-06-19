"""
Purplle.com Test Framework - Configuration Library

Usage in Robot Framework:
    Library    ../../config/readme.py

Available keywords:
    Get Browser
    Get Base Url
    Get Timeout
    Get Implicit Wait
    Get Page Url          login | cart | wishlist | offers | brands
    Get Category Url      makeup | skincare | hair | bath_body | wellness
    Get Api Endpoint      search | autocomplete | products | categories | cart | wishlist
    Get Api Headers
    Get Test Credential   mobile | email | password
    Get Search Keywords
"""

import yaml
import os


class readme:
    """Robot Framework library that exposes config.yaml values as keywords."""

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '1.0'

    def __init__(self):
        config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config.yaml')
        with open(config_path, 'r') as fh:
            self._config = yaml.safe_load(fh)

    def get_browser(self):
        """Return configured browser name (e.g. chrome)."""
        return self._config['browser']['name']

    def get_base_url(self):
        """Return the application base URL."""
        return self._config['base_url']

    def get_timeout(self):
        """Return Selenium timeout as a string (e.g. '15s')."""
        return f"{self._config['browser']['timeout']}s"

    def get_implicit_wait(self):
        """Return implicit wait as a string (e.g. '10s')."""
        return f"{self._config['browser']['implicit_wait']}s"

    def get_page_url(self, page_key):
        """Return the full URL for a named page (login, cart, wishlist, etc.)."""
        return self._config['urls'].get(page_key, self._config['base_url'])

    def get_category_url(self, category):
        """Return the full URL for a product category (makeup, skincare, hair, etc.)."""
        return self._config['urls']['categories'].get(category, self._config['base_url'])

    def get_api_endpoint(self, endpoint_key):
        """Return the full URL for a named API endpoint."""
        base = self._config['api']['base_url']
        path = self._config['api']['endpoints'][endpoint_key]
        return f"{base}{path}"

    def get_api_headers(self):
        """Return API request headers as a dictionary."""
        return dict(self._config['api']['headers'])

    def get_test_credential(self, credential_type):
        """Return a test credential value: mobile, email, or password."""
        return str(self._config['test_credentials'][credential_type])

    def get_search_keywords(self):
        """Return the list of test search keywords from config."""
        return list(self._config['test_data']['search_keywords'])

    def get_test_brands(self):
        """Return the list of test brand names from config."""
        return list(self._config['test_data']['brands'])

    def get_invalid_mobile_numbers(self):
        """Return list of invalid mobile numbers for negative testing."""
        return list(self._config['test_data']['invalid_mobile_numbers'])

    def get_config_value(self, *keys):
        """Generic accessor: traverse config by a sequence of keys.

        Example: Get Config Value    browser    name  =>  'chrome'
        """
        value = self._config
        for key in keys:
            value = value[key]
        return value
