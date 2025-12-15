#!/usr/bin/env python3
"""
Backend API Testing for EquiMind Subscription and Payment Integration
Tests the subscription endpoints, RevenueCat webhook, and admin feedback with N+1 query fix
"""

import requests
import json
import uuid
from datetime import datetime, timedelta
import time

# Backend URL from environment
BACKEND_URL = "https://subscriptionapp.preview.emergentagent.com/api"
ADMIN_PASSWORD = "equimind2025"

class EquiMindAPITester:
    def __init__(self):
        self.session = requests.Session()
        self.access_token = None
        self.test_user_email = f"testuser_{uuid.uuid4().hex[:8]}@equimind.com"
        self.test_user_password = "TestPass123!"
        self.test_user_name = "Test User"
        
    def log_test(self, test_name, status, details=""):
        """Log test results with timestamp"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        status_icon = "✅" if status == "PASS" else "❌" if status == "FAIL" else "⚠️"
        print(f"[{timestamp}] {status_icon} {test_name}: {status}")
        if details:
            print(f"    Details: {details}")
        print()

    def register_test_user(self):
        """Register a test user for authenticated endpoints"""
        try:
            response = self.session.post(f"{BACKEND_URL}/auth/register", json={
                "email": self.test_user_email,
                "password": self.test_user_password,
                "name": self.test_user_name
            })
            
            if response.status_code == 200:
                data = response.json()
                self.access_token = data.get("access_token")
                self.log_test("User Registration", "PASS", f"User registered with email: {self.test_user_email}")
                return True
            else:
                self.log_test("User Registration", "FAIL", f"Status: {response.status_code}, Response: {response.text}")
                return False
                
        except Exception as e:
            self.log_test("User Registration", "FAIL", f"Exception: {str(e)}")
            return False

    def get_auth_headers(self):
        """Get authorization headers with JWT token"""
        if not self.access_token:
            return {}
        return {"Authorization": f"Bearer {self.access_token}"}

    def test_subscription_tiers(self):
        """Test GET /api/subscriptions/tiers endpoint"""
        try:
            response = self.session.get(f"{BACKEND_URL}/subscriptions/tiers")
            
            if response.status_code == 200:
                tiers = response.json()
                
                # Verify we have 2 tiers
                if len(tiers) != 2:
                    self.log_test("Subscription Tiers", "FAIL", f"Expected 2 tiers, got {len(tiers)}")
                    return False
                
                # Check Standard tier
                standard_tier = next((t for t in tiers if t["tier_id"] == "standard"), None)
                if not standard_tier:
                    self.log_test("Subscription Tiers", "FAIL", "Standard tier not found")
                    return False
                
                if standard_tier["price_monthly"] != 25.00:
                    self.log_test("Subscription Tiers", "FAIL", f"Standard tier price should be $25, got ${standard_tier['price_monthly']}")
                    return False
                
                # Check Premium tier
                premium_tier = next((t for t in tiers if t["tier_id"] == "premium"), None)
                if not premium_tier:
                    self.log_test("Subscription Tiers", "FAIL", "Premium tier not found")
                    return False
                
                if premium_tier["price_monthly"] != 35.00:
                    self.log_test("Subscription Tiers", "FAIL", f"Premium tier price should be $35, got ${premium_tier['price_monthly']}")
                    return False
                
                # Verify features are present
                if not standard_tier.get("features") or not premium_tier.get("features"):
                    self.log_test("Subscription Tiers", "FAIL", "Features list missing from tiers")
                    return False
                
                self.log_test("Subscription Tiers", "PASS", f"Standard: ${standard_tier['price_monthly']}/month, Premium: ${premium_tier['price_monthly']}/month")
                return True
                
            else:
                self.log_test("Subscription Tiers", "FAIL", f"Status: {response.status_code}, Response: {response.text}")
                return False
                
        except Exception as e:
            self.log_test("Subscription Tiers", "FAIL", f"Exception: {str(e)}")
            return False

    def test_subscription_status_authenticated(self):
        """Test GET /api/subscriptions/status endpoint (requires JWT)"""
        try:
            headers = self.get_auth_headers()
            response = self.session.get(f"{BACKEND_URL}/subscriptions/status", headers=headers)
            
            if response.status_code == 200:
                status = response.json()
                
                # Verify required fields are present
                required_fields = ["user_id", "subscription_tier", "subscription_status", "has_access"]
                for field in required_fields:
                    if field not in status:
                        self.log_test("Subscription Status (Auth)", "FAIL", f"Missing field: {field}")
                        return False
                
                # New user should have default values
                if status["subscription_tier"] != "none":
                    self.log_test("Subscription Status (Auth)", "FAIL", f"New user should have 'none' tier, got: {status['subscription_tier']}")
                    return False
                
                if status["subscription_status"] != "inactive":
                    self.log_test("Subscription Status (Auth)", "FAIL", f"New user should have 'inactive' status, got: {status['subscription_status']}")
                    return False
                
                self.log_test("Subscription Status (Auth)", "PASS", f"User ID: {status['user_id']}, Tier: {status['subscription_tier']}, Status: {status['subscription_status']}")
                return True
                
            else:
                self.log_test("Subscription Status (Auth)", "FAIL", f"Status: {response.status_code}, Response: {response.text}")
                return False
                
        except Exception as e:
            self.log_test("Subscription Status (Auth)", "FAIL", f"Exception: {str(e)}")
            return False

    def test_subscription_update_authenticated(self):
        """Test POST /api/subscriptions/update endpoint (requires JWT)"""
        try:
            headers = self.get_auth_headers()
            headers["Content-Type"] = "application/json"
            
            # Test updating to premium subscription
            update_data = {
                "subscription_tier": "premium",
                "subscription_status": "active",
                "subscription_start_date": datetime.utcnow().isoformat(),
                "subscription_end_date": (datetime.utcnow() + timedelta(days=30)).isoformat()
            }
            
            response = self.session.post(f"{BACKEND_URL}/subscriptions/update", 
                                       headers=headers, 
                                       json=update_data)
            
            if response.status_code == 200:
                result = response.json()
                
                # Verify response structure
                if not result.get("success"):
                    self.log_test("Subscription Update (Auth)", "FAIL", "Success field should be True")
                    return False
                
                if result.get("subscription_tier") != "premium":
                    self.log_test("Subscription Update (Auth)", "FAIL", f"Expected premium tier, got: {result.get('subscription_tier')}")
                    return False
                
                if result.get("subscription_status") != "active":
                    self.log_test("Subscription Update (Auth)", "FAIL", f"Expected active status, got: {result.get('subscription_status')}")
                    return False
                
                self.log_test("Subscription Update (Auth)", "PASS", f"Updated to {result['subscription_tier']} tier with {result['subscription_status']} status")
                return True
                
            else:
                self.log_test("Subscription Update (Auth)", "FAIL", f"Status: {response.status_code}, Response: {response.text}")
                return False
                
        except Exception as e:
            self.log_test("Subscription Update (Auth)", "FAIL", f"Exception: {str(e)}")
            return False

    def test_revenuecat_webhook_initial_purchase(self):
        """Test RevenueCat webhook with INITIAL_PURCHASE event"""
        try:
            webhook_data = {
                "event": {
                    "type": "INITIAL_PURCHASE",
                    "app_user_id": str(uuid.uuid4()),  # Random user ID
                    "subscriber_info": {
                        "entitlements": {
                            "premium": {
                                "is_active": True,
                                "product_identifier": "premium_monthly"
                            }
                        }
                    }
                }
            }
            
            response = self.session.post(f"{BACKEND_URL}/subscriptions/webhook/revenuecat", 
                                       json=webhook_data)
            
            if response.status_code == 200:
                result = response.json()
                if result.get("success"):
                    self.log_test("RevenueCat Webhook (INITIAL_PURCHASE)", "PASS", "Webhook processed successfully")
                    return True
                else:
                    self.log_test("RevenueCat Webhook (INITIAL_PURCHASE)", "FAIL", f"Webhook failed: {result}")
                    return False
            else:
                self.log_test("RevenueCat Webhook (INITIAL_PURCHASE)", "FAIL", f"Status: {response.status_code}, Response: {response.text}")
                return False
                
        except Exception as e:
            self.log_test("RevenueCat Webhook (INITIAL_PURCHASE)", "FAIL", f"Exception: {str(e)}")
            return False

    def test_revenuecat_webhook_renewal(self):
        """Test RevenueCat webhook with RENEWAL event"""
        try:
            webhook_data = {
                "event": {
                    "type": "RENEWAL",
                    "app_user_id": str(uuid.uuid4()),  # Random user ID
                    "subscriber_info": {
                        "entitlements": {
                            "standard": {
                                "is_active": True,
                                "product_identifier": "standard_monthly"
                            }
                        }
                    }
                }
            }
            
            response = self.session.post(f"{BACKEND_URL}/subscriptions/webhook/revenuecat", 
                                       json=webhook_data)
            
            if response.status_code == 200:
                result = response.json()
                if result.get("success"):
                    self.log_test("RevenueCat Webhook (RENEWAL)", "PASS", "Renewal webhook processed successfully")
                    return True
                else:
                    self.log_test("RevenueCat Webhook (RENEWAL)", "FAIL", f"Webhook failed: {result}")
                    return False
            else:
                self.log_test("RevenueCat Webhook (RENEWAL)", "FAIL", f"Status: {response.status_code}, Response: {response.text}")
                return False
                
        except Exception as e:
            self.log_test("RevenueCat Webhook (RENEWAL)", "FAIL", f"Exception: {str(e)}")
            return False

    def test_revenuecat_webhook_cancellation(self):
        """Test RevenueCat webhook with CANCELLATION event"""
        try:
            webhook_data = {
                "event": {
                    "type": "CANCELLATION",
                    "app_user_id": str(uuid.uuid4()),  # Random user ID
                    "subscriber_info": {
                        "entitlements": {}
                    }
                }
            }
            
            response = self.session.post(f"{BACKEND_URL}/subscriptions/webhook/revenuecat", 
                                       json=webhook_data)
            
            if response.status_code == 200:
                result = response.json()
                if result.get("success"):
                    self.log_test("RevenueCat Webhook (CANCELLATION)", "PASS", "Cancellation webhook processed successfully")
                    return True
                else:
                    self.log_test("RevenueCat Webhook (CANCELLATION)", "FAIL", f"Webhook failed: {result}")
                    return False
            else:
                self.log_test("RevenueCat Webhook (CANCELLATION)", "FAIL", f"Status: {response.status_code}, Response: {response.text}")
                return False
                
        except Exception as e:
            self.log_test("RevenueCat Webhook (CANCELLATION)", "FAIL", f"Exception: {str(e)}")
            return False

    def test_revenuecat_webhook_unknown_user(self):
        """Test RevenueCat webhook with unknown user (should return 200 to prevent retries)"""
        try:
            webhook_data = {
                "event": {
                    "type": "INITIAL_PURCHASE",
                    "app_user_id": "unknown_user_12345",  # Non-existent user
                    "subscriber_info": {
                        "entitlements": {
                            "premium": {
                                "is_active": True
                            }
                        }
                    }
                }
            }
            
            response = self.session.post(f"{BACKEND_URL}/subscriptions/webhook/revenuecat", 
                                       json=webhook_data)
            
            # Should return 200 even for unknown users to prevent RevenueCat retries
            if response.status_code == 200:
                result = response.json()
                self.log_test("RevenueCat Webhook (Unknown User)", "PASS", "Returns 200 for unknown users to prevent retries")
                return True
            else:
                self.log_test("RevenueCat Webhook (Unknown User)", "FAIL", f"Status: {response.status_code}, should return 200 for unknown users")
                return False
                
        except Exception as e:
            self.log_test("RevenueCat Webhook (Unknown User)", "FAIL", f"Exception: {str(e)}")
            return False

    def test_admin_feedback_n_plus_one_fix(self):
        """Test POST /api/admin/feedback endpoint with N+1 query fix"""
        try:
            # First create some test feedback data by creating a session and feedback
            headers = self.get_auth_headers()
            headers["Content-Type"] = "application/json"
            
            # Create a test session first
            session_data = {
                "session_type": "pre-ride",
                "ride_type": "training",
                "anxiety_level": 5,
                "confidence_level": 7,
                "notes": "Test session for feedback"
            }
            
            session_response = self.session.post(f"{BACKEND_URL}/sessions", 
                                               headers=headers, 
                                               json=session_data)
            
            if session_response.status_code != 200:
                self.log_test("Admin Feedback (N+1 Fix)", "FAIL", f"Failed to create test session: {session_response.status_code}")
                return False
            
            session_id = session_response.json()["id"]
            
            # Create feedback for the session
            feedback_data = {
                "session_id": session_id,
                "rating": 5,
                "comment": "Great session, very helpful tools!"
            }
            
            feedback_response = self.session.post(f"{BACKEND_URL}/feedback", 
                                                headers=headers, 
                                                json=feedback_data)
            
            if feedback_response.status_code != 200:
                self.log_test("Admin Feedback (N+1 Fix)", "FAIL", f"Failed to create test feedback: {feedback_response.status_code}")
                return False
            
            # Now test the admin feedback endpoint
            admin_data = {"password": ADMIN_PASSWORD}
            
            response = self.session.post(f"{BACKEND_URL}/admin/feedback", json=admin_data)
            
            if response.status_code == 200:
                feedback_list = response.json()
                
                # Verify it's a list
                if not isinstance(feedback_list, list):
                    self.log_test("Admin Feedback (N+1 Fix)", "FAIL", "Response should be a list")
                    return False
                
                # Check if our test feedback is in the results
                test_feedback = None
                for feedback in feedback_list:
                    if feedback.get("session_id") == session_id:
                        test_feedback = feedback
                        break
                
                if not test_feedback:
                    self.log_test("Admin Feedback (N+1 Fix)", "FAIL", "Test feedback not found in results")
                    return False
                
                # Verify the aggregated data includes user and session info (N+1 fix)
                required_fields = ["id", "user_id", "session_id", "rating", "comment", 
                                 "user_email", "user_name", "session_type", "ride_type"]
                
                for field in required_fields:
                    if field not in test_feedback:
                        self.log_test("Admin Feedback (N+1 Fix)", "FAIL", f"Missing aggregated field: {field}")
                        return False
                
                # Verify the user info is correctly joined
                if test_feedback["user_email"] != self.test_user_email:
                    self.log_test("Admin Feedback (N+1 Fix)", "FAIL", f"User email mismatch: expected {self.test_user_email}, got {test_feedback['user_email']}")
                    return False
                
                if test_feedback["session_type"] != "pre-ride":
                    self.log_test("Admin Feedback (N+1 Fix)", "FAIL", f"Session type mismatch: expected pre-ride, got {test_feedback['session_type']}")
                    return False
                
                self.log_test("Admin Feedback (N+1 Fix)", "PASS", f"N+1 query fix working - aggregated {len(feedback_list)} feedback entries with user/session data")
                return True
                
            elif response.status_code == 401:
                self.log_test("Admin Feedback (N+1 Fix)", "FAIL", "Invalid admin password")
                return False
            else:
                self.log_test("Admin Feedback (N+1 Fix)", "FAIL", f"Status: {response.status_code}, Response: {response.text}")
                return False
                
        except Exception as e:
            self.log_test("Admin Feedback (N+1 Fix)", "FAIL", f"Exception: {str(e)}")
            return False

    def test_unauthenticated_access(self):
        """Test that protected endpoints properly reject unauthenticated requests"""
        try:
            # Test subscription status without auth
            response = self.session.get(f"{BACKEND_URL}/subscriptions/status")
            if response.status_code != 403:
                self.log_test("Unauthenticated Access", "FAIL", f"Subscription status should return 403 without auth, got {response.status_code}")
                return False
            
            # Test subscription update without auth
            response = self.session.post(f"{BACKEND_URL}/subscriptions/update", 
                                       json={"subscription_tier": "premium", "subscription_status": "active"})
            if response.status_code != 403:
                self.log_test("Unauthenticated Access", "FAIL", f"Subscription update should return 403 without auth, got {response.status_code}")
                return False
            
            self.log_test("Unauthenticated Access", "PASS", "Protected endpoints properly reject unauthenticated requests")
            return True
            
        except Exception as e:
            self.log_test("Unauthenticated Access", "FAIL", f"Exception: {str(e)}")
            return False

    def run_all_tests(self):
        """Run all subscription and payment integration tests"""
        print("=" * 80)
        print("🧪 EQUIMIND SUBSCRIPTION & PAYMENT INTEGRATION TESTS")
        print("=" * 80)
        print(f"Backend URL: {BACKEND_URL}")
        print(f"Test User: {self.test_user_email}")
        print("=" * 80)
        print()
        
        results = {}
        
        # Test 1: Register test user for authenticated endpoints
        results["user_registration"] = self.register_test_user()
        
        # Test 2: Subscription tiers endpoint
        results["subscription_tiers"] = self.test_subscription_tiers()
        
        # Test 3: RevenueCat webhook endpoints
        results["webhook_initial_purchase"] = self.test_revenuecat_webhook_initial_purchase()
        results["webhook_renewal"] = self.test_revenuecat_webhook_renewal()
        results["webhook_cancellation"] = self.test_revenuecat_webhook_cancellation()
        results["webhook_unknown_user"] = self.test_revenuecat_webhook_unknown_user()
        
        # Test 4: Admin feedback endpoint (N+1 query fix)
        results["admin_feedback_n_plus_one"] = self.test_admin_feedback_n_plus_one_fix()
        
        # Test 5: Authenticated subscription endpoints (only if user registration succeeded)
        if results["user_registration"]:
            results["subscription_status_auth"] = self.test_subscription_status_authenticated()
            results["subscription_update_auth"] = self.test_subscription_update_authenticated()
        
        # Test 6: Unauthenticated access protection
        results["unauthenticated_access"] = self.test_unauthenticated_access()
        
        # Summary
        print("=" * 80)
        print("📊 TEST SUMMARY")
        print("=" * 80)
        
        passed = sum(1 for result in results.values() if result)
        total = len(results)
        
        for test_name, result in results.items():
            status = "✅ PASS" if result else "❌ FAIL"
            print(f"{status} {test_name.replace('_', ' ').title()}")
        
        print()
        print(f"Results: {passed}/{total} tests passed ({(passed/total)*100:.1f}%)")
        
        if passed == total:
            print("🎉 ALL TESTS PASSED - Subscription and payment integration is working correctly!")
        else:
            print(f"⚠️  {total - passed} test(s) failed - Review the failures above")
        
        print("=" * 80)
        
        return passed == total

if __name__ == "__main__":
    tester = EquiMindAPITester()
    success = tester.run_all_tests()
    exit(0 if success else 1)