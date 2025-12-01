"""
Production Database Sync Script
Syncs tools from backup file to production on every startup
Updates changed tools without wiping the database
"""
import asyncio
import json
import os
from motor.motor_asyncio import AsyncIOMotorClient
from pathlib import Path

async def sync_tools_to_production():
    """Sync tools from backup file to production database"""
    
    # Get environment variables
    mongo_url = os.environ.get('MONGO_URL', 'mongodb://localhost:27017')
    db_name = os.environ.get('DB_NAME', 'equimind')
    
    print("🔄 Syncing tools from backup to production...")
    
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    # Load backup file
    backup_file = Path(__file__).parent / 'backup_mental_strategies_LATEST.json'
    
    if not backup_file.exists():
        print("⚠️  No backup file found - skipping sync")
        client.close()
        return
    
    with open(backup_file, 'r') as f:
        backup_tools = json.load(f)
    
    print(f"📦 Backup file contains {len(backup_tools)} tools")
    
    # Get current production tool count
    current_count = await db.mental_strategies.count_documents({})
    print(f"📊 Production database has {current_count} tools")
    
    # Upsert each tool from backup (update if exists, insert if new)
    updated_count = 0
    inserted_count = 0
    
    for tool in backup_tools:
        tool_id = tool.get('id')
        if not tool_id:
            continue
        
        # Check if tool exists
        existing = await db.mental_strategies.find_one({"id": tool_id})
        
        if existing:
            # Update existing tool
            await db.mental_strategies.update_one(
                {"id": tool_id},
                {"$set": tool}
            )
            updated_count += 1
        else:
            # Insert new tool
            await db.mental_strategies.insert_one(tool)
            inserted_count += 1
    
    print(f"✅ Sync complete:")
    print(f"   • Updated: {updated_count} tools")
    print(f"   • Inserted: {inserted_count} new tools")
    print(f"   • Total in production: {await db.mental_strategies.count_documents({})}")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(sync_tools_to_production())
