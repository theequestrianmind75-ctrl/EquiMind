import requests
import sys
import json
from datetime import datetime

class EquiMindAPITester:
    def __init__(self, base_url="https://equihero.preview.emergentagent.com/api"):
        self.base_url = base_url
        self.tests_run = 0
        self.tests_passed = 0
        self.rider_id = None
        self.session_id = None
        self.emotion_id = None
        self.horse_observation_id = None

    def run_test(self, name, method, endpoint, expected_status, data=None, params=None):
        """Run a single API test"""
        url = f"{self.base_url}/{endpoint}" if endpoint else self.base_url
        headers = {'Content-Type': 'application/json'}

        self.tests_run += 1
        print(f"\n🔍 Testing {name}...")
        print(f"   URL: {url}")
        
        try:
            if method == 'GET':
                response = requests.get(url, headers=headers, params=params)
            elif method == 'POST':
                response = requests.post(url, json=data, headers=headers)
            elif method == 'PUT':
                response = requests.put(url, json=data, headers=headers)

            success = response.status_code == expected_status
            if success:
                self.tests_passed += 1
                print(f"✅ Passed - Status: {response.status_code}")
                try:
                    response_data = response.json()
                    print(f"   Response: {json.dumps(response_data, indent=2)[:200]}...")
                    return True, response_data
                except:
                    return True, {}
            else:
                print(f"❌ Failed - Expected {expected_status}, got {response.status_code}")
                try:
                    error_data = response.json()
                    print(f"   Error: {error_data}")
                except:
                    print(f"   Error: {response.text}")
                return False, {}

        except Exception as e:
            print(f"❌ Failed - Error: {str(e)}")
            return False, {}

    def test_root_endpoint(self):
        """Test root API endpoint"""
        success, response = self.run_test(
            "Root API Endpoint",
            "GET",
            "",
            200
        )
        return success

    def test_create_rider_profile(self):
        """Test creating a rider profile"""
        rider_data = {
            "name": "Test Rider",
            "email": "test@example.com",
            "experience_level": "Intermediate",
            "preferred_disciplines": ["show_jumping", "dressage"]
        }
        
        success, response = self.run_test(
            "Create Rider Profile",
            "POST",
            "riders",
            200,
            data=rider_data
        )
        
        if success and 'id' in response:
            self.rider_id = response['id']
            print(f"   Created rider with ID: {self.rider_id}")
        
        return success

    def test_get_rider_profile(self):
        """Test getting a rider profile"""
        if not self.rider_id:
            print("❌ Skipping - No rider ID available")
            return False
            
        success, response = self.run_test(
            "Get Rider Profile",
            "GET",
            f"riders/{self.rider_id}",
            200
        )
        return success

    def test_create_session(self):
        """Test creating a riding session"""
        if not self.rider_id:
            print("❌ Skipping - No rider ID available")
            return False
            
        session_data = {
            "rider_id": self.rider_id,
            "session_type": "pre_ride",
            "ride_type": "show_jumping",
            "planned_duration": 60
        }
        
        success, response = self.run_test(
            "Create Riding Session",
            "POST",
            "sessions",
            200,
            data=session_data
        )
        
        if success and 'id' in response:
            self.session_id = response['id']
            print(f"   Created session with ID: {self.session_id}")
        
        return success

    def test_get_session(self):
        """Test getting a session"""
        if not self.session_id:
            print("❌ Skipping - No session ID available")
            return False
            
        success, response = self.run_test(
            "Get Riding Session",
            "GET",
            f"sessions/{self.session_id}",
            200
        )
        return success

    def test_create_emotion_assessment(self):
        """Test creating an emotion assessment"""
        if not self.rider_id or not self.session_id:
            print("❌ Skipping - No rider or session ID available")
            return False
            
        emotion_data = {
            "rider_id": self.rider_id,
            "session_id": self.session_id,
            "emotion_level": 6.5,
            "anxiety_level": 3.2,
            "confidence_level": 7.8,
            "notes": "Feeling good today"
        }
        
        success, response = self.run_test(
            "Create Emotion Assessment",
            "POST",
            "emotions",
            200,
            data=emotion_data
        )
        
        if success and 'id' in response:
            self.emotion_id = response['id']
            print(f"   Created emotion assessment with ID: {self.emotion_id}")
        
        return success

    def test_create_horse_observation(self):
        """Test creating a horse observation"""
        if not self.rider_id or not self.session_id:
            print("❌ Skipping - No rider or session ID available")
            return False
            
        horse_data = {
            "rider_id": self.rider_id,
            "session_id": self.session_id,
            "horse_name": "Thunder",
            "energy_level": 7,
            "responsiveness": 8,
            "mood_indicators": ["alert", "eager", "focused"],
            "physical_condition": "excellent",
            "notes": "Horse seems ready for training"
        }
        
        success, response = self.run_test(
            "Create Horse Observation",
            "POST",
            "horse-observations",
            200,
            data=horse_data
        )
        
        if success and 'id' in response:
            self.horse_observation_id = response['id']
            print(f"   Created horse observation with ID: {self.horse_observation_id}")
        
        return success

    def test_get_breathing_exercises(self):
        """Test getting breathing exercises"""
        success, response = self.run_test(
            "Get Breathing Exercises",
            "GET",
            "breathing-exercises",
            200
        )
        
        if success and isinstance(response, list) and len(response) > 0:
            print(f"   Found {len(response)} breathing exercises")
            for exercise in response:
                print(f"   - {exercise.get('name', 'Unknown')}")
        
        return success

    def test_get_emergency_techniques(self):
        """Test getting emergency techniques"""
        success, response = self.run_test(
            "Get Emergency Techniques",
            "GET",
            "emergency-techniques",
            200
        )
        
        if success and isinstance(response, dict):
            print(f"   Found emergency techniques:")
            for category, techniques in response.items():
                print(f"   - {category}: {len(techniques)} techniques")
        
        return success

    def test_update_session_progress(self):
        """Test updating session progress"""
        if not self.session_id:
            print("❌ Skipping - No session ID available")
            return False
            
        progress_data = {
            "emotion_assessment_id": self.emotion_id,
            "horse_observation_id": self.horse_observation_id,
            "breathing_exercises_completed": ["4-7-8-breathing", "box-breathing"],
            "progress_percentage": 75.0
        }
        
        success, response = self.run_test(
            "Update Session Progress",
            "PUT",
            f"sessions/{self.session_id}/progress",
            200,
            data=progress_data
        )
        return success

    def test_get_rider_sessions(self):
        """Test getting rider sessions"""
        if not self.rider_id:
            print("❌ Skipping - No rider ID available")
            return False
            
        success, response = self.run_test(
            "Get Rider Sessions",
            "GET",
            f"riders/{self.rider_id}/sessions",
            200
        )
        
        if success and isinstance(response, list):
            print(f"   Found {len(response)} sessions for rider")
        
        return success

    def test_create_emergency_event(self):
        """Test creating an emergency event"""
        if not self.rider_id or not self.session_id:
            print("❌ Skipping - No rider or session ID available")
            return False
            
        emergency_data = {
            "rider_id": self.rider_id,
            "session_id": self.session_id,
            "trigger_reason": "High anxiety during warm-up",
            "intervention_used": "4-7-8 breathing exercise",
            "resolution_time_minutes": 5,
            "notes": "Successfully calmed down using breathing technique"
        }
        
        success, response = self.run_test(
            "Create Emergency Event",
            "POST",
            "emergency-events",
            200,
            data=emergency_data
        )
        return success

    def test_get_rider_analytics(self):
        """Test getting rider analytics"""
        if not self.rider_id:
            print("❌ Skipping - No rider ID available")
            return False
            
        success, response = self.run_test(
            "Get Rider Analytics",
            "GET",
            f"riders/{self.rider_id}/analytics",
            200
        )
        
        if success and isinstance(response, dict):
            print(f"   Analytics data:")
            for key, value in response.items():
                print(f"   - {key}: {value}")
        
        return success

def main():
    print("🐎 EquiMind API Testing Suite")
    print("=" * 50)
    
    tester = EquiMindAPITester()
    
    # Run all tests in sequence
    test_methods = [
        tester.test_root_endpoint,
        tester.test_create_rider_profile,
        tester.test_get_rider_profile,
        tester.test_create_session,
        tester.test_get_session,
        tester.test_create_emotion_assessment,
        tester.test_create_horse_observation,
        tester.test_get_breathing_exercises,
        tester.test_get_emergency_techniques,
        tester.test_update_session_progress,
        tester.test_get_rider_sessions,
        tester.test_create_emergency_event,
        tester.test_get_rider_analytics
    ]
    
    for test_method in test_methods:
        test_method()
    
    # Print final results
    print("\n" + "=" * 50)
    print(f"📊 Final Results: {tester.tests_passed}/{tester.tests_run} tests passed")
    
    if tester.tests_passed == tester.tests_run:
        print("🎉 All tests passed! Backend API is working correctly.")
        return 0
    else:
        print(f"⚠️  {tester.tests_run - tester.tests_passed} tests failed. Please check the issues above.")
        return 1

if __name__ == "__main__":
    sys.exit(main())