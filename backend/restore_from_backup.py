"""
Restore mental strategies from the latest backup
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import json

load_dotenv()

async def restore_from_backup():
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    backup_file = '/app/backend/backup_mental_strategies_LATEST.json'
    
    if not os.path.exists(backup_file):
        print('❌ No backup file found!')
        return
    
    print("📥 Restoring from backup...")
    
    with open(backup_file, 'r') as f:
        tools = json.load(f)
    
    print(f'Found {len(tools)} tools in backup')
    
    # Clear existing
    delete_result = await db.mental_strategies.delete_many({})
    print(f'🗑️  Deleted {delete_result.deleted_count} existing tools')
    
    # Insert backup
    if tools:
        result = await db.mental_strategies.insert_many(tools)
        print(f'✅ Restored {len(result.inserted_ids)} tools from backup')
    
    # Verify
    count = await db.mental_strategies.count_documents({})
    print(f'📊 Final database count: {count} tools')
    
    client.close()
    print('\n✨ Restoration complete!')

if __name__ == "__main__":
    asyncio.run(restore_from_backup())
