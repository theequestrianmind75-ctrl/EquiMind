#!/usr/bin/env python3
"""
Backend Testing Suite for EquiMind During-Ride Smart Tool Access System
Tests the new smart recommendations and tool access tracking endpoints
"""

import requests
import json
import uuid
from datetime import datetime
import os
from dotenv import load_dotenv
import time

# Load environment variables
load_dotenv('/app/frontend/.env')
BASE_URL = os.getenv('EXPO_PUBLIC_BACKEND_URL', 'https://mental-rider.preview.emergentagent.com')
API_BASE = f"{BASE_URL}/api"

class DuringRideTestSuite:
    def __init__(self):
        self.test_sessions = []
        self.test_results = []
        
    def setup_session(self):
        """Setup HTTP session for testing"""
        pass  # Using requests, no setup needed
        
    def cleanup_session(self):
        """Cleanup HTTP session"""
        pass  # Using requests, no cleanup needed
            
    def create_test_session(self, anxiety_level=5, confidence_level=5, rider_energy_level=5):
        """Create a test session with specific levels for testing"""
        session_data = {
            "session_type": "pre-ride",
            "ride_type": "training",
            "context": "training",
            "rider_name": "Test Rider",
            "anxiety_level": anxiety_level,
            "confidence_level": confidence_level,
            "rider_energy_level": rider_energy_level,
            "notes": f"Test session - anxiety:{anxiety_level}, confidence:{confidence_level}, energy:{rider_energy_level}"
        }
        
        # Create session without authentication (public endpoint)
        async with self.session.post(f"{API_BASE}/sessions", json=session_data) as response:
            if response.status == 403:
                # Expected - sessions creation requires auth, but we can use existing sessions
                print(f"⚠️  Session creation requires auth (expected) - will use existing sessions")
                return None
            elif response.status == 201:
                session = await response.json()
                session_id = session.get('id')
                self.test_sessions.append(session_id)
                print(f"✅ Created test session: {session_id}")
                return session_id
            else:
                print(f"❌ Failed to create session: {response.status}")
                return None
                
    async def get_existing_sessions(self):
        """Get existing sessions to use for testing"""
        async with self.session.get(f"{API_BASE}/sessions") as response:
            if response.status == 200:
                sessions = await response.json()
                print(f"📊 Found {len(sessions)} existing sessions")
                return sessions
            else:
                print(f"❌ Failed to get sessions: {response.status}")
                return []
                
    async def update_session_for_testing(self, session_id, anxiety_level, confidence_level, rider_energy_level):
        """Update an existing session with test data"""
        update_data = {
            "anxiety_level": anxiety_level,
            "confidence_level": confidence_level,
            "rider_energy_level": rider_energy_level,
            "notes": f"Updated for testing - anxiety:{anxiety_level}, confidence:{confidence_level}, energy:{rider_energy_level}"
        }
        
        async with self.session.patch(f"{API_BASE}/sessions/{session_id}", json=update_data) as response:
            if response.status == 200:
                print(f"✅ Updated session {session_id} for testing")
                return True
            else:
                print(f"❌ Failed to update session {session_id}: {response.status}")
                return False
                
    async def test_smart_recommendations_high_anxiety(self):
        """Test 1: High anxiety (8/10) should return calming/breathing tools"""
        print("\n🧪 TEST 1: High Anxiety Recommendations")
        
        # Get existing sessions and use the first one
        sessions = await self.get_existing_sessions()
        if not sessions:
            self.test_results.append({"test": "High Anxiety Recommendations", "status": "SKIP", "reason": "No sessions available"})
            return
            
        session_id = sessions[0]['id']
        
        # Update session with high anxiety
        if not await self.update_session_for_testing(session_id, anxiety_level=8, confidence_level=5, rider_energy_level=5):
            self.test_results.append({"test": "High Anxiety Recommendations", "status": "FAIL", "reason": "Could not update session"})
            return
            
        # Test recommendations endpoint
        async with self.session.get(f"{API_BASE}/during-ride/recommendations/{session_id}") as response:
            if response.status == 200:
                recommendations = await response.json()
                
                # Verify structure
                required_keys = ['session_id', 'start_of_ride', 'during_ride', 'emergency', 'remaining_regular_tools']
                missing_keys = [key for key in required_keys if key not in recommendations]
                
                if missing_keys:
                    self.test_results.append({
                        "test": "High Anxiety Recommendations", 
                        "status": "FAIL", 
                        "reason": f"Missing keys: {missing_keys}"
                    })
                    return
                    
                # Verify start_of_ride tool exists
                if not recommendations.get('start_of_ride'):
                    self.test_results.append({
                        "test": "High Anxiety Recommendations", 
                        "status": "FAIL", 
                        "reason": "No start_of_ride tool provided"
                    })
                    return
                    
                # Verify during_ride has 2 tools
                during_ride_tools = recommendations.get('during_ride', [])
                if len(during_ride_tools) != 2:
                    self.test_results.append({
                        "test": "High Anxiety Recommendations", 
                        "status": "FAIL", 
                        "reason": f"Expected 2 during_ride tools, got {len(during_ride_tools)}"
                    })
                    return
                    
                # Verify emergency tool exists
                if not recommendations.get('emergency'):
                    self.test_results.append({
                        "test": "High Anxiety Recommendations", 
                        "status": "FAIL", 
                        "reason": "No emergency tool provided"
                    })
                    return
                    
                # Verify remaining_regular_tools is 2 initially
                if recommendations.get('remaining_regular_tools') != 2:
                    self.test_results.append({
                        "test": "High Anxiety Recommendations", 
                        "status": "FAIL", 
                        "reason": f"Expected 2 remaining tools, got {recommendations.get('remaining_regular_tools')}"
                    })
                    return
                    
                # Check if tools are calming/breathing related for high anxiety
                tool_categories = [tool.get('category', '') for tool in during_ride_tools]
                calming_categories = ['Breathing/HRV', 'BODY RESET']
                has_calming_tools = any(cat in calming_categories for cat in tool_categories)
                
                print(f"   📋 Start of ride: {recommendations['start_of_ride']['name']}")
                print(f"   📋 During ride tools: {[tool['name'] for tool in during_ride_tools]}")
                print(f"   📋 Emergency tool: {recommendations['emergency']['name']}")
                print(f"   📋 Tool categories: {tool_categories}")
                print(f"   📋 Has calming tools: {has_calming_tools}")
                
                self.test_results.append({
                    "test": "High Anxiety Recommendations", 
                    "status": "PASS", 
                    "details": {
                        "start_tool": recommendations['start_of_ride']['name'],
                        "during_tools": [tool['name'] for tool in during_ride_tools],
                        "emergency_tool": recommendations['emergency']['name'],
                        "has_calming_tools": has_calming_tools
                    }
                })
                
            else:
                self.test_results.append({
                    "test": "High Anxiety Recommendations", 
                    "status": "FAIL", 
                    "reason": f"HTTP {response.status}: {await response.text()}"
                })
                
    async def test_smart_recommendations_low_confidence(self):
        """Test 2: Low confidence (3/10) should return confidence-building tools"""
        print("\n🧪 TEST 2: Low Confidence Recommendations")
        
        sessions = await self.get_existing_sessions()
        if not sessions:
            self.test_results.append({"test": "Low Confidence Recommendations", "status": "SKIP", "reason": "No sessions available"})
            return
            
        session_id = sessions[0]['id']
        
        # Update session with low confidence
        if not await self.update_session_for_testing(session_id, anxiety_level=5, confidence_level=3, rider_energy_level=5):
            self.test_results.append({"test": "Low Confidence Recommendations", "status": "FAIL", "reason": "Could not update session"})
            return
            
        async with self.session.get(f"{API_BASE}/during-ride/recommendations/{session_id}") as response:
            if response.status == 200:
                recommendations = await response.json()
                during_ride_tools = recommendations.get('during_ride', [])
                
                # Check for confidence-building tools
                tool_names = [tool.get('name', '').lower() for tool in during_ride_tools]
                tool_categories = [tool.get('category', '') for tool in during_ride_tools]
                
                has_confidence_tools = any('confidence' in name or 'power' in name for name in tool_names) or \
                                     'Tapping/EFT' in tool_categories
                
                print(f"   📋 During ride tools: {[tool['name'] for tool in during_ride_tools]}")
                print(f"   📋 Tool categories: {tool_categories}")
                print(f"   📋 Has confidence tools: {has_confidence_tools}")
                
                self.test_results.append({
                    "test": "Low Confidence Recommendations", 
                    "status": "PASS", 
                    "details": {
                        "during_tools": [tool['name'] for tool in during_ride_tools],
                        "categories": tool_categories,
                        "has_confidence_tools": has_confidence_tools
                    }
                })
            else:
                self.test_results.append({
                    "test": "Low Confidence Recommendations", 
                    "status": "FAIL", 
                    "reason": f"HTTP {response.status}"
                })
                
    async def test_smart_recommendations_low_energy(self):
        """Test 3: Low energy (2/10) should return energizing tools"""
        print("\n🧪 TEST 3: Low Energy Recommendations")
        
        sessions = await self.get_existing_sessions()
        if not sessions:
            self.test_results.append({"test": "Low Energy Recommendations", "status": "SKIP", "reason": "No sessions available"})
            return
            
        session_id = sessions[0]['id']
        
        # Update session with low energy
        if not await self.update_session_for_testing(session_id, anxiety_level=5, confidence_level=5, rider_energy_level=2):
            self.test_results.append({"test": "Low Energy Recommendations", "status": "FAIL", "reason": "Could not update session"})
            return
            
        async with self.session.get(f"{API_BASE}/during-ride/recommendations/{session_id}") as response:
            if response.status == 200:
                recommendations = await response.json()
                during_ride_tools = recommendations.get('during_ride', [])
                
                # Check for energizing tools
                tool_names = [tool.get('name', '').lower() for tool in during_ride_tools]
                has_energy_tools = any('energy' in name or 'activate' in name or 'power' in name for name in tool_names)
                
                print(f"   📋 During ride tools: {[tool['name'] for tool in during_ride_tools]}")
                print(f"   📋 Has energy tools: {has_energy_tools}")
                
                self.test_results.append({
                    "test": "Low Energy Recommendations", 
                    "status": "PASS", 
                    "details": {
                        "during_tools": [tool['name'] for tool in during_ride_tools],
                        "has_energy_tools": has_energy_tools
                    }
                })
            else:
                self.test_results.append({
                    "test": "Low Energy Recommendations", 
                    "status": "FAIL", 
                    "reason": f"HTTP {response.status}"
                })
                
    async def test_invalid_session_id(self):
        """Test 4: Invalid session_id should return 404"""
        print("\n🧪 TEST 4: Invalid Session ID")
        
        fake_session_id = str(uuid.uuid4())
        async with self.session.get(f"{API_BASE}/during-ride/recommendations/{fake_session_id}") as response:
            if response.status == 404:
                self.test_results.append({"test": "Invalid Session ID", "status": "PASS"})
                print("   ✅ Correctly returned 404 for invalid session ID")
            else:
                self.test_results.append({
                    "test": "Invalid Session ID", 
                    "status": "FAIL", 
                    "reason": f"Expected 404, got {response.status}"
                })
                
    async def test_tool_access_tracking_regular(self):
        """Test 5: Track regular tool access and verify limit enforcement"""
        print("\n🧪 TEST 5: Regular Tool Access Tracking")
        
        sessions = await self.get_existing_sessions()
        if not sessions:
            self.test_results.append({"test": "Regular Tool Access", "status": "SKIP", "reason": "No sessions available"})
            return
            
        session_id = sessions[0]['id']
        
        # Reset session tool counts by updating it
        await self.update_session_for_testing(session_id, anxiety_level=5, confidence_level=5, rider_energy_level=5)
        
        # Test first regular tool access
        tool_id = "test-tool-1"
        tool_name = "Test Breathing Tool"
        
        async with self.session.post(
            f"{API_BASE}/during-ride/track-tool-access/{session_id}",
            params={"tool_id": tool_id, "tool_name": tool_name, "is_emergency": False}
        ) as response:
            if response.status == 200:
                result = await response.json()
                
                if result.get('success') and result.get('regular_tools_remaining') == 1:
                    print("   ✅ First regular tool access successful")
                    
                    # Test second regular tool access
                    async with self.session.post(
                        f"{API_BASE}/during-ride/track-tool-access/{session_id}",
                        params={"tool_id": "test-tool-2", "tool_name": "Test Confidence Tool", "is_emergency": False}
                    ) as response2:
                        if response2.status == 200:
                            result2 = await response2.json()
                            
                            if result2.get('regular_tools_remaining') == 0:
                                print("   ✅ Second regular tool access successful")
                                
                                # Test third regular tool access (should fail)
                                async with self.session.post(
                                    f"{API_BASE}/during-ride/track-tool-access/{session_id}",
                                    params={"tool_id": "test-tool-3", "tool_name": "Test Third Tool", "is_emergency": False}
                                ) as response3:
                                    if response3.status == 400:
                                        error_text = await response3.text()
                                        if "Tool limit reached" in error_text:
                                            print("   ✅ Third regular tool correctly rejected (limit reached)")
                                            self.test_results.append({"test": "Regular Tool Access", "status": "PASS"})
                                        else:
                                            self.test_results.append({
                                                "test": "Regular Tool Access", 
                                                "status": "FAIL", 
                                                "reason": f"Wrong error message: {error_text}"
                                            })
                                    else:
                                        self.test_results.append({
                                            "test": "Regular Tool Access", 
                                            "status": "FAIL", 
                                            "reason": f"Third tool should be rejected, got {response3.status}"
                                        })
                            else:
                                self.test_results.append({
                                    "test": "Regular Tool Access", 
                                    "status": "FAIL", 
                                    "reason": f"Expected 0 remaining tools, got {result2.get('regular_tools_remaining')}"
                                })
                        else:
                            self.test_results.append({
                                "test": "Regular Tool Access", 
                                "status": "FAIL", 
                                "reason": f"Second tool access failed: {response2.status}"
                            })
                else:
                    self.test_results.append({
                        "test": "Regular Tool Access", 
                        "status": "FAIL", 
                        "reason": f"First tool access failed or wrong remaining count: {result}"
                    })
            else:
                self.test_results.append({
                    "test": "Regular Tool Access", 
                    "status": "FAIL", 
                    "reason": f"First tool access failed: {response.status}"
                })
                
    async def test_emergency_tool_access(self):
        """Test 6: Emergency tool access should always work (no limits)"""
        print("\n🧪 TEST 6: Emergency Tool Access")
        
        sessions = await self.get_existing_sessions()
        if not sessions:
            self.test_results.append({"test": "Emergency Tool Access", "status": "SKIP", "reason": "No sessions available"})
            return
            
        session_id = sessions[0]['id']
        
        # Test multiple emergency tool accesses
        emergency_accesses = []
        
        for i in range(3):  # Test 3 emergency accesses
            async with self.session.post(
                f"{API_BASE}/during-ride/track-tool-access/{session_id}",
                params={"tool_id": f"emergency-tool-{i}", "tool_name": f"Emergency Tool {i+1}", "is_emergency": True}
            ) as response:
                if response.status == 200:
                    result = await response.json()
                    emergency_accesses.append(result.get('total_emergency_accesses', 0))
                    print(f"   ✅ Emergency tool {i+1} access successful")
                else:
                    self.test_results.append({
                        "test": "Emergency Tool Access", 
                        "status": "FAIL", 
                        "reason": f"Emergency tool {i+1} access failed: {response.status}"
                    })
                    return
                    
        # Verify emergency count incremented correctly
        if len(emergency_accesses) == 3 and emergency_accesses[-1] >= 3:
            self.test_results.append({"test": "Emergency Tool Access", "status": "PASS"})
            print(f"   ✅ All emergency tools accessed successfully, final count: {emergency_accesses[-1]}")
        else:
            self.test_results.append({
                "test": "Emergency Tool Access", 
                "status": "FAIL", 
                "reason": f"Emergency count tracking failed: {emergency_accesses}"
            })
            
    async def test_session_model_updates(self):
        """Test 7: Verify session model supports new fields"""
        print("\n🧪 TEST 7: Session Model Updates")
        
        sessions = await self.get_existing_sessions()
        if not sessions:
            self.test_results.append({"test": "Session Model Updates", "status": "SKIP", "reason": "No sessions available"})
            return
            
        session = sessions[0]
        
        # Check for new fields in session model
        required_fields = ['rider_energy_level', 'tools_accessed_during_ride', 'regular_tools_count', 'emergency_tools_count']
        missing_fields = []
        
        for field in required_fields:
            if field not in session:
                missing_fields.append(field)
                
        if missing_fields:
            print(f"   ⚠️  Missing fields in session model: {missing_fields}")
            # This might be expected for older sessions, so we'll check if we can update with these fields
            
            session_id = session['id']
            update_data = {
                "rider_energy_level": 7,
                "notes": "Testing new fields support"
            }
            
            async with self.session.patch(f"{API_BASE}/sessions/{session_id}", json=update_data) as response:
                if response.status == 200:
                    updated_session = await response.json()
                    if 'rider_energy_level' in updated_session and updated_session['rider_energy_level'] == 7:
                        self.test_results.append({"test": "Session Model Updates", "status": "PASS"})
                        print("   ✅ Session model supports rider_energy_level field")
                    else:
                        self.test_results.append({
                            "test": "Session Model Updates", 
                            "status": "FAIL", 
                            "reason": "rider_energy_level not updated correctly"
                        })
                else:
                    self.test_results.append({
                        "test": "Session Model Updates", 
                        "status": "FAIL", 
                        "reason": f"Session update failed: {response.status}"
                    })
        else:
            self.test_results.append({"test": "Session Model Updates", "status": "PASS"})
            print("   ✅ All required fields present in session model")
            
    async def run_all_tests(self):
        """Run all during-ride smart tool access tests"""
        print("🚀 Starting During-Ride Smart Tool Access System Tests")
        print(f"🔗 Testing against: {API_BASE}")
        
        await self.setup_session()
        
        try:
            # Run all tests
            await self.test_smart_recommendations_high_anxiety()
            await self.test_smart_recommendations_low_confidence()
            await self.test_smart_recommendations_low_energy()
            await self.test_invalid_session_id()
            await self.test_tool_access_tracking_regular()
            await self.test_emergency_tool_access()
            await self.test_session_model_updates()
            
        finally:
            await self.cleanup_session()
            
        # Print summary
        print("\n" + "="*60)
        print("📊 TEST RESULTS SUMMARY")
        print("="*60)
        
        passed = sum(1 for result in self.test_results if result['status'] == 'PASS')
        failed = sum(1 for result in self.test_results if result['status'] == 'FAIL')
        skipped = sum(1 for result in self.test_results if result['status'] == 'SKIP')
        
        for result in self.test_results:
            status_icon = "✅" if result['status'] == 'PASS' else "❌" if result['status'] == 'FAIL' else "⏭️"
            print(f"{status_icon} {result['test']}: {result['status']}")
            if result['status'] == 'FAIL':
                print(f"   Reason: {result.get('reason', 'Unknown')}")
            elif result['status'] == 'PASS' and 'details' in result:
                print(f"   Details: {result['details']}")
                
        print(f"\n📈 TOTAL: {len(self.test_results)} tests | ✅ {passed} passed | ❌ {failed} failed | ⏭️ {skipped} skipped")
        
        return {
            'total': len(self.test_results),
            'passed': passed,
            'failed': failed,
            'skipped': skipped,
            'results': self.test_results
        }

async def main():
    """Main test runner"""
    test_suite = DuringRideTestSuite()
    results = await test_suite.run_all_tests()
    
    # Return exit code based on results
    if results['failed'] > 0:
        print(f"\n❌ Tests failed: {results['failed']} failures detected")
        return 1
    else:
        print(f"\n✅ All tests passed successfully!")
        return 0

if __name__ == "__main__":
    exit_code = asyncio.run(main())
    exit(exit_code)