import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv()

# MongoDB connection from environment
mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')

# Missing tool from original script
missing_tool = {
    "id": "is-this-a-riding-day",
    "name": "Is This a Riding Day? Self-Assessment",
    "category": "Distress Tolerance",
    "instructions": "Use this checklist to assess whether today is a safe day to ride. Check each item that describes you today. MENTAL STATE: My thoughts are racing. I feel overwhelmed or emotionally flooded. I am catastrophizing or thinking in extremes. I feel disconnected, numb, or checked out. EMOTIONAL SIGNS: I feel anxious, irritable, or on edge. I feel dread approaching the barn. I feel pressure to push through. BODY SIGNS: I feel shaky, hot, tight, or lightheaded. My breathing is shallow or fast. I feel physically tense. HORSE FEEDBACK: My horse seems tense, watchy, or reactive. My horse is not standing still or is hyper-alert. My horse is mirroring my tension. DECISION GUIDE: If 3 or more items are checked, use distress tolerance tools (like STOP, Temperature Reset, or Groundwork First) before deciding to ride. If 5 or more items are checked, choose groundwork or no ride today for safety. This is not weakness. This is wisdom.",
    "duration_minutes": 4
}

async def add_tool():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🌱 Adding missing 'Is This a Riding Day?' tool to {db_name}...\n")
    
    # Check if it already exists
    existing = await db.mental_strategies.find_one({"id": missing_tool["id"]})
    
    if existing:
        print(f"⏭️  Tool already exists: {existing['name']}")
    else:
        await db.mental_strategies.insert_one(missing_tool)
        print(f"✅ Added: {missing_tool['name']}")
    
    # Final count
    final_count = await db.mental_strategies.count_documents({})
    final_distress = await db.mental_strategies.count_documents({"category": "Distress Tolerance"})
    
    print(f"\n📊 Final database stats:")
    print(f"   Total tools: {final_count}")
    print(f"   Distress Tolerance tools: {final_distress}")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(add_tool())
