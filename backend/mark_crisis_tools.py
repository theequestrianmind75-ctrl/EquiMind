import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv()

# MongoDB connection from environment
mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')

# IDs of the crisis tools (the 5 most recent ones)
crisis_tool_ids = [
    "emergency-ground-tie-and-breathe",
    "barn-safe-space-time-out",
    "crisis-ride-stop-plan-dismount",
    "call-and-connect-support-script",
    "flashback-anchor-kit"
]

async def mark_crisis_tools():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🚨 Marking crisis tools in {db_name}...\n")
    
    updated_count = 0
    
    for tool_id in crisis_tool_ids:
        result = await db.mental_strategies.update_one(
            {"id": tool_id},
            {"$set": {"is_crisis_tool": True}}
        )
        
        if result.modified_count > 0:
            tool = await db.mental_strategies.find_one({"id": tool_id})
            print(f"✅ Marked as crisis tool: {tool['name']}")
            updated_count += 1
        else:
            print(f"⚠️  Tool not found or already marked: {tool_id}")
    
    # Verify
    crisis_count = await db.mental_strategies.count_documents({
        "category": "Distress Tolerance",
        "is_crisis_tool": True
    })
    
    print(f"\n📊 Final stats:")
    print(f"   Updated: {updated_count} tools")
    print(f"   Total crisis tools in Distress Tolerance: {crisis_count}")
    
    # List all crisis tools
    print(f"\n🚨 Crisis Tools:")
    crisis_tools = await db.mental_strategies.find({
        "category": "Distress Tolerance",
        "is_crisis_tool": True
    }).sort("name", 1).to_list(100)
    
    for i, tool in enumerate(crisis_tools, 1):
        print(f"   {i}. {tool['name']}")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(mark_crisis_tools())
