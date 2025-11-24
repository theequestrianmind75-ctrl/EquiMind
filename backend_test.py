#!/usr/bin/env python3
"""
Backend API Testing for EquiMind Strategy Detail Navigation Fix
Testing the fix for 404 errors when clicking on suggested tool boxes in post-ride analysis
"""

import requests
import json
import sys
import random
from typing import Dict, List, Optional

# Get backend URL from frontend .env
BACKEND_URL = "https://mindful-equine.preview.emergentagent.com/api"

class EquiMindTester:
    def __init__(self):
        self.base_url = BACKEND_URL
        self.token = None
        self.headers = {}
        self.test_results = []
        
    def log_test(self, test_name: str, success: bool, message: str, details: Optional[Dict] = None):
        """Log test results"""
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"{status} {test_name}: {message}")
        
        self.test_results.append({
            "test": test_name,
            "success": success,
            "message": message,
            "details": details or {}
        })
        
        if not success:
            print(f"   Details: {details}")
    
    def authenticate(self) -> bool:
        """Authenticate and get JWT token"""
        print("\n🔐 Testing Authentication...")
        
        # Try to login with existing test user
        login_data = {
            "email": "sarah.rider@example.com",
            "password": "securepass123"
        }
        
        try:
            response = requests.post(f"{self.base_url}/auth/login", json=login_data)
            
            if response.status_code == 401:
                # User doesn't exist, create one
                print("   Creating test user...")
                register_data = {
                    "email": "sarah.rider@example.com",
                    "password": "securepass123",
                    "name": "Sarah Rider"
                }
                
                response = requests.post(f"{self.base_url}/auth/register", json=register_data)
                
            if response.status_code in [200, 201]:
                data = response.json()
                self.token = data["access_token"]
                self.headers = {"Authorization": f"Bearer {self.token}"}
                self.log_test("Authentication", True, f"Successfully authenticated as {data['user']['name']}")
                return True
            else:
                self.log_test("Authentication", False, f"Failed with status {response.status_code}", 
                            {"response": response.text})
                return False
                
        except Exception as e:
            self.log_test("Authentication", False, f"Exception: {str(e)}")
            return False
    
    def test_list_mental_strategies(self) -> List[Dict]:
        """Test 1: List all mental strategies and verify count"""
        print("\n📋 Testing Mental Strategies List...")
        
        try:
            response = requests.get(f"{self.base_url}/mental-strategies", headers=self.headers)
            
            if response.status_code == 200:
                strategies = response.json()
                count = len(strategies)
                
                # Verify at least 136 tools (as mentioned in review request)
                if count >= 136:
                    self.log_test("List Mental Strategies - Count", True, 
                                f"Found {count} strategies (≥136 expected)")
                else:
                    self.log_test("List Mental Strategies - Count", False, 
                                f"Found only {count} strategies, expected ≥136")
                
                # Verify each strategy has required fields
                sample_strategy = strategies[0] if strategies else None
                if sample_strategy:
                    required_fields = ['id', 'name', 'category', 'instructions']
                    missing_fields = [field for field in required_fields if field not in sample_strategy]
                    
                    if not missing_fields:
                        self.log_test("List Mental Strategies - Structure", True, 
                                    "All required fields present (id, name, category, instructions)")
                    else:
                        self.log_test("List Mental Strategies - Structure", False, 
                                    f"Missing fields: {missing_fields}")
                
                return strategies
            else:
                self.log_test("List Mental Strategies", False, 
                            f"Failed with status {response.status_code}", 
                            {"response": response.text})
                return []
                
        except Exception as e:
            self.log_test("List Mental Strategies", False, f"Exception: {str(e)}")
            return []
    
    def test_get_strategy_by_id(self, strategies: List[Dict]) -> List[str]:
        """Test 2: Get strategy by ID (the fixed endpoint)"""
        print("\n🎯 Testing Strategy Detail Retrieval (Fixed Endpoint)...")
        
        if not strategies:
            self.log_test("Get Strategy by ID", False, "No strategies available for testing")
            return []
        
        # Pick 3 random strategies for testing
        test_strategies = random.sample(strategies, min(3, len(strategies)))
        successful_ids = []
        
        for i, strategy in enumerate(test_strategies, 1):
            strategy_id = strategy.get('id')
            strategy_name = strategy.get('name', 'Unknown')
            
            try:
                response = requests.get(f"{self.base_url}/mental-strategies/{strategy_id}", 
                                      headers=self.headers)
                
                if response.status_code == 200:
                    retrieved_strategy = response.json()
                    
                    # Verify response structure
                    required_fields = ['id', 'name', 'category', 'instructions']
                    missing_fields = [field for field in required_fields 
                                    if field not in retrieved_strategy]
                    
                    if not missing_fields:
                        self.log_test(f"Get Strategy by ID #{i}", True, 
                                    f"Successfully retrieved '{strategy_name}' with all required fields")
                        successful_ids.append(strategy_id)
                    else:
                        self.log_test(f"Get Strategy by ID #{i}", False, 
                                    f"Retrieved '{strategy_name}' but missing fields: {missing_fields}")
                        
                elif response.status_code == 404:
                    self.log_test(f"Get Strategy by ID #{i}", False, 
                                f"404 Error for '{strategy_name}' (ID: {strategy_id}) - This is the bug we're testing!")
                else:
                    self.log_test(f"Get Strategy by ID #{i}", False, 
                                f"Failed with status {response.status_code} for '{strategy_name}'",
                                {"response": response.text})
                    
            except Exception as e:
                self.log_test(f"Get Strategy by ID #{i}", False, 
                            f"Exception for '{strategy_name}': {str(e)}")
        
        return successful_ids
    
    def test_recommendations_endpoint(self) -> List[Dict]:
        """Test 3: Verify recommendations endpoint"""
        print("\n💡 Testing Recommendations Endpoint...")
        
        try:
            response = requests.get(f"{self.base_url}/recommendations", headers=self.headers)
            
            if response.status_code == 200:
                recommendations = response.json()
                
                if recommendations:
                    # Check if recommendations have suggested_tool_names
                    has_tool_names = any('suggested_tool_names' in rec for rec in recommendations)
                    
                    if has_tool_names:
                        self.log_test("Recommendations Endpoint", True, 
                                    f"Found {len(recommendations)} recommendations with suggested tool names")
                    else:
                        self.log_test("Recommendations Endpoint", True, 
                                    f"Found {len(recommendations)} recommendations (no suggested_tool_names field)")
                else:
                    self.log_test("Recommendations Endpoint", True, 
                                "Endpoint working but no recommendations found")
                
                return recommendations
            else:
                self.log_test("Recommendations Endpoint", False, 
                            f"Failed with status {response.status_code}",
                            {"response": response.text})
                return []
                
        except Exception as e:
            self.log_test("Recommendations Endpoint", False, f"Exception: {str(e)}")
            return []
    
    def test_cross_verify_tool_lookup(self, strategies: List[Dict], recommendations: List[Dict]):
        """Test 4: Cross-verify tool name to ID lookup"""
        print("\n🔍 Testing Cross-Verification of Tool Name to ID Lookup...")
        
        if not strategies or not recommendations:
            self.log_test("Cross-Verify Tool Lookup", False, 
                        "Missing strategies or recommendations for cross-verification")
            return
        
        # Find recommendations with suggested tool names
        recs_with_tools = [rec for rec in recommendations if rec.get('suggested_tool_names')]
        
        if not recs_with_tools:
            self.log_test("Cross-Verify Tool Lookup", False, 
                        "No recommendations with suggested_tool_names found")
            return
        
        # Get a tool name from recommendations
        sample_rec = recs_with_tools[0]
        suggested_tools = sample_rec.get('suggested_tool_names', [])
        
        if not suggested_tools:
            self.log_test("Cross-Verify Tool Lookup", False, 
                        "No tool names in suggested_tool_names")
            return
        
        tool_name = suggested_tools[0]
        
        # Find this tool in the strategies list
        matching_strategy = None
        for strategy in strategies:
            if strategy.get('name', '').lower() == tool_name.lower():
                matching_strategy = strategy
                break
        
        if not matching_strategy:
            self.log_test("Cross-Verify Tool Lookup", False, 
                        f"Tool '{tool_name}' from recommendations not found in strategies list")
            return
        
        # Test if we can fetch this strategy by ID
        strategy_id = matching_strategy.get('id')
        try:
            response = requests.get(f"{self.base_url}/mental-strategies/{strategy_id}", 
                                  headers=self.headers)
            
            if response.status_code == 200:
                self.log_test("Cross-Verify Tool Lookup", True, 
                            f"Successfully verified tool '{tool_name}' can be fetched by ID")
            else:
                self.log_test("Cross-Verify Tool Lookup", False, 
                            f"Failed to fetch tool '{tool_name}' by ID (status: {response.status_code})")
                
        except Exception as e:
            self.log_test("Cross-Verify Tool Lookup", False, 
                        f"Exception fetching tool '{tool_name}': {str(e)}")
    
    def test_navigation_flow(self, strategies: List[Dict]):
        """Test the complete navigation flow: list → get ID → fetch detail"""
        print("\n🚀 Testing Complete Navigation Flow...")
        
        if not strategies:
            self.log_test("Navigation Flow", False, "No strategies available for navigation test")
            return
        
        # Pick a random strategy
        test_strategy = random.choice(strategies)
        strategy_name = test_strategy.get('name', 'Unknown')
        strategy_id = test_strategy.get('id')
        
        print(f"   Testing navigation for: '{strategy_name}' (ID: {strategy_id})")
        
        try:
            # Step 1: List strategies (already done)
            # Step 2: Get strategy detail by ID
            response = requests.get(f"{self.base_url}/mental-strategies/{strategy_id}", 
                                  headers=self.headers)
            
            if response.status_code == 200:
                detail = response.json()
                
                # Verify the detail matches the list item
                if (detail.get('id') == strategy_id and 
                    detail.get('name') == strategy_name):
                    self.log_test("Navigation Flow", True, 
                                f"Complete navigation flow working for '{strategy_name}'")
                else:
                    self.log_test("Navigation Flow", False, 
                                f"Data mismatch between list and detail for '{strategy_name}'")
            else:
                self.log_test("Navigation Flow", False, 
                            f"Navigation failed for '{strategy_name}' - status {response.status_code}")
                
        except Exception as e:
            self.log_test("Navigation Flow", False, 
                        f"Exception in navigation flow: {str(e)}")
    
    def run_all_tests(self):
        """Run all tests for the strategy detail navigation fix"""
        print("🧪 Starting Backend API Tests for Strategy Detail Navigation Fix")
        print("=" * 70)
        
        # Step 1: Authenticate
        if not self.authenticate():
            print("\n❌ Authentication failed. Cannot proceed with tests.")
            return False
        
        # Step 2: Test list mental strategies
        strategies = self.test_list_mental_strategies()
        
        # Step 3: Test get strategy by ID (the main fix)
        successful_ids = self.test_get_strategy_by_id(strategies)
        
        # Step 4: Test recommendations endpoint
        recommendations = self.test_recommendations_endpoint()
        
        # Step 5: Cross-verify tool lookup
        self.test_cross_verify_tool_lookup(strategies, recommendations)
        
        # Step 6: Test complete navigation flow
        self.test_navigation_flow(strategies)
        
        # Summary
        self.print_summary()
        
        return all(result["success"] for result in self.test_results)
    
    def print_summary(self):
        """Print test summary"""
        print("\n" + "=" * 70)
        print("📊 TEST SUMMARY")
        print("=" * 70)
        
        passed = sum(1 for r in self.test_results if r["success"])
        total = len(self.test_results)
        
        print(f"Total Tests: {total}")
        print(f"Passed: {passed}")
        print(f"Failed: {total - passed}")
        
        if total - passed > 0:
            print("\n❌ FAILED TESTS:")
            for result in self.test_results:
                if not result["success"]:
                    print(f"   • {result['test']}: {result['message']}")
        
        print(f"\n{'✅ ALL TESTS PASSED' if passed == total else '❌ SOME TESTS FAILED'}")
        
        # Specific analysis for the bug fix
        strategy_tests = [r for r in self.test_results if "Get Strategy by ID" in r["test"]]
        if strategy_tests:
            failed_strategy_tests = [r for r in strategy_tests if not r["success"]]
            if failed_strategy_tests:
                print(f"\n⚠️  CRITICAL: {len(failed_strategy_tests)} strategy detail retrievals failed!")
                print("   This indicates the 404 bug may still exist.")
            else:
                print(f"\n✅ SUCCESS: All {len(strategy_tests)} strategy detail retrievals passed!")
                print("   The 404 bug fix appears to be working correctly.")

if __name__ == "__main__":
    tester = EquiMindTester()
    success = tester.run_all_tests()
    sys.exit(0 if success else 1)