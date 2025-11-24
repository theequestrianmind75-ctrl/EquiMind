import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv()

# MongoDB connection from environment
mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')

# Mapping remaining mindfulness tools to recommendations
additional_mindfulness_mapping = {
    # Pre-ride anxiety tools
    "Try 'Box Breath' or '4:8 Tension Melt Exhale'": [
        "Noticing Micro-Tension (2 Percent Release)",
        "Observation Without Judgment (MBSR)"
    ],
    
    # Safe Seat Reset - body awareness
    "Consider practicing 'The Safe Seat Reset'": [
        "Seat-Bone Awareness Tracking",
        "Body-to-Horse Synchrony Check"
    ],
    
    # Anxiety increased - thought management
    "Your anxiety increased during the ride": [
        "Rider Thought Labeling: 'This is a thought'",
        "Observation Without Judgment (MBSR)"
    ],
    
    # Thought labeling related
    "Practice 'Thought Labeling + Releasing'": [
        "Rider Thought Labeling: 'This is a thought'",
        "Observation Without Judgment (MBSR)"
    ],
    
    # Confidence building - awareness
    "Build confidence with 'Micro-Goal Cueing'": [
        "Noticing Horse Micro-Cues",
        "Visual Horizon Soft-Gaze Practice"
    ],
    
    # Tapping for confidence
    "Try EFT Tapping sequences": [
        "Visual Horizon Soft-Gaze Practice",
        "Mindful Rein Contact Check"
    ],
    
    # Horse co-regulation
    "Practice 'Co-Regulation' - match your breathing": [
        "Body-to-Horse Synchrony Check",
        "Noticing Horse Micro-Cues"
    ],
    
    # Horse high energy
    "Your horse's high energy may be overwhelming": [
        "Noticing Horse Micro-Cues",
        "Seat-Bone Awareness Tracking"
    ],
    
    # Horse low focus
    "Your horse's focus was low": [
        "Noticing Horse Micro-Cues",
        "Mindful Listening to Arena Sounds"
    ],
    
    # Peripheral vision technique
    "Consider the 'Peripheral Vision Expansion' technique": [
        "Visual Horizon Soft-Gaze Practice",
        "Mindful Listening to Arena Sounds"
    ],
    
    # Dual awareness
    "Use 'Dual Awareness' statements": [
        "Body-to-Horse Synchrony Check",
        "Noticing Micro-Tension (2 Percent Release)"
    ],
    
    # Varied exercises for horse
    "Consider shorter, more varied exercises": [
        "Mindful Listening to Arena Sounds",
        "Mindful Rein Contact Check"
    ],
    
    # Excellent session / flow state
    "Excellent session! Low anxiety + high confidence": [
        "Mindful Rein Contact Check",
        "Seat-Bone Awareness Tracking"
    ],
    
    # Competition nerves
    "You feel capable, but your nerves are high": [
        "Noticing Micro-Tension (2 Percent Release)",
        "Visual Horizon Soft-Gaze Practice"
    ],
    
    # Low energy
    "You're not broken—you're tired": [
        "Observation Without Judgment (MBSR)",
        "Mindful Listening to Arena Sounds"
    ],
    
    # Competition mode
    "You're in show mode": [
        "Visual Horizon Soft-Gaze Practice",
        "Noticing Micro-Tension (2 Percent Release)"
    ],
    
    # Training mode
    "You're in training mode": [
        "Noticing Horse Micro-Cues",
        "Mindful Rein Contact Check",
        "Body-to-Horse Synchrony Check"
    ]
}

async def map_tools():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🔗 Mapping remaining Mindfulness tools to recommendations in {db_name}...\n")
    
    updated_count = 0
    
    for text_snippet, tools_to_add in additional_mindfulness_mapping.items():
        # Find recommendation by partial text match
        rec = await db.recommendations.find_one({
            "text": {"$regex": text_snippet, "$options": "i"}
        })
        
        if rec:
            current_tools = rec.get('suggested_tool_names', [])
            
            # Add new tools that aren't already there
            updated_tools = current_tools.copy()
            new_tools_added = []
            
            for tool in tools_to_add:
                if tool not in updated_tools:
                    updated_tools.append(tool)
                    new_tools_added.append(tool)
            
            if new_tools_added:
                await db.recommendations.update_one(
                    {"_id": rec["_id"]},
                    {"$set": {"suggested_tool_names": updated_tools}}
                )
                print(f"✅ Updated: {rec['text'][:60]}...")
                print(f"   Added: {', '.join(new_tools_added)}")
                print(f"   Total tools: {len(updated_tools)}\n")
                updated_count += 1
            else:
                print(f"⏭️  Already complete: {rec['text'][:60]}...\n")
        else:
            print(f"⚠️  Not found: {text_snippet[:60]}...\n")
    
    print(f"📊 Complete!")
    print(f"   Updated {updated_count} recommendations")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(map_tools())
