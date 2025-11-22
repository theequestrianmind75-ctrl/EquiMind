import asyncio
from motor.motor_asyncio import AsyncIOMotorClient

# MongoDB connection
mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind_production"

# New recommendations with tool IDs
new_recommendations = [
    # High Confidence + High Anxiety (Competition Nerves)
    {
        "trigger_condition": "high_confidence_high_anxiety",
        "context": "any",
        "text": "You feel capable, but your nerves are high. Let's channel that energy into focus instead of overwhelm.",
        "suggested_tool_names": [
            "90-Second Arousal Balance Reset",
            "Competition Nerves: Label and Aim",
            "Show Ring Box Breathing"
        ],
        "priority": 10,
        "active": True
    },
    
    # Low Energy / Low Motivation
    {
        "trigger_condition": "low_energy_low_motivation",
        "context": "any",
        "text": "You're not broken—you're tired. Let's gently build a bit of momentum and reconnect with why you ride.",
        "suggested_tool_names": [
            "Low Energy 5-Minute Activation",
            "Gentle Shoulder and Hip Reset",
            "Why I Ride Values Reminder"
        ],
        "priority": 10,
        "active": True
    },
    
    # Competition Mode Context
    {
        "trigger_condition": "context_competition",
        "context": "competition",
        "text": "You're in show mode. Let's get you competition-ready with focused, performance-oriented tools.",
        "suggested_tool_names": [
            "Competition Pre-Ride Focus 3×3",
            "Mounting Block Focus Sequence",
            "At-the-Gate Calm Start Visual"
        ],
        "priority": 8,
        "active": True
    },
    
    # Training Mode Context
    {
        "trigger_condition": "context_training",
        "context": "training",
        "text": "You're in training mode. Let's work on skill development, connection, and mindful exploration.",
        "suggested_tool_names": [
            "Training Ride Mindfulness Scan",
            "10-Minute Single Skill Focus",
            "Hand-Graze Connection Ritual"
        ],
        "priority": 8,
        "active": True
    },
]

async def add_recommendations():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🌱 Adding {len(new_recommendations)} new recommendations to {db_name}...\n")
    
    # Count existing recommendations
    existing_count = await db.recommendations.count_documents({})
    print(f"📊 Current recommendations in database: {existing_count}")
    
    # Check for duplicates
    existing_triggers = set()
    async for doc in db.recommendations.find({}, {"trigger_condition": 1, "context": 1}):
        key = f"{doc.get('trigger_condition')}_{doc.get('context', 'any')}"
        existing_triggers.add(key)
    
    recs_to_add = []
    skipped = []
    
    for rec in new_recommendations:
        key = f"{rec['trigger_condition']}_{rec['context']}"
        if key in existing_triggers:
            skipped.append(f"{rec['trigger_condition']} ({rec['context']})")
        else:
            recs_to_add.append(rec)
    
    if skipped:
        print(f"\n⚠️  Skipping {len(skipped)} duplicate recommendations:")
        for name in skipped:
            print(f"   - {name}")
    
    if recs_to_add:
        result = await db.recommendations.insert_many(recs_to_add)
        print(f"\n✅ Successfully added {len(result.inserted_ids)} new recommendations!")
        
        print("\n📋 Recommendations added:")
        for rec in recs_to_add:
            tools = ", ".join(rec['suggested_tool_names'][:2]) + "..."
            print(f"   • {rec['trigger_condition']} ({rec['context']})")
            print(f"     Tools: {tools}")
        
        # Show new total
        new_count = await db.recommendations.count_documents({})
        print(f"\n📈 Total recommendations: {existing_count} → {new_count} (+{new_count - existing_count})")
    else:
        print("\n✓ No new recommendations to add (all already exist)")
    
    client.close()

if __name__ == '__main__':
    asyncio.run(add_recommendations())
