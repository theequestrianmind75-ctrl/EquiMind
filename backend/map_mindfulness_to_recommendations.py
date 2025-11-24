import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv()

# MongoDB connection from environment
mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')

# Mapping strategy: Add mindfulness tools to recommendations based on context
mindfulness_mapping = {
    # Pre-ride anxiety - add calming mindfulness tools
    "Try 'Box Breath' or '4:8 Tension Melt Exhale'": [
        "Mindful Mounting Sequence",
        "Breath Sync With Your Horse",
        "Arena Edge Mindfulness Walk"
    ],
    
    # Anxiety during ride
    "Consider practicing 'The Safe Seat Reset'": [
        "60-Second Rider Body Scan",
        "Present-Moment Reins Check"
    ],
    
    # Anxiety increased during ride
    "Your anxiety increased during the ride": [
        "60-Second Rider Body Scan",
        "Mindful Half-Halt",
        "Present-Moment Reins Check"
    ],
    
    # Focus and awareness
    "Practice 'Thought Labeling + Releasing'": [
        "Footfall Awareness Drill",
        "Mindful Transition Focus"
    ],
    
    # Confidence building
    "Build confidence with 'Micro-Goal Cueing'": [
        "Mindful Arena Entry",
        "Mindful Transition Focus"
    ],
    
    # Horse tension/connection
    "Practice 'Co-Regulation' - match your breathing": [
        "Breath Sync With Your Horse",
        "Arena Edge Mindfulness Walk"
    ],
    
    # Horse high energy
    "Your horse's high energy may be overwhelming": [
        "Breath Sync With Your Horse",
        "60-Second Rider Body Scan"
    ],
    
    # Horse low focus
    "Your horse's focus was low": [
        "Arena Edge Mindfulness Walk",
        "Footfall Awareness Drill"
    ],
    
    # Flow state / excellent session
    "Excellent session! Low anxiety + high confidence": [
        "Post-Ride Mindful Cooldown",
        "Mindful Transition Focus"
    ],
    
    "Consider this your 'flow state' session": [
        "Post-Ride Mindful Cooldown",
        "Footfall Awareness Drill"
    ],
    
    # Progress tracking
    "Great progress! Your anxiety decreased": [
        "Post-Ride Mindful Cooldown"
    ],
    
    # Optimal horse metrics
    "Your horse showed optimal metrics": [
        "Post-Ride Mindful Cooldown",
        "Breath Sync With Your Horse"
    ],
    
    # General completion
    "Great job completing your session": [
        "Post-Ride Mindful Cooldown"
    ],
    
    # Competition nerves (high confidence + high anxiety)
    "You feel capable, but your nerves are high": [
        "Mindful Arena Entry",
        "60-Second Rider Body Scan",
        "Breath Sync With Your Horse"
    ],
    
    # Training mode
    "You're in training mode": [
        "Mindful Arena Entry",
        "Footfall Awareness Drill",
        "Mindful Transition Focus"
    ]
}

async def map_tools():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🔗 Mapping Mindfulness tools to recommendations in {db_name}...\n")
    
    updated_count = 0
    
    for text_snippet, tools_to_add in mindfulness_mapping.items():
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
            print(f"⚠️  Not found: {text_snippet[:60]}...\n")
    
    print(f"📊 Complete!")
    print(f"   Updated {updated_count} recommendations")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(map_tools())
