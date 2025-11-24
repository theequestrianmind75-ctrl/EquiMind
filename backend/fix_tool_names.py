import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv()

# MongoDB connection from environment
mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')

async def fix_tool_name():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🔧 Fixing tool name in {db_name}...\n")
    
    # The tool with id "is-this-a-riding-day" should have the name "Is This a Riding Day? Self-Assessment"
    tool = await db.mental_strategies.find_one({"id": "is-this-a-riding-day"})
    
    if tool:
        print(f"Found tool with id 'is-this-a-riding-day'")
        print(f"Current name: {tool['name']}")
        print(f"Instructions start: {tool['instructions'][:100]}...")
        
        # Check if it's the wrong tool (should be the assessment tool)
        if "Check each item that describes you today" in tool['instructions']:
            print(f"\n✅ This is the 'Is This a Riding Day?' assessment tool")
            print(f"Updating name to: 'Is This a Riding Day? Self-Assessment'")
            
            result = await db.mental_strategies.update_one(
                {"id": "is-this-a-riding-day"},
                {"$set": {"name": "Is This a Riding Day? Self-Assessment"}}
            )
            print(f"✅ Updated {result.modified_count} document")
        else:
            print(f"\n⚠️  This tool has instructions for 5-Minute Nervous System Reset")
            print(f"It seems like this is a duplicate. Let me check...")
            
            # Delete this duplicate
            result = await db.mental_strategies.delete_one({"id": "is-this-a-riding-day"})
            print(f"🗑️  Deleted duplicate tool (deleted {result.deleted_count} document)")
    else:
        print("Tool not found")
    
    # Final count
    final_count = await db.mental_strategies.count_documents({})
    final_distress = await db.mental_strategies.count_documents({"category": "Distress Tolerance"})
    
    print(f"\n📊 Final database stats:")
    print(f"   Total tools: {final_count}")
    print(f"   Distress Tolerance tools: {final_distress}")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(fix_tool_name())
