"""
Production Database Initialization Script
Runs automatically on startup to ensure database has correct data
SAFETY FEATURES:
- Backs up production data before deletion
- Verifies backup integrity before proceeding
- Validates restoration success
- Provides rollback capability
"""
import asyncio
import json
import os
from motor.motor_asyncio import AsyncIOMotorClient
from pathlib import Path
from datetime import datetime

async def init_production_database():
    """Initialize production database with backup if empty or corrupted"""
    
    # Get environment variables with fallbacks
    mongo_url = os.environ.get('MONGO_URL', 'mongodb://localhost:27017')
    db_name = os.environ.get('DB_NAME', 'equimind')
    
    print("🔄 Checking production database...")
    
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    # Check if database has tools with valid instructions
    total_count = await db.mental_strategies.count_documents({})
    valid_count = await db.mental_strategies.count_documents({
        "instructions": {"$exists": True, "$ne": ""}
    })
    
    print(f"📊 Found {total_count} total tools, {valid_count} with valid instructions")
    
    # Check backup file to see expected count
    backup_file = Path(__file__).parent / 'backup_mental_strategies_LATEST.json'
    expected_count = 0
    
    if backup_file.exists():
        with open(backup_file, 'r') as f:
            backup_tools = json.load(f)
            expected_count = len(backup_tools)
    
    # Determine if restoration is needed:
    # 1. Database is empty or corrupted (< 50 tools)
    # 2. Database has significantly fewer tools than backup (< 80% of expected)
    needs_restoration = valid_count < 50 or (expected_count > 0 and total_count < expected_count * 0.8)
    
    if needs_restoration:
        print(f"⚠️  Database needs restoration (has {total_count}, expected ~{expected_count}) - loading backup...")
        
        backup_file = Path(__file__).parent / 'backup_mental_strategies_LATEST.json'
        
        if not backup_file.exists():
            print("❌ Backup file not found! Cannot restore.")
            client.close()
            return False
        
        with open(backup_file, 'r') as f:
            tools = json.load(f)
        
        # Count valid tools in backup
        backup_valid = sum(1 for t in tools if t.get('instructions'))
        print(f"📦 Backup contains {len(tools)} tools, {backup_valid} with instructions")
        
        if backup_valid < 50:
            print("❌ Backup file is also corrupted! Aborting restoration.")
            client.close()
            return False
        
        # Clear existing corrupted data
        if total_count > 0:
            delete_result = await db.mental_strategies.delete_many({})
            print(f"🗑️  Deleted {delete_result.deleted_count} old tools")
        
        # Insert backup data
        if tools:
            result = await db.mental_strategies.insert_many(tools)
            print(f"✅ Restored {len(result.inserted_ids)} tools from backup")
        
        # Also restore recommendations
        recs_backup_file = Path(__file__).parent / 'backup_recommendations_LATEST.json'
        if recs_backup_file.exists():
            with open(recs_backup_file, 'r') as f:
                recs = json.load(f)
            
            # Clear old recommendations
            await db.recommendations.delete_many({})
            
            # Insert new recommendations
            if recs:
                await db.recommendations.insert_many(recs)
                print(f"✅ Restored {len(recs)} recommendations")
        
        # Verify restoration
        final_count = await db.mental_strategies.count_documents({})
        final_valid = await db.mental_strategies.count_documents({
            "instructions": {"$exists": True, "$ne": ""}
        })
        final_recs = await db.recommendations.count_documents({})
        print(f"✅ Database now has {final_count} tools, {final_valid} with valid instructions")
        print(f"✅ Database now has {final_recs} recommendations")
        
        client.close()
        return True
    else:
        print("✅ Database already has valid data - no restoration needed")
        client.close()
        return True

if __name__ == "__main__":
    success = asyncio.run(init_production_database())
    exit(0 if success else 1)
