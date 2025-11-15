"""
Backup all mental strategies to a JSON file for recovery
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import json
from datetime import datetime

load_dotenv()

async def backup_tools():
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("📦 Starting backup...")
    
    # Get all tools
    tools = await db.mental_strategies.find().to_list(None)
    
    # Remove MongoDB _id for clean export
    clean_tools = []
    for tool in tools:
        tool.pop('_id', None)
        clean_tools.append(tool)
    
    # Create backup file with timestamp
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_file = f'/app/backend/backup_mental_strategies_{timestamp}.json'
    
    with open(backup_file, 'w') as f:
        json.dump(clean_tools, f, indent=2, default=str)
    
    # Also save as "latest" backup
    latest_file = '/app/backend/backup_mental_strategies_LATEST.json'
    with open(latest_file, 'w') as f:
        json.dump(clean_tools, f, indent=2, default=str)
    
    print(f'✅ Backed up {len(clean_tools)} tools to:')
    print(f'   {backup_file}')
    print(f'   {latest_file}')
    
    client.close()

if __name__ == "__main__":
    asyncio.run(backup_tools())
