#!/usr/bin/env python3
"""
Comprehensive Backend API Testing for EquiMind Mobile App
Tests authentication, mental strategies, and session management APIs
"""

import requests
import json
import sys
from datetime import datetime

# Backend URL from environment
BACKEND_URL = "https://equimind-mobile.preview.emergentagent.com/api"

# Test data
test_user = {
    "email": f"rider_{datetime.now().timestamp()}@equimind.com",
    "password": "SecurePass123!",
    "name": "Emma Rodriguez"
}

# Color codes for output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

class TestResults:
    def __init__(self):
        self.passed = 0
        self.failed = 0
        self.errors = []
    
    def add_pass(self, test_name):
        self.passed += 1
        print(f"{GREEN}✓{RESET} {test_name}")
    
    def add_fail(self, test_name, error):
        self.failed += 1
        self.errors.append({"test": test_name, "error": error})
        print(f"{RED}✗{RESET} {test_name}")
        print(f"  {RED}Error: {error}{RESET}")
    
    def print_summary(self):
        total = self.passed + self.failed
        print(f"\n{'='*60}")
        print(f"TEST SUMMARY")
        print(f"{'='*60}")
        print(f"Total Tests: {total}")
        print(f"{GREEN}Passed: {self.passed}{RESET}")
        print(f"{RED}Failed: {self.failed}{RESET}")
        
        if self.errors:
            print(f"\n{RED}FAILED TESTS:{RESET}")
            for i, error in enumerate(self.errors, 1):
                print(f"{i}. {error['test']}")
                print(f"   {error['error']}")
        
        return self.failed == 0

results = TestResults()
auth_token = None
test_session_id = None

def test_auth_register():
    """Test user registration"""
    global auth_token
    print(f"\n{BLUE}Testing: User Registration{RESET}")
    
    try:
        response = requests.post(
            f"{BACKEND_URL}/auth/register",
            json=test_user,
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("POST /auth/register", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        # Verify response structure
        if "access_token" not in data:
            results.add_fail("POST /auth/register", "Missing access_token in response")
            return False
        
        if "user" not in data or "email" not in data["user"]:
            results.add_fail("POST /auth/register", "Missing user data in response")
            return False
        
        if data["user"]["email"] != test_user["email"]:
            results.add_fail("POST /auth/register", f"Email mismatch: {data['user']['email']}")
            return False
        
        auth_token = data["access_token"]
        results.add_pass("POST /auth/register - User registration successful")
        return True
        
    except Exception as e:
        results.add_fail("POST /auth/register", str(e))
        return False

def test_auth_login():
    """Test user login"""
    global auth_token
    print(f"\n{BLUE}Testing: User Login{RESET}")
    
    try:
        response = requests.post(
            f"{BACKEND_URL}/auth/login",
            json={"email": test_user["email"], "password": test_user["password"]},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("POST /auth/login", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if "access_token" not in data:
            results.add_fail("POST /auth/login", "Missing access_token in response")
            return False
        
        auth_token = data["access_token"]
        results.add_pass("POST /auth/login - Login successful")
        return True
        
    except Exception as e:
        results.add_fail("POST /auth/login", str(e))
        return False

def test_auth_invalid_credentials():
    """Test login with invalid credentials"""
    print(f"\n{BLUE}Testing: Invalid Login Credentials{RESET}")
    
    try:
        response = requests.post(
            f"{BACKEND_URL}/auth/login",
            json={"email": test_user["email"], "password": "WrongPassword123"},
            timeout=10
        )
        
        if response.status_code != 401:
            results.add_fail("POST /auth/login (invalid)", f"Expected 401, got {response.status_code}")
            return False
        
        results.add_pass("POST /auth/login - Invalid credentials rejected (401)")
        return True
        
    except Exception as e:
        results.add_fail("POST /auth/login (invalid)", str(e))
        return False

def test_auth_duplicate_registration():
    """Test duplicate email registration"""
    print(f"\n{BLUE}Testing: Duplicate Email Registration{RESET}")
    
    try:
        response = requests.post(
            f"{BACKEND_URL}/auth/register",
            json=test_user,
            timeout=10
        )
        
        if response.status_code != 400:
            results.add_fail("POST /auth/register (duplicate)", f"Expected 400, got {response.status_code}")
            return False
        
        results.add_pass("POST /auth/register - Duplicate email rejected (400)")
        return True
        
    except Exception as e:
        results.add_fail("POST /auth/register (duplicate)", str(e))
        return False

def test_auth_me():
    """Test getting current user info"""
    print(f"\n{BLUE}Testing: Get Current User{RESET}")
    
    if not auth_token:
        results.add_fail("GET /auth/me", "No auth token available")
        return False
    
    try:
        response = requests.get(
            f"{BACKEND_URL}/auth/me",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("GET /auth/me", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if data["email"] != test_user["email"]:
            results.add_fail("GET /auth/me", f"Email mismatch: {data['email']}")
            return False
        
        results.add_pass("GET /auth/me - User info retrieved")
        return True
        
    except Exception as e:
        results.add_fail("GET /auth/me", str(e))
        return False

def test_auth_me_no_token():
    """Test protected endpoint without token"""
    print(f"\n{BLUE}Testing: Protected Endpoint Without Token{RESET}")
    
    try:
        response = requests.get(
            f"{BACKEND_URL}/auth/me",
            timeout=10
        )
        
        if response.status_code != 403:
            results.add_fail("GET /auth/me (no token)", f"Expected 403, got {response.status_code}")
            return False
        
        results.add_pass("GET /auth/me - No token rejected (403)")
        return True
        
    except Exception as e:
        results.add_fail("GET /auth/me (no token)", str(e))
        return False

def test_mental_strategies_list():
    """Test listing mental strategies"""
    print(f"\n{BLUE}Testing: List Mental Strategies{RESET}")
    
    if not auth_token:
        results.add_fail("GET /mental-strategies", "No auth token available")
        return False
    
    try:
        response = requests.get(
            f"{BACKEND_URL}/mental-strategies",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("GET /mental-strategies", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if not isinstance(data, list):
            results.add_fail("GET /mental-strategies", "Response is not a list")
            return False
        
        strategy_count = len(data)
        
        # Check if we have 144 strategies as mentioned
        if strategy_count != 144:
            results.add_fail("GET /mental-strategies", f"Expected 144 strategies, got {strategy_count}")
            return False
        
        # Verify structure of first strategy
        if strategy_count > 0:
            strategy = data[0]
            required_fields = ["id", "name", "category"]
            for field in required_fields:
                if field not in strategy:
                    results.add_fail("GET /mental-strategies", f"Missing field '{field}' in strategy")
                    return False
        
        results.add_pass(f"GET /mental-strategies - Retrieved {strategy_count} strategies")
        return True
        
    except Exception as e:
        results.add_fail("GET /mental-strategies", str(e))
        return False

def test_mental_strategies_filter_category():
    """Test filtering strategies by category"""
    print(f"\n{BLUE}Testing: Filter Strategies by Category{RESET}")
    
    if not auth_token:
        results.add_fail("GET /mental-strategies?category=", "No auth token available")
        return False
    
    try:
        response = requests.get(
            f"{BACKEND_URL}/mental-strategies?category=breathing",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("GET /mental-strategies?category=breathing", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if not isinstance(data, list):
            results.add_fail("GET /mental-strategies?category=breathing", "Response is not a list")
            return False
        
        results.add_pass(f"GET /mental-strategies?category=breathing - Retrieved {len(data)} strategies")
        return True
        
    except Exception as e:
        results.add_fail("GET /mental-strategies?category=breathing", str(e))
        return False

def test_mental_strategy_detail():
    """Test getting a specific strategy"""
    print(f"\n{BLUE}Testing: Get Strategy Detail{RESET}")
    
    if not auth_token:
        results.add_fail("GET /mental-strategies/{id}", "No auth token available")
        return False
    
    try:
        # First get list to get a valid ID
        list_response = requests.get(
            f"{BACKEND_URL}/mental-strategies",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if list_response.status_code != 200 or not list_response.json():
            results.add_fail("GET /mental-strategies/{id}", "Could not get strategy list")
            return False
        
        strategy_id = list_response.json()[0]["id"]
        
        # Now get specific strategy
        response = requests.get(
            f"{BACKEND_URL}/mental-strategies/{strategy_id}",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("GET /mental-strategies/{id}", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if data["id"] != strategy_id:
            results.add_fail("GET /mental-strategies/{id}", f"ID mismatch: {data['id']}")
            return False
        
        results.add_pass(f"GET /mental-strategies/{strategy_id} - Strategy detail retrieved")
        return True
        
    except Exception as e:
        results.add_fail("GET /mental-strategies/{id}", str(e))
        return False

def test_mental_strategy_not_found():
    """Test getting non-existent strategy"""
    print(f"\n{BLUE}Testing: Get Non-existent Strategy{RESET}")
    
    if not auth_token:
        results.add_fail("GET /mental-strategies/{invalid}", "No auth token available")
        return False
    
    try:
        response = requests.get(
            f"{BACKEND_URL}/mental-strategies/invalid-id-12345",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 404:
            results.add_fail("GET /mental-strategies/{invalid}", f"Expected 404, got {response.status_code}")
            return False
        
        results.add_pass("GET /mental-strategies/{invalid} - Not found (404)")
        return True
        
    except Exception as e:
        results.add_fail("GET /mental-strategies/{invalid}", str(e))
        return False

def test_session_create():
    """Test creating a session"""
    global test_session_id
    print(f"\n{BLUE}Testing: Create Session{RESET}")
    
    if not auth_token:
        results.add_fail("POST /sessions", "No auth token available")
        return False
    
    try:
        session_data = {
            "session_type": "pre-ride",
            "ride_type": "training",
            "anxiety_level": 6,
            "confidence_level": 7,
            "notes": "Preparing for dressage training session",
            "strategies_used": []
        }
        
        response = requests.post(
            f"{BACKEND_URL}/sessions",
            json=session_data,
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("POST /sessions", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if "id" not in data:
            results.add_fail("POST /sessions", "Missing id in response")
            return False
        
        if data["session_type"] != session_data["session_type"]:
            results.add_fail("POST /sessions", f"Session type mismatch: {data['session_type']}")
            return False
        
        test_session_id = data["id"]
        results.add_pass(f"POST /sessions - Session created (ID: {test_session_id})")
        return True
        
    except Exception as e:
        results.add_fail("POST /sessions", str(e))
        return False

def test_session_list():
    """Test listing sessions"""
    print(f"\n{BLUE}Testing: List Sessions{RESET}")
    
    if not auth_token:
        results.add_fail("GET /sessions", "No auth token available")
        return False
    
    try:
        response = requests.get(
            f"{BACKEND_URL}/sessions",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("GET /sessions", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if not isinstance(data, list):
            results.add_fail("GET /sessions", "Response is not a list")
            return False
        
        results.add_pass(f"GET /sessions - Retrieved {len(data)} sessions")
        return True
        
    except Exception as e:
        results.add_fail("GET /sessions", str(e))
        return False

def test_session_get():
    """Test getting a specific session"""
    print(f"\n{BLUE}Testing: Get Session Detail{RESET}")
    
    if not auth_token:
        results.add_fail("GET /sessions/{id}", "No auth token available")
        return False
    
    if not test_session_id:
        results.add_fail("GET /sessions/{id}", "No test session ID available")
        return False
    
    try:
        response = requests.get(
            f"{BACKEND_URL}/sessions/{test_session_id}",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("GET /sessions/{id}", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if data["id"] != test_session_id:
            results.add_fail("GET /sessions/{id}", f"ID mismatch: {data['id']}")
            return False
        
        results.add_pass(f"GET /sessions/{test_session_id} - Session retrieved")
        return True
        
    except Exception as e:
        results.add_fail("GET /sessions/{id}", str(e))
        return False

def test_session_update():
    """Test updating a session"""
    print(f"\n{BLUE}Testing: Update Session{RESET}")
    
    if not auth_token:
        results.add_fail("PATCH /sessions/{id}", "No auth token available")
        return False
    
    if not test_session_id:
        results.add_fail("PATCH /sessions/{id}", "No test session ID available")
        return False
    
    try:
        update_data = {
            "anxiety_level": 4,
            "confidence_level": 8,
            "notes": "Session went well, feeling more confident",
            "completed": True
        }
        
        response = requests.patch(
            f"{BACKEND_URL}/sessions/{test_session_id}",
            json=update_data,
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("PATCH /sessions/{id}", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if data["anxiety_level"] != update_data["anxiety_level"]:
            results.add_fail("PATCH /sessions/{id}", f"Anxiety level not updated: {data['anxiety_level']}")
            return False
        
        if not data["completed"]:
            results.add_fail("PATCH /sessions/{id}", "Session not marked as completed")
            return False
        
        results.add_pass(f"PATCH /sessions/{test_session_id} - Session updated")
        return True
        
    except Exception as e:
        results.add_fail("PATCH /sessions/{id}", str(e))
        return False

def test_session_filter_completed():
    """Test filtering sessions by completed status"""
    print(f"\n{BLUE}Testing: Filter Sessions by Completed Status{RESET}")
    
    if not auth_token:
        results.add_fail("GET /sessions?completed=true", "No auth token available")
        return False
    
    try:
        response = requests.get(
            f"{BACKEND_URL}/sessions?completed=true",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("GET /sessions?completed=true", f"Status {response.status_code}: {response.text}")
            return False
        
        data = response.json()
        
        if not isinstance(data, list):
            results.add_fail("GET /sessions?completed=true", "Response is not a list")
            return False
        
        results.add_pass(f"GET /sessions?completed=true - Retrieved {len(data)} completed sessions")
        return True
        
    except Exception as e:
        results.add_fail("GET /sessions?completed=true", str(e))
        return False

def test_session_delete():
    """Test deleting a session"""
    print(f"\n{BLUE}Testing: Delete Session{RESET}")
    
    if not auth_token:
        results.add_fail("DELETE /sessions/{id}", "No auth token available")
        return False
    
    if not test_session_id:
        results.add_fail("DELETE /sessions/{id}", "No test session ID available")
        return False
    
    try:
        response = requests.delete(
            f"{BACKEND_URL}/sessions/{test_session_id}",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if response.status_code != 200:
            results.add_fail("DELETE /sessions/{id}", f"Status {response.status_code}: {response.text}")
            return False
        
        # Verify session is deleted
        get_response = requests.get(
            f"{BACKEND_URL}/sessions/{test_session_id}",
            headers={"Authorization": f"Bearer {auth_token}"},
            timeout=10
        )
        
        if get_response.status_code != 404:
            results.add_fail("DELETE /sessions/{id}", "Session still exists after deletion")
            return False
        
        results.add_pass(f"DELETE /sessions/{test_session_id} - Session deleted")
        return True
        
    except Exception as e:
        results.add_fail("DELETE /sessions/{id}", str(e))
        return False

def main():
    print(f"\n{'='*60}")
    print(f"EQUIMIND BACKEND API TEST SUITE")
    print(f"{'='*60}")
    print(f"Backend URL: {BACKEND_URL}")
    print(f"Test User: {test_user['email']}")
    print(f"{'='*60}")
    
    # Authentication Tests
    print(f"\n{YELLOW}=== AUTHENTICATION TESTS ==={RESET}")
    test_auth_register()
    test_auth_login()
    test_auth_invalid_credentials()
    test_auth_duplicate_registration()
    test_auth_me()
    test_auth_me_no_token()
    
    # Mental Strategies Tests
    print(f"\n{YELLOW}=== MENTAL STRATEGIES TESTS ==={RESET}")
    test_mental_strategies_list()
    test_mental_strategies_filter_category()
    test_mental_strategy_detail()
    test_mental_strategy_not_found()
    
    # Session Management Tests
    print(f"\n{YELLOW}=== SESSION MANAGEMENT TESTS ==={RESET}")
    test_session_create()
    test_session_list()
    test_session_get()
    test_session_update()
    test_session_filter_completed()
    test_session_delete()
    
    # Print summary
    success = results.print_summary()
    
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
