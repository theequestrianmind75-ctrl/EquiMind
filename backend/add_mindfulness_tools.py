"""
Script to add new mindfulness tools to the database
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import uuid
import json

load_dotenv()

async def add_mindfulness_tools():
    # Connect to MongoDB
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("🔄 Adding new mindfulness tools to database...")
    
    # Define the new tools
    new_tools_data = [
        {
            "name": "Five-Sense Horseback Scan",
            "category": "mindfulness",
            "description": "On-horse mindfulness exercise using all five senses to anchor rider and horse into the present moment.",
            "duration_minutes": 5,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 7,
                "confidence_min": 2,
                "confidence_max": 7
            },
            "instructions": [
                "Place your horse at a relaxed walk or quiet halt in a familiar, safe space.",
                "Scan through sight, sound, touch, smell, and taste, noticing each sensation without judging.",
                "Remain present for 5–10 breaths and observe your horse's feedback."
            ],
            "evidence_base": "Mindfulness-Based Stress Reduction (MBSR), sensory grounding research, equine-assisted mindfulness practices.",
            "suitable_for": ["anxiety", "focus", "emotional_awareness"]
        },
        {
            "name": "Seat-Bone Awareness Tracking",
            "category": "mindfulness",
            "description": "Mindfulness exercise focusing on awareness of the rider's seat bones and how they move with the horse.",
            "duration_minutes": 5,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 7,
                "confidence_min": 2,
                "confidence_max": 7
            },
            "instructions": [
                "At the walk, notice each seat bone independently.",
                "Observe how they rise, lower, and follow the swing of the horse's back.",
                "Maintain awareness for one arena lap."
            ],
            "evidence_base": "Somatic mindfulness, body-awareness research, rider biomechanics studies.",
            "suitable_for": ["tension_release", "focus", "body_awareness"]
        },
        {
            "name": "Mindful Rein Contact Check",
            "category": "mindfulness",
            "description": "Mindfulness practice to develop awareness of rein feel, hand tension, and communication with the horse's mouth.",
            "duration_minutes": 5,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 7,
                "confidence_min": 2,
                "confidence_max": 7
            },
            "instructions": [
                "Pick up a neutral rein contact.",
                "Notice tension in fingers, wrists, and forearms.",
                "Soften your hands by 5% and observe changes in your horse."
            ],
            "evidence_base": "Mindful touch research, equitation science, sports attentional control.",
            "suitable_for": ["performance_stress", "precision", "emotional_regulation"]
        },
        {
            "name": "Body-to-Horse Synchrony Check",
            "category": "mindfulness",
            "description": "Enhances rider-horse synchrony by focusing attention on shared movement rhythm.",
            "duration_minutes": 5,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 7,
                "confidence_min": 2,
                "confidence_max": 7
            },
            "instructions": [
                "Allow your body to follow your horse's movement without bracing.",
                "Notice where movement flows smoothly and where it feels blocked.",
                "Soften tension and rejoin your horse's rhythm."
            ],
            "evidence_base": "Co-regulation research, equine biomechanics, mindfulness in motion.",
            "suitable_for": ["connection", "focus", "body_awareness"]
        },
        {
            "name": "Mindful Listening to Arena Sounds",
            "category": "mindfulness",
            "description": "Uses mindful hearing to broaden awareness and reduce tunnel vision during riding.",
            "duration_minutes": 5,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 7,
                "confidence_min": 2,
                "confidence_max": 7
            },
            "instructions": [
                "At the walk, tune into ambient sounds in and outside the arena.",
                "Label sounds neutrally as 'near', 'far', 'soft', or 'sharp'.",
                "Allow listening to expand your awareness instead of narrowing it."
            ],
            "evidence_base": "Mindfulness-based sound grounding, attentional widening research.",
            "suitable_for": ["hypervigilance", "performance_stress"]
        },
        {
            "name": "Visual Horizon Soft-Gaze Practice",
            "category": "mindfulness",
            "description": "A visual mindfulness exercise that softens the eyes and expands rider situational awareness.",
            "duration_minutes": 4,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 7,
                "confidence_min": 2,
                "confidence_max": 7
            },
            "instructions": [
                "Lift your gaze to the horizon without fixing on a single point.",
                "Soften your peripheral vision and let your eyes relax.",
                "Ride while maintaining wide, calm visual awareness."
            ],
            "evidence_base": "Sports psychology visual field expansion, polyvagal theory.",
            "suitable_for": ["anxiety", "hyperfocus", "environmental_awareness"]
        },
        {
            "name": "Noticing Micro-Tension (2 Percent Release)",
            "category": "mindfulness",
            "description": "Mindfulness practice aimed at identifying and reducing tiny amounts of tension in the rider's body.",
            "duration_minutes": 3,
            "trigger_conditions": {
                "anxiety_min": 1,
                "anxiety_max": 8,
                "confidence_min": 1,
                "confidence_max": 7
            },
            "instructions": [
                "Scan for tiny tension areas in shoulders, jaw, thighs, or hands.",
                "Release tension by only 2%, keeping movements small and safe.",
                "Notice your horse soften in response."
            ],
            "evidence_base": "Somatic mindfulness, micro-relaxation research, horse-rider tension studies.",
            "suitable_for": ["tension", "overcontrol", "nervous_energy"]
        },
        {
            "name": "Rider Thought Labeling: 'This is a thought'",
            "category": "mindfulness",
            "description": "Cognitive defusion practice to separate thoughts from actions while riding.",
            "duration_minutes": 4,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 9,
                "confidence_min": 1,
                "confidence_max": 7
            },
            "instructions": [
                "Notice any stressful or distracting thought.",
                "Label it: 'This is a thought, not a fact.'",
                "Return focus to your horse's movement."
            ],
            "evidence_base": "ACT cognitive defusion, mindfulness-based cognitive therapy.",
            "suitable_for": ["overthinking", "fear", "show_anxiety"]
        },
        {
            "name": "Observation Without Judgment (MBSR)",
            "category": "mindfulness",
            "description": "Encourages non-judgmental awareness of internal and external experience while mounted.",
            "duration_minutes": 5,
            "trigger_conditions": {
                "anxiety_min": 2,
                "anxiety_max": 7,
                "confidence_min": 2,
                "confidence_max": 7
            },
            "instructions": [
                "Notice sensations, posture, and horse behavior without assigning meaning.",
                "Practice accepting what is happening rather than correcting immediately.",
                "Stay with non-judgment for one arena long side."
            ],
            "evidence_base": "Mindfulness-Based Stress Reduction (MBSR).",
            "suitable_for": ["self_criticism", "perfectionism", "emotional_regulation"]
        },
        {
            "name": "Noticing Horse Micro-Cues",
            "category": "mindfulness",
            "description": "Enhances horse-rider communication by noticing subtle signals such as breath changes or ear flicks.",
            "duration_minutes": 5,
            "trigger_conditions": {
                "anxiety_min": 1,
                "anxiety_max": 8,
                "confidence_min": 1,
                "confidence_max": 8
            },
            "instructions": [
                "Observe your horse's small signals: breath, ears, neck, stride.",
                "Notice patterns without reacting right away.",
                "Stay curious, not critical, about what your horse communicates."
            ],
            "evidence_base": "Equine behavior science, mindfulness-based observation.",
            "suitable_for": ["connection", "communication", "horse_reading_skill"]
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
        category = "Mindfulness & Flow" if tool_data['category'] == "mindfulness" else tool_data['category']
        
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
        print(f"✅ Successfully added {len(result.inserted_ids)} new mindfulness tools")
    
    # Verify
    mindfulness_count = await db.mental_strategies.count_documents({'category': 'Mindfulness & Flow'})
    print(f"📊 Total Mindfulness & Flow tools in database: {mindfulness_count}")
    
    # Show samples
    print(f"\n📋 New mindfulness tools added:")
    for tool in tools_to_insert[:3]:
        print(f"  • {tool['name']} ({tool['duration_minutes']} min)")
    print(f"  ... and {len(tools_to_insert) - 3} more")
    
    client.close()
    print("\n✨ Mindfulness tools import complete!")

if __name__ == "__main__":
    asyncio.run(add_mindfulness_tools())
