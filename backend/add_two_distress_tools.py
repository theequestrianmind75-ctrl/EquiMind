import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv()

# MongoDB connection from environment
mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')

# New Distress Tolerance tools
new_tools = [
    {
        "id": "five-minute-nervous-system-reset-assessment",
        "name": "5-Minute Nervous System Reset",
        "category": "Distress Tolerance",
        "description": "A structured 5-minute sequence that helps riders assess and regulate their nervous system before deciding whether to ride, modify, or choose groundwork.",
        "instructions": "Minute 1 — BREATH:\nInhale for a count of 4 and exhale for a count of 6. Repeat slowly.\n\nMinute 2 — BODY:\nDrop your shoulders, soften your jaw, and loosen the grip of your hands.\n\nMinute 3 — SENSORY RESET:\nName 3 things you see, 2 things you hear, and 1 thing you can touch.\n\nMinute 4 — CONNECTION:\nPlace a hand on your horse's shoulder or neck and match your breathing to a calm rhythm.\n\nMinute 5 — DECISION:\nAsk yourself: \"Do I feel safe? Does my horse feel safe? What is the kindest choice for both of us?\" Then choose: Ride, Groundwork, or No ride.",
        "duration_minutes": 5,
        "anxiety_level": [4, 5, 6, 7, 8, 9],
        "confidence_level": [1, 2, 3, 4, 5, 6],
        "effectiveness_rating": 4.8,
        "evidence_base": "Breath-based regulation, grounding techniques, co-regulation with horses, applied sports psychology routines",
        "suitable_for": [
            "pre_ride",
            "post_scare",
            "after_work_stress",
            "overwhelm",
            "transition_to_barn_mode",
            "safety_check"
        ]
    },
    {
        "id": "pre-ride-emotional-check-in-assessment",
        "name": "Pre-Ride Emotional Check-In",
        "category": "Distress Tolerance",
        "description": "A brief self-assessment to help riders identify emotional state, triggers, body sensations, horse feedback, and choose the safest, kindest ride plan.",
        "instructions": "1. What am I feeling emotionally right now?\nWrite your answer.\n\n2. On a scale of 1–10, what is my emotional intensity?\nCircle or note a number from 1–10.\n\n3. What triggered or contributed to my current state?\nDescribe any events, thoughts, or stressors.\n\n4. What physical sensations do I notice in my body?\nWrite the sensations (e.g., tight chest, shaky hands, tense jaw).\n\n5. What is my horse showing me right now?\nDescribe your horse's behavior, expression, and energy.\n\n6. What is one thing I need before deciding to ride? (e.g., breathing, grounding, pause, drinking water, going outside.)\nWrite your answer.\n\n7. If I ride, what is the safest, kindest plan for me and my horse?\nDescribe the plan (e.g., walk-only ride, light schooling, groundwork, or no ride).",
        "duration_minutes": 5,
        "anxiety_level": [3, 4, 5, 6, 7, 8],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7],
        "effectiveness_rating": 4.7,
        "evidence_base": "Self-monitoring and emotional awareness assessments, CBT/DBT-informed check-ins, sports psychology pre-performance routines",
        "suitable_for": [
            "pre_ride",
            "emotion_awareness",
            "return_to_riding",
            "post_fall_recovery",
            "show_prep",
            "safety_planning"
        ]
    }
]

async def add_tools():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🌱 Adding {len(new_tools)} new Distress Tolerance tools to {db_name}...\n")
    
    # Count existing tools
    existing_count = await db.mental_strategies.count_documents({})
    print(f"📊 Current tools in database: {existing_count}")
    
    # Count existing Distress Tolerance tools
    existing_distress = await db.mental_strategies.count_documents({"category": "Distress Tolerance"})
    print(f"📊 Current Distress Tolerance tools: {existing_distress}")
    
    # Check for duplicates
    added_count = 0
    skipped_count = 0
    
    for tool in new_tools:
        existing = await db.mental_strategies.find_one({"id": tool["id"]})
        if existing:
            print(f"⏭️  Skipped (already exists): {tool['name']}")
            skipped_count += 1
        else:
            await db.mental_strategies.insert_one(tool)
            print(f"✅ Added: {tool['name']}")
            added_count += 1
    
    # Final count
    final_count = await db.mental_strategies.count_documents({})
    final_distress = await db.mental_strategies.count_documents({"category": "Distress Tolerance"})
    
    print(f"\n📊 Final database stats:")
    print(f"   Total tools: {final_count}")
    print(f"   Distress Tolerance tools: {final_distress}")
    print(f"\n✨ Migration complete!")
    print(f"   Added: {added_count} tools")
    print(f"   Skipped: {skipped_count} tools")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(add_tools())
