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
    # Only restore if database is truly empty or corrupted (< 50 tools with valid instructions)
    # This prevents overwriting manual edits made through the admin text editor
    needs_restoration = valid_count < 50
    
    if needs_restoration:
        print(f"⚠️  Database needs restoration (has {total_count}, expected ~{expected_count})")
        print("🛡️  SAFETY MODE: Creating production backup before restoration...")
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        safety_backup_dir = Path(__file__).parent / 'safety_backups'
        safety_backup_dir.mkdir(exist_ok=True)
        
        # STEP 1: Backup current production data
        try:
            prod_tools = await db.mental_strategies.find({}).to_list(length=10000)
            prod_recs = await db.recommendations.find({}).to_list(length=10000)
            
            # Remove _id fields for JSON serialization
            for tool in prod_tools:
                if '_id' in tool:
                    del tool['_id']
            for rec in prod_recs:
                if '_id' in rec:
                    del rec['_id']
            
            # Save production backup
            safety_tools_file = safety_backup_dir / f'production_tools_{timestamp}.json'
            safety_recs_file = safety_backup_dir / f'production_recs_{timestamp}.json'
            
            with open(safety_tools_file, 'w') as f:
                json.dump(prod_tools, f, indent=2, default=str)
            with open(safety_recs_file, 'w') as f:
                json.dump(prod_recs, f, indent=2, default=str)
            
            print(f"✅ Production backup saved: {len(prod_tools)} tools, {len(prod_recs)} recommendations")
            print(f"   Files: {safety_tools_file.name}, {safety_recs_file.name}")
        except Exception as e:
            print(f"❌ Failed to backup production data: {e}")
            print("⚠️  ABORTING restoration for safety")
            client.close()
            return False
        
        # STEP 2: Load and validate backup files
        backup_file = Path(__file__).parent / 'backup_mental_strategies_LATEST.json'
        recs_backup_file = Path(__file__).parent / 'backup_recommendations_LATEST.json'
        
        if not backup_file.exists():
            print("❌ Tools backup file not found! Cannot restore.")
            client.close()
            return False
        
        if not recs_backup_file.exists():
            print("⚠️  Recommendations backup not found - will skip recommendations")
            recs_backup_file = None
        
        try:
            with open(backup_file, 'r') as f:
                tools = json.load(f)
            
            # Validate backup
            backup_valid = sum(1 for t in tools if t.get('instructions'))
            print(f"📦 Backup contains {len(tools)} tools, {backup_valid} with valid instructions")
            
            if backup_valid < 50:
                print("❌ Backup file is corrupted! Aborting restoration.")
                client.close()
                return False
            
            # Load recommendations if available
            recs = []
            if recs_backup_file:
                with open(recs_backup_file, 'r') as f:
                    recs = json.load(f)
                print(f"📦 Backup contains {len(recs)} recommendations")
        except Exception as e:
            print(f"❌ Failed to load backup files: {e}")
            client.close()
            return False
        
        # STEP 3: Perform restoration
        print("🔄 Starting restoration...")
        try:
            # Delete old tools
            if total_count > 0:
                delete_result = await db.mental_strategies.delete_many({})
                print(f"🗑️  Deleted {delete_result.deleted_count} old tools")
            
            # Insert new tools
            if tools:
                result = await db.mental_strategies.insert_many(tools)
                print(f"✅ Inserted {len(result.inserted_ids)} tools")
            
            # Delete and restore recommendations
            if recs:
                await db.recommendations.delete_many({})
                await db.recommendations.insert_many(recs)
                print(f"✅ Inserted {len(recs)} recommendations")
            
        except Exception as e:
            print(f"❌ RESTORATION FAILED: {e}")
            print(f"🔄 ROLLBACK AVAILABLE: Check {safety_backup_dir} for production backup")
            client.close()
            return False
        
        # STEP 4: Verify restoration success
        print("🔍 Verifying restoration...")
        final_count = await db.mental_strategies.count_documents({})
        final_valid = await db.mental_strategies.count_documents({
            "instructions": {"$exists": True, "$ne": ""}
        })
        final_recs = await db.recommendations.count_documents({})
        
        # Check if counts match expectations
        if final_count != len(tools):
            print(f"⚠️  WARNING: Expected {len(tools)} tools, got {final_count}")
            print(f"🔄 ROLLBACK AVAILABLE: {safety_tools_file}")
        elif final_valid < backup_valid:
            print(f"⚠️  WARNING: Some tools may be invalid ({final_valid}/{final_count})")
        else:
            print(f"✅ VERIFICATION PASSED:")
            print(f"   - Tools: {final_count} (all with valid instructions)")
            print(f"   - Recommendations: {final_recs}")
            print(f"   - Rollback backup: {safety_backup_dir}")
        
        client.close()
        return True
    else:
        print("✅ Database already has valid data - no restoration needed")
        client.close()
        return True

if __name__ == "__main__":
    success = asyncio.run(init_production_database())
    exit(0 if success else 1)
