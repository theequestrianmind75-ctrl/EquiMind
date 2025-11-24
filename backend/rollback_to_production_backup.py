"""
EMERGENCY ROLLBACK SCRIPT
Use this to restore production data from safety backup if restoration fails
"""
import asyncio
import json
import os
from motor.motor_asyncio import AsyncIOMotorClient
from pathlib import Path
import sys

async def rollback_database(backup_timestamp: str = None):
    """Rollback to production backup"""
    
    # Get environment variables
    mongo_url = os.environ.get('MONGO_URL', 'mongodb://localhost:27017')
    db_name = os.environ.get('DB_NAME', 'equimind')
    
    print("🚨 EMERGENCY ROLLBACK MODE")
    print(f"Database: {db_name}")
    
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    # Find safety backups
    safety_backup_dir = Path(__file__).parent / 'safety_backups'
    
    if not safety_backup_dir.exists():
        print("❌ No safety backups found!")
        client.close()
        return False
    
    # List available backups
    backup_files = sorted(safety_backup_dir.glob('production_tools_*.json'), reverse=True)
    
    if not backup_files:
        print("❌ No production backups available!")
        client.close()
        return False
    
    print(f"\n📂 Available backups:")
    for i, backup in enumerate(backup_files, 1):
        timestamp = backup.stem.replace('production_tools_', '')
        print(f"   {i}. {timestamp}")
    
    # Use most recent or specified
    if backup_timestamp:
        tools_file = safety_backup_dir / f'production_tools_{backup_timestamp}.json'
        recs_file = safety_backup_dir / f'production_recs_{backup_timestamp}.json'
    else:
        tools_file = backup_files[0]
        timestamp = tools_file.stem.replace('production_tools_', '')
        recs_file = safety_backup_dir / f'production_recs_{timestamp}.json'
    
    print(f"\n🔄 Rolling back to: {timestamp}")
    
    # Load backup
    try:
        with open(tools_file, 'r') as f:
            tools = json.load(f)
        print(f"📦 Loaded {len(tools)} tools from backup")
        
        if recs_file.exists():
            with open(recs_file, 'r') as f:
                recs = json.load(f)
            print(f"📦 Loaded {len(recs)} recommendations from backup")
        else:
            recs = []
            print("⚠️  No recommendations backup found")
    except Exception as e:
        print(f"❌ Failed to load backup: {e}")
        client.close()
        return False
    
    # Confirm rollback
    print(f"\n⚠️  This will REPLACE current database with backup!")
    print(f"   Current tools: {await db.mental_strategies.count_documents({})}")
    print(f"   Backup tools: {len(tools)}")
    
    # Perform rollback
    try:
        # Delete current data
        await db.mental_strategies.delete_many({})
        print("🗑️  Cleared current tools")
        
        # Insert backup
        if tools:
            await db.mental_strategies.insert_many(tools)
            print(f"✅ Restored {len(tools)} tools")
        
        # Restore recommendations
        if recs:
            await db.recommendations.delete_many({})
            await db.recommendations.insert_many(recs)
            print(f"✅ Restored {len(recs)} recommendations")
        
        # Verify
        final_count = await db.mental_strategies.count_documents({})
        print(f"\n✅ ROLLBACK COMPLETE: {final_count} tools restored")
        
    except Exception as e:
        print(f"❌ ROLLBACK FAILED: {e}")
        client.close()
        return False
    
    client.close()
    return True

if __name__ == "__main__":
    # Allow specifying timestamp as argument
    timestamp = sys.argv[1] if len(sys.argv) > 1 else None
    success = asyncio.run(rollback_database(timestamp))
    exit(0 if success else 1)
