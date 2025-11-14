"""
Script to add new breathing/HRV tools to the database
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import uuid

load_dotenv()

async def add_breathing_tools():
    # Connect to MongoDB
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("🔄 Adding new breathing/HRV tools to database...")
    
    # Define the new tools
    new_tools_data = [
        {
            "name": "HRV Coherence Breath (Inhale 4, Exhale 6)",
            "category": "breathing_hrv",
            "description": "Creates heart-rate variability coherence by lengthening the exhale and synchronizing with horse movement.",
            "duration_minutes": 3,
            "trigger_conditions": {
                "anxiety_min": 3,
                "anxiety_max": 9,
                "confidence_min": 1,
                "confidence_max": 7
            },
            "instructions": [
                "Place your horse in a relaxed walk or quiet halt.",
                "Inhale softly through your nose for 4 counts, then exhale gently for 6 counts.",
                "Repeat for 6–10 breath cycles while monitoring your horse's relaxation."
            ],
            "evidence_base": "HeartMath HRV coherence protocols, autonomic regulation research.",
            "suitable_for": ["anxiety", "focus", "emotional_regulation"]
        },
        {
            "name": "Long Exhale Relaxation Breath",
            "category": "breathing_hrv",
            "description": "Uses elongated exhalation to shift the nervous system toward parasympathetic calm.",
            "duration_minutes": 3,
            "trigger_conditions": {
                "anxiety_min": 3,
                "anxiety_max": 10,
                "confidence_min": 1,
                "confidence_max": 7
            },
            "instructions": [
                "At the walk, inhale normally.",
                "Make your exhale twice as long as the inhale, letting your shoulders drop.",
                "Continue for several cycles, noticing changes in your horse's stride."
            ],
            "evidence_base": "Respiratory sinus arrhythmia research; breathwork for autonomic down-regulation.",
            "suitable_for": ["anxiety", "hyperarousal", "tension_release"]
        },
        {
            "name": "Breath-Per-Stride Synchronization",
            "category": "breathing_hrv",
            "description": "Synchronizes breath rhythm to horse footfalls to increase stability and focus.",
            "duration_minutes": 3,
            "trigger_conditions": {
                "anxiety_min": 3,
                "anxiety_max": 8,
                "confidence_min": 1,
                "confidence_max": 7
            },
            "instructions": [
                "At the walk, match your inhale to 2–3 steps and exhale to 3–4 steps.",
                "Keep your breathing smooth, allowing your pelvis to follow the horse.",
                "Ride one arena lap maintaining this rhythm."
            ],
            "evidence_base": "Sports synchrony and paced-breathing research.",
            "suitable_for": ["focus", "body_awareness"]
        },
        {
            "name": "Co-Regulating with Horse Movement Breath",
            "category": "breathing_hrv",
            "description": "Pairs breath with the horse's natural back swing to regulate tension.",
            "duration_minutes": 3,
            "trigger_conditions": {
                "anxiety_min": 3,
                "anxiety_max": 9,
                "confidence_min": 1,
                "confidence_max": 7
            },
            "instructions": [
                "Feel your horse's back move under your seat.",
                "Inhale as your pelvis rises and exhale as it settles.",
                "Stay with the movement for 10–12 cycles."
            ],
            "evidence_base": "Co-regulation and animal-assisted nervous-system synchronization research.",
            "suitable_for": ["connection", "calming", "body_awareness"]
        },
        {
            "name": "Double-Length Exhale (4:8)",
            "category": "breathing_hrv",
            "description": "Regulates the nervous system by extending the exhale to twice the length of the inhale.",
            "duration_minutes": 3,
            "trigger_conditions": {
                "anxiety_min": 4,
                "anxiety_max": 9,
                "confidence_min": 1,
                "confidence_max": 6
            },
            "instructions": [
                "Inhale for 4 counts.",
                "Exhale softly for 8 counts without pushing air out.",
                "Continue for 5–7 cycles."
            ],
            "evidence_base": "Breathwork down-regulation studies (Huberman, RSA modulation).",
            "suitable_for": ["panic", "high_arousal"]
        },
        {
            "name": "4-2-6 Performance Breath",
            "category": "breathing_hrv",
            "description": "Performance-based breath pattern to reduce nervous-system activation before transitions or technical work.",
            "duration_minutes": 3,
            "trigger_conditions": {
                "anxiety_min": 4,
                "anxiety_max": 10,
                "confidence_min": 1,
                "confidence_max": 7
            },
            "instructions": [
                "Inhale for 4 counts.",
                "Hold for 2 counts.",
                "Exhale for 6 counts and repeat."
            ],
            "evidence_base": "Sports psychology breath-hold research; HRV optimization.",
            "suitable_for": ["show_anxiety", "performance_stress"]
        },
        {
            "name": "Heart-Focused Breathing",
            "category": "breathing_hrv",
            "description": "Breathing as if in and out of the heart area to increase emotional coherence.",
            "duration_minutes": 3,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 8,
                "confidence_min": 1,
                "confidence_max": 7
            },
            "instructions": [
                "Shift attention to the center of your chest.",
                "Breathe slowly as if the breath is moving through your heart space.",
                "Stay with steady rhythm for 10–12 breaths."
            ],
            "evidence_base": "HeartMath emotional regulation and coherence training.",
            "suitable_for": ["emotional_regulation", "connection"]
        },
        {
            "name": "Breath Into Belt Line",
            "category": "breathing_hrv",
            "description": "Expands diaphragm and lowers tension by breathing 360° around the waistline.",
            "duration_minutes": 3,
            "trigger_conditions": {
                "anxiety_min": 3,
                "anxiety_max": 8,
                "confidence_min": 1,
                "confidence_max": 7
            },
            "instructions": [
                "At the walk, breathe low into your belly and around your waist.",
                "Feel the belt-line expand evenly.",
                "Release on the exhale and soften your seat."
            ],
            "evidence_base": "Diaphragmatic breathing research; somatic therapy.",
            "suitable_for": ["tension", "hyperarousal"]
        },
        {
            "name": "Exhale Seat-Softening Breath",
            "category": "breathing_hrv",
            "description": "Softens the seat and thighs during the exhale to improve freedom of horse movement.",
            "duration_minutes": 2,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 8,
                "confidence_min": 1,
                "confidence_max": 8
            },
            "instructions": [
                "As you exhale, let your seat and thighs grow heavier and softer.",
                "Continue for 8-10 breath cycles while maintaining contact with your horse.",
                "Notice how your horse responds to the relaxation."
            ],
            "evidence_base": "Somatic release and rider tension research.",
            "suitable_for": ["tension", "overcontrol", "connection"]
        }
    ]
    
    # Convert to database format
    tools_to_insert = []
    for tool_data in new_tools_data:
        # Convert trigger conditions to arrays
        anxiety_min = tool_data['trigger_conditions']['anxiety_min']
        anxiety_max = tool_data['trigger_conditions']['anxiety_max']
        confidence_min = tool_data['trigger_conditions']['confidence_min']
        confidence_max = tool_data['trigger_conditions']['confidence_max']
        
        anxiety_level = list(range(anxiety_min, anxiety_max + 1))
        confidence_level = list(range(confidence_min, confidence_max + 1))
        
        # Convert instructions array to string
        instructions_text = "\n".join(tool_data['instructions'])
        
        # Map category to database category
        category = "Breathing / HRV" if tool_data['category'] == "breathing_hrv" else tool_data['category']
        
        tool = {
            'id': str(uuid.uuid4()),
            'name': tool_data['name'],
            'category': category,
            'description': tool_data['description'],
            'instructions': instructions_text,
            'duration_minutes': tool_data['duration_minutes'],
            'anxiety_level': anxiety_level,
            'confidence_level': confidence_level,
            'effectiveness_rating': 4.0,  # Default rating
            'evidence_base': tool_data.get('evidence_base', ''),
            'suitable_for': tool_data.get('suitable_for', [])
        }
        
        tools_to_insert.append(tool)
    
    # Insert tools
    if tools_to_insert:
        result = await db.mental_strategies.insert_many(tools_to_insert)
        print(f"✅ Successfully added {len(result.inserted_ids)} new breathing/HRV tools")
    
    # Verify
    breathing_count = await db.mental_strategies.count_documents({'category': 'Breathing / HRV'})
    print(f"📊 Total Breathing / HRV tools in database: {breathing_count}")
    
    # Show samples
    print(f"\n📋 New breathing/HRV tools added:")
    for tool in tools_to_insert[:3]:
        print(f"  • {tool['name']} ({tool['duration_minutes']} min)")
    print(f"  ... and {len(tools_to_insert) - 3} more")
    
    client.close()
    print("\n✨ Breathing/HRV tools import complete!")

if __name__ == "__main__":
    asyncio.run(add_breathing_tools())
