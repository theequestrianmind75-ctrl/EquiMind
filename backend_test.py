#!/usr/bin/env python3
"""
EquiMind Backend API Testing - Session Endpoints Fix Verification
Testing the fix for "detail not found" error in session endpoints.

FIX APPLIED:
- Removed authentication (Depends(get_current_user)) from:
  1. GET /api/sessions/{session_id} (line 503)
  2. PATCH /api/sessions/{session_id} (line 510)
- Also removed rider_id filter from both endpoints
"""

import requests
import json
import sys
from typing import Dict, Any
import os
from dotenv import load_dotenv
import uuid
from datetime import datetime

# Load environment variables
load_dotenv('/app/frontend/.env')

# Get backend URL from frontend environment
BACKEND_URL = os.getenv('EXPO_PUBLIC_BACKEND_URL', 'https://mental-rider.preview.emergentagent.com')
API_BASE = f"{BACKEND_URL}/api"

print(f"🔗 Testing backend at: {API_BASE}")
print("🎯 FOCUS: Session endpoints fix verification")

class TestResults:
    def __init__(self):
        self.passed = 0
        self.failed = 0
        self.results = []
    
    def add_result(self, test_name: str, passed: bool, message: str):
        self.results.append({
            'test': test_name,
            'passed': passed,
            'message': message
        })
        if passed:
            self.passed += 1
            print(f"✅ {test_name}: {message}")
        else:
            self.failed += 1
            print(f"❌ {test_name}: {message}")
    
    def summary(self):
        total = self.passed + self.failed
        print(f"\n📊 Test Summary: {self.passed}/{total} passed, {self.failed} failed")
        return self.failed == 0

def get_auth_token():
    """Get authentication token for creating test sessions"""
    try:
        # Register a test user
        test_email = f"rider_{uuid.uuid4().hex[:8]}@equimind.com"
        register_data = {
            "email": test_email,
            "password": "SecureRider123!",
            "name": "Sarah Johnson"
        }
        
        response = requests.post(f"{API_BASE}/auth/register", json=register_data, timeout=10)
        if response.status_code in [200, 201]:
            token_data = response.json()
            return token_data.get("access_token"), test_email
        else:
            print(f"    Failed to register user: {response.status_code} - {response.text}")
            return None, None
    except Exception as e:
        print(f"    Exception during registration: {str(e)}")
        return None, None

def create_test_session(token):
    """Create a test session for testing purposes"""
    session_data = {
        "session_type": "pre-ride",
        "ride_type": "training",
        "context": "training",
        "rider_name": "Sarah Johnson",
        "anxiety_level": 6,
        "confidence_level": 4,
        "notes": "Preparing for dressage training session",
        "horse_name": "Thunder",
        "horse_energy_level": 7,
        "horse_focus_level": 6,
        "horse_responsiveness": 8,
        "horse_notes": "Alert and responsive today"
    }
    
    headers = {"Authorization": f"Bearer {token}"}
    
    try:
        response = requests.post(f"{API_BASE}/sessions", json=session_data, headers=headers, timeout=10)
        if response.status_code in [200, 201]:
            session = response.json()
            return session.get("id"), session
        else:
            print(f"    Failed to create test session: {response.status_code} - {response.text}")
            return None, None
    except Exception as e:
        print(f"    Exception creating test session: {str(e)}")
        return None, None

