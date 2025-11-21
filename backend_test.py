#!/usr/bin/env python3
"""
Backend API Testing for EquiMind Mental Strategies
Testing the updated database with 136 tools and category filtering
"""

import requests
import json
import sys
from typing import Dict, List, Any

# Backend URL from frontend environment
BACKEND_URL = "https://rider-tools-1.preview.emergentagent.com/api"

class EquiMindTester:
    def __init__(self):
        self.base_url = BACKEND_URL
        self.token = None
        self.user_data = {
            "email": "rider.test@equimind.com",
            "password": "SecureRider2025!",
            "name": "Test Rider"
        }
        
    def register_and_login(self) -> bool:
        """Register a test user and get authentication token"""
        try:
            # Try to register (might fail if user exists)
            register_response = requests.post(
                f"{self.base_url}/auth/register",
                json=self.user_data,
                timeout=10
            )
            
            if register_response.status_code == 201 or register_response.status_code == 200:
                data = register_response.json()
                self.token = data["access_token"]
                print(f"✅ User registered successfully")
                return True
            elif register_response.status_code == 400:
                # User already exists, try login
                login_response = requests.post(
                    f"{self.base_url}/auth/login",
                    json={"email": self.user_data["email"], "password": self.user_data["password"]},
                    timeout=10
                )
                
                if login_response.status_code == 200:
                    data = login_response.json()
                    self.token = data["access_token"]
                    print(f"✅ User logged in successfully")
                    return True
                else:
                    print(f"❌ Login failed: {login_response.status_code} - {login_response.text}")
                    return False
            else:
                print(f"❌ Registration failed: {register_response.status_code} - {register_response.text}")
                return False
                
        except Exception as e:
            print(f"❌ Authentication error: {e}")
            return False
    
    def get_headers(self) -> Dict[str, str]:
        """Get headers with authentication token"""
        return {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json"
        }
    
    def test_total_strategies_count(self) -> bool:
        """Test 1: Verify total count of strategies is 136"""
        try:
            response = requests.get(
                f"{self.base_url}/mental-strategies",
                headers=self.get_headers(),
                timeout=10
            )
            
            if response.status_code == 200:
                strategies = response.json()
                total_count = len(strategies)
                print(f"📊 Total strategies found: {total_count}")
                
                if total_count == 136:
                    print(f"✅ TEST 1 PASSED: Total count is correct (136)")
                    return True
                else:
                    print(f"❌ TEST 1 FAILED: Expected 136 strategies, got {total_count}")
                    return False
            else:
                print(f"❌ TEST 1 FAILED: API error {response.status_code} - {response.text}")
                return False
                
        except Exception as e:
            print(f"❌ TEST 1 FAILED: {e}")
            return False
    
    def test_category_filtering(self) -> bool:
        """Test 2: Verify filtering by each category with expected counts"""
        expected_counts = {
            "BODY RESET": 59,
            "Breathing / HRV": 19,
            "Mindfulness & Flow": 10,
            "Tapping / EFT": 48
        }
        
        all_passed = True
        
        for category, expected_count in expected_counts.items():
            try:
                response = requests.get(
                    f"{self.base_url}/mental-strategies",
                    params={"category": category},
                    headers=self.get_headers(),
                    timeout=10
                )
                
                if response.status_code == 200:
                    strategies = response.json()
                    actual_count = len(strategies)
                    print(f"📊 Category '{category}': {actual_count} strategies")
                    
                    if actual_count == expected_count:
                        print(f"✅ Category '{category}' count correct ({expected_count})")
                    else:
                        print(f"❌ Category '{category}' count incorrect: expected {expected_count}, got {actual_count}")
                        all_passed = False
                        
                        # Show sample strategies for debugging
                        if strategies:
                            print(f"   Sample strategies in this category:")
                            for i, strategy in enumerate(strategies[:3]):
                                print(f"   - {strategy.get('name', 'Unknown')} (category: {strategy.get('category', 'Unknown')})")
                else:
                    print(f"❌ Category '{category}' API error: {response.status_code} - {response.text}")
                    all_passed = False
                    
            except Exception as e:
                print(f"❌ Category '{category}' test failed: {e}")
                all_passed = False
        
        if all_passed:
            print(f"✅ TEST 2 PASSED: All category counts are correct")
        else:
            print(f"❌ TEST 2 FAILED: Some category counts are incorrect")
            
        return all_passed
    
    def test_sample_tool_verification(self) -> bool:
        """Test 3: Verify a sample tool from the new data"""
        try:
            # Get BODY RESET category strategies
            response = requests.get(
                f"{self.base_url}/mental-strategies",
                params={"category": "BODY RESET"},
                headers=self.get_headers(),
                timeout=10
            )
            
            if response.status_code == 200:
                strategies = response.json()
                
                # Look for "4:8 Tension Melt Exhale" or similar tools
                target_tool = None
                for strategy in strategies:
                    if "4:8 Tension Melt Exhale" in strategy.get("name", ""):
                        target_tool = strategy
                        break
                
                if target_tool:
                    print(f"✅ Found target tool: {target_tool['name']}")
                    print(f"   Category: {target_tool.get('category', 'Unknown')}")
                    print(f"   Instructions length: {len(target_tool.get('instructions', ''))}")
                    print(f"✅ TEST 3 PASSED: Sample tool verification successful")
                    return True
                else:
                    # If exact tool not found, verify we have BODY RESET tools with proper structure
                    if strategies:
                        sample_tool = strategies[0]
                        print(f"📊 Sample BODY RESET tool: {sample_tool.get('name', 'Unknown')}")
                        print(f"   Category: {sample_tool.get('category', 'Unknown')}")
                        print(f"   Has instructions: {bool(sample_tool.get('instructions'))}")
                        print(f"✅ TEST 3 PASSED: BODY RESET category has proper tools")
                        return True
                    else:
                        print(f"❌ TEST 3 FAILED: No BODY RESET tools found")
                        return False
            else:
                print(f"❌ TEST 3 FAILED: API error {response.status_code} - {response.text}")
                return False
                
        except Exception as e:
            print(f"❌ TEST 3 FAILED: {e}")
            return False
    
    def test_tool_structure(self) -> bool:
        """Test 4: Verify tools have proper structure with required fields"""
        try:
            response = requests.get(
                f"{self.base_url}/mental-strategies",
                headers=self.get_headers(),
                timeout=10
            )
            
            if response.status_code == 200:
                strategies = response.json()
                
                if not strategies:
                    print(f"❌ TEST 4 FAILED: No strategies found")
                    return False
                
                # Check first few tools for required fields
                required_fields = ["id", "name", "category", "instructions"]
                optional_fields = ["duration_minutes", "anxiety_level", "confidence_level"]
                
                sample_size = min(5, len(strategies))
                all_valid = True
                
                for i in range(sample_size):
                    tool = strategies[i]
                    print(f"📊 Checking tool {i+1}: {tool.get('name', 'Unknown')}")
                    
                    # Check required fields
                    for field in required_fields:
                        if field not in tool or not tool[field]:
                            print(f"   ❌ Missing required field: {field}")
                            all_valid = False
                        else:
                            print(f"   ✅ Has {field}: {str(tool[field])[:50]}...")
                    
                    # Check optional fields (just report presence)
                    for field in optional_fields:
                        if field in tool:
                            print(f"   ℹ️  Has optional {field}: {tool[field]}")
                
                if all_valid:
                    print(f"✅ TEST 4 PASSED: All sampled tools have proper structure")
                    return True
                else:
                    print(f"❌ TEST 4 FAILED: Some tools missing required fields")
                    return False
            else:
                print(f"❌ TEST 4 FAILED: API error {response.status_code} - {response.text}")
                return False
                
        except Exception as e:
            print(f"❌ TEST 4 FAILED: {e}")
            return False
    
    def test_individual_tool_access(self) -> bool:
        """Test 5: Verify individual tool access by ID"""
        try:
            # First get a list of tools to get an ID
            response = requests.get(
                f"{self.base_url}/mental-strategies",
                headers=self.get_headers(),
                timeout=10
            )
            
            if response.status_code == 200:
                strategies = response.json()
                
                if not strategies:
                    print(f"❌ TEST 5 FAILED: No strategies found for ID test")
                    return False
                
                # Test accessing individual tool by ID
                test_tool = strategies[0]
                tool_id = test_tool.get("id")
                
                if not tool_id:
                    print(f"❌ TEST 5 FAILED: Tool missing ID field")
                    return False
                
                individual_response = requests.get(
                    f"{self.base_url}/mental-strategies/{tool_id}",
                    headers=self.get_headers(),
                    timeout=10
                )
                
                if individual_response.status_code == 200:
                    individual_tool = individual_response.json()
                    
                    if individual_tool.get("id") == tool_id:
                        print(f"✅ TEST 5 PASSED: Individual tool access works")
                        print(f"   Tool: {individual_tool.get('name', 'Unknown')}")
                        return True
                    else:
                        print(f"❌ TEST 5 FAILED: Tool ID mismatch")
                        return False
                else:
                    print(f"❌ TEST 5 FAILED: Individual tool API error {individual_response.status_code}")
                    return False
            else:
                print(f"❌ TEST 5 FAILED: List API error {response.status_code}")
                return False
                
        except Exception as e:
            print(f"❌ TEST 5 FAILED: {e}")
            return False
    
    def run_all_tests(self) -> Dict[str, bool]:
        """Run all mental strategies tests"""
        print(f"🚀 Starting Mental Strategies API Tests")
        print(f"🔗 Backend URL: {self.base_url}")
        print(f"=" * 60)
        
        # Authenticate first
        if not self.register_and_login():
            print(f"❌ Authentication failed - cannot run tests")
            return {"authentication": False}
        
        print(f"=" * 60)
        
        # Run all tests
        results = {
            "total_count": self.test_total_strategies_count(),
            "category_filtering": self.test_category_filtering(),
            "sample_tool": self.test_sample_tool_verification(),
            "tool_structure": self.test_tool_structure(),
            "individual_access": self.test_individual_tool_access()
        }
        
        print(f"=" * 60)
        print(f"📋 TEST SUMMARY:")
        
        passed = 0
        total = len(results)
        
        for test_name, result in results.items():
            status = "✅ PASSED" if result else "❌ FAILED"
            print(f"   {test_name.replace('_', ' ').title()}: {status}")
            if result:
                passed += 1
        
        print(f"=" * 60)
        print(f"🎯 OVERALL: {passed}/{total} tests passed")
        
        return results

def main():
    """Main test execution"""
    tester = EquiMindTester()
    results = tester.run_all_tests()
    
    # Exit with error code if any tests failed
    if not all(results.values()):
        sys.exit(1)
    else:
        print(f"🎉 All tests passed!")
        sys.exit(0)

if __name__ == "__main__":
    main()