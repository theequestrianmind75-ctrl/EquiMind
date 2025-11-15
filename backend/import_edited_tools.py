"""
Import edited tools from JSON file
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import json

load_dotenv()

async def import_tools():
    import_file = '/app/equimind_tools_for_editing.json'
    
    if not os.path.exists(import_file):
        print(f'❌ File not found: {import_file}')
        print('Please upload your edited file to this location first.')
        return
    
    print("📥 Importing edited tools...")
    
    # Load edited tools
    with open(import_file, 'r', encoding='utf-8') as f:
        tools = json.load(f)
    
    print(f'Found {len(tools)} tools in file')
    
    # Connect to database
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    # Backup current database first
    print('Creating backup before import...')
    current_tools = await db.mental_strategies.find().to_list(None)
    backup_file = '/app/backend/backup_before_import.json'
    with open(backup_file, 'w') as f:
        json.dump([{k: v for k, v in t.items() if k != '_id'} for t in current_tools], f, indent=2, default=str)
    print(f'✅ Backup saved to {backup_file}')
    
    # Clear existing
    delete_result = await db.mental_strategies.delete_many({})
    print(f'🗑️  Deleted {delete_result.deleted_count} existing tools')
    
    # Import new/edited tools
    if tools:
        result = await db.mental_strategies.insert_many(tools)
        print(f'✅ Imported {len(result.inserted_ids)} tools')
    
    # Verify
    count = await db.mental_strategies.count_documents({})
    print(f'📊 Final database count: {count} tools')
    
    client.close()
    print('\n✨ Import complete!')
    print('⚠️  Remember to restart services:')
    print('   sudo supervisorctl restart backend expo')

if __name__ == "__main__":
    asyncio.run(import_tools())