def test_get_single_session_no_auth(session_id):
    """Test GET /api/sessions/{session_id} WITHOUT authentication (FIXED)"""
    try:
        response = requests.get(f"{API_BASE}/sessions/{session_id}", timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            if 'id' in data and 'session_type' in data:
                return True, f"SUCCESS - Retrieved session: {data.get('rider_name', 'Unknown')} - {data.get('session_type', 'Unknown')}"
            else:
                return False, f"SUCCESS but missing required fields: {list(data.keys())}"
        elif response.status_code == 404:
            return False, f"CRITICAL: Still getting 404 'Session not found' - fix not working"
        elif response.status_code == 403:
            return False, f"CRITICAL: Still getting 403 Forbidden - auth middleware not removed from line 503"
        else:
            return False, f"Unexpected status {response.status_code}: {response.text[:200]}"
            
    except Exception as e:
        return False, f"Request failed: {str(e)}"

def test_patch_session_no_auth(session_id):
    """Test PATCH /api/sessions/{session_id} WITHOUT authentication (FIXED)"""
    update_data = {
        "completed": True,
        "anxiety_level": 5,
        "confidence_level": 7,
        "notes": "Session completed successfully - anxiety reduced, confidence improved"
    }
    
    try:
        response = requests.patch(f"{API_BASE}/sessions/{session_id}", json=update_data, timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            if 'id' in data and data.get('completed') == True:
                return True, f"SUCCESS - Session updated: completed={data.get('completed')}, anxiety={data.get('anxiety_level')}, confidence={data.get('confidence_level')}"
            else:
                return False, f"SUCCESS but update not reflected: completed={data.get('completed')}"
        elif response.status_code == 404:
            return False, f"CRITICAL: Still getting 404 'Session not found' - fix not working"
        elif response.status_code == 403:
            return False, f"CRITICAL: Still getting 403 Forbidden - auth middleware not removed from line 510"
        else:
            return False, f"Unexpected status {response.status_code}: {response.text[:200]}"
            
    except Exception as e:
        return False, f"Request failed: {str(e)}"

def test_get_sessions_list_no_auth():
    """Test GET /api/sessions WITHOUT authentication (should already work)"""
    try:
        response = requests.get(f"{API_BASE}/sessions", timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            if isinstance(data, list):
                return True, f"SUCCESS - Got {len(data)} sessions"
            else:
                return False, f"SUCCESS but unexpected data format: {type(data)}"
        elif response.status_code == 403:
            return False, f"CRITICAL: Getting 403 Forbidden - should be public"
        else:
            return False, f"Unexpected status {response.status_code}: {response.text[:200]}"
            
    except Exception as e:
        return False, f"Request failed: {str(e)}"

def test_public_recommendations():
    """Test GET /api/recommendations (should be public)"""
    try:
        response = requests.get(f"{API_BASE}/recommendations", timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            if isinstance(data, list):
                return True, f"SUCCESS - Got {len(data)} recommendations"
            else:
                return False, f"SUCCESS but unexpected data format: {type(data)}"
        elif response.status_code == 403:
            return False, f"CRITICAL: Getting 403 Forbidden on recommendations endpoint"
        else:
            return False, f"Unexpected status {response.status_code}: {response.text[:200]}"
            
    except Exception as e:
        return False, f"Request failed: {str(e)}"

def test_protected_session_create():
    """Test POST /api/sessions WITHOUT auth (should still be protected - return 403)"""
    try:
        session_data = {
            "session_type": "post-ride",
            "ride_type": "competition",
            "rider_name": "Test Rider",
            "anxiety_level": 3,
            "confidence_level": 8
        }
        
        response = requests.post(f"{API_BASE}/sessions", json=session_data, timeout=10)
        
        if response.status_code == 403:
            return True, f"SUCCESS - Protected endpoint correctly returns 403 Forbidden without auth"
        elif response.status_code == 401:
            return True, f"SUCCESS - Protected endpoint correctly returns 401 Unauthorized without auth"
        elif response.status_code == 422:
            return False, f"CRITICAL: Endpoint not protected - got validation error instead of auth error"
        else:
            return False, f"CRITICAL: Endpoint not protected - got status {response.status_code}: {response.text[:100]}"
            
    except Exception as e:
        return False, f"Request failed: {str(e)}"

def test_protected_session_delete(session_id):
    """Test DELETE /api/sessions/{session_id} WITHOUT auth (should still be protected - return 403)"""
    try:
        response = requests.delete(f"{API_BASE}/sessions/{session_id}", timeout=10)
        
        if response.status_code == 403:
            return True, f"SUCCESS - Protected endpoint correctly returns 403 Forbidden without auth"
        elif response.status_code == 401:
            return True, f"SUCCESS - Protected endpoint correctly returns 401 Unauthorized without auth"
        else:
            return False, f"CRITICAL: Endpoint not protected - got status {response.status_code}: {response.text[:100]}"
            
    except Exception as e:
        return False, f"Request failed: {str(e)}"

def main():
    print("🧪 EquiMind Backend API Testing - Session Endpoints Fix Verification")
    print("🎯 TESTING: Fix for 'detail not found' error in session endpoints")
    print("=" * 70)
    
    results = TestResults()
    
    # Step 1: Get authentication token and create test session
    print("\n🔐 Step 1: Setting up test session...")
    token, email = get_auth_token()
    if not token:
        print("❌ CRITICAL: Cannot obtain auth token - aborting tests")
        return 1
    
    print(f"✅ Authenticated as: {email}")
    
    session_id, session_data = create_test_session(token)
    if not session_id:
        print("❌ CRITICAL: Cannot create test session - aborting tests")
        return 1
    
    print(f"✅ Created test session: {session_id}")
    print(f"   Session details: {session_data.get('rider_name')} - {session_data.get('session_type')}")
    
    # Step 2: Test the FIXED endpoints (main focus)
    print("\n🎯 Step 2: Testing FIXED session endpoints (WITHOUT authentication):")
    
    passed, msg = test_get_single_session_no_auth(session_id)
    results.add_result("GET /api/sessions/{id} (FIXED)", passed, msg)
    
    passed, msg = test_patch_session_no_auth(session_id)
    results.add_result("PATCH /api/sessions/{id} (FIXED)", passed, msg)
    
    # Step 3: Test existing public endpoint
    print("\n📊 Step 3: Testing existing public endpoint:")
    
    passed, msg = test_get_sessions_list_no_auth()
    results.add_result("GET /api/sessions (Already Public)", passed, msg)
    
    # Step 4: Test protected endpoints (should still be protected)
    print("\n🔒 Step 4: Testing PROTECTED endpoints (should still require auth):")
    
    passed, msg = test_protected_session_create()
    results.add_result("POST /api/sessions (Protected)", passed, msg)
    
    passed, msg = test_protected_session_delete(session_id)
    results.add_result("DELETE /api/sessions/{id} (Protected)", passed, msg)
    
    # Summary
    success = results.summary()
    
    print("\n" + "=" * 70)
    if success:
        print("🎉 SESSION ENDPOINTS FIX VERIFICATION: SUCCESS")
        print("✅ GET /api/sessions/{id} - 200 OK (FIXED)")
        print("✅ PATCH /api/sessions/{id} - 200 OK (FIXED)")
        print("✅ GET /api/sessions - 200 OK (Already working)")
        print("✅ POST /api/sessions - 403 Forbidden (Protected)")
        print("✅ DELETE /api/sessions/{id} - 403 Forbidden (Protected)")
        print("\n🔧 The 'detail not found' error has been resolved!")
        print("🚀 Session endpoints are now working correctly in the deployed app")
        return 0
    else:
        print("❌ SESSION ENDPOINTS FIX VERIFICATION: FAILED")
        print("⚠️  Some endpoints are not working as expected")
        print("\nFailed tests:")
        for result in results.results:
            if not result['passed']:
                print(f"❌ {result['test']}: {result['message']}")
        return 1

if __name__ == "__main__":
    sys.exit(main())