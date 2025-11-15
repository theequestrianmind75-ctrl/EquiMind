"""
Migrate data from local development database to production MongoDB Atlas
"""
from pymongo import MongoClient
from dotenv import load_dotenv
import os
from urllib.parse import quote_plus

load_dotenv()

# Local database connection
local_mongo_url = 'mongodb://localhost:27017/'
local_db_name = 'test_database'

# Production MongoDB Atlas connection
# URL encode special characters in username and password
prod_username = quote_plus('equimind_admin')
prod_password = quote_plus('SecurePass2024!')
prod_mongo_url = f'mongodb+srv://{prod_username}:{prod_password}@cluster0.wzahss.mongodb.net/?appName=Cluster0'
prod_db_name = 'equimind_production'

print("🔄 Starting database migration to production...")
print(f"📍 Source: Local MongoDB ({local_db_name})")
print(f"📍 Destination: MongoDB Atlas ({prod_db_name})")

try:
    # Connect to local database
    print("\n🔌 Connecting to local database...")
    local_client = MongoClient(local_mongo_url)
    local_db = local_client[local_db_name]
    
    # Connect to production database
    print("🔌 Connecting to production database...")
    prod_client = MongoClient(prod_mongo_url)
    prod_db = prod_client[prod_db_name]
    
    # Test connection
    prod_client.admin.command('ping')
    print("✅ Successfully connected to MongoDB Atlas!")
    
    # Get collections to migrate
    collections_to_migrate = ['mental_strategies', 'users', 'sessions']
    
    migration_summary = {}
    
    for collection_name in collections_to_migrate:
        print(f"\n📦 Migrating collection: {collection_name}")
        
        # Get data from local
        local_collection = local_db[collection_name]
        local_data = list(local_collection.find({}))
        
        print(f"   📊 Found {len(local_data)} documents in local database")
        
        if len(local_data) == 0:
            print(f"   ⏭️  Skipping empty collection")
            migration_summary[collection_name] = 0
            continue
        
        # Clear production collection (fresh start)
        prod_collection = prod_db[collection_name]
        delete_result = prod_collection.delete_many({})
        print(f"   🗑️  Cleared {delete_result.deleted_count} existing documents from production")
        
        # Insert data to production
        insert_result = prod_collection.insert_many(local_data)
        print(f"   ✅ Inserted {len(insert_result.inserted_ids)} documents to production")
        
        migration_summary[collection_name] = len(insert_result.inserted_ids)
    
    # Verify migration
    print("\n\n📊 Migration Summary:")
    print("=" * 50)
    for collection_name, count in migration_summary.items():
        prod_count = prod_db[collection_name].count_documents({})
        print(f"   {collection_name}: {count} documents migrated, {prod_count} verified in production")
    
    # Verify categories in mental_strategies
    if 'mental_strategies' in migration_summary and migration_summary['mental_strategies'] > 0:
        print("\n📋 Category Breakdown:")
        categories = prod_db.mental_strategies.distinct('category')
        for cat in sorted(categories):
            count = prod_db.mental_strategies.count_documents({'category': cat})
            print(f"   - {cat}: {count} tools")
    
    print("\n✅ Migration completed successfully!")
    print(f"\n🔗 Production Database Connection String:")
    print(f"   mongodb+srv://theequestrianmind75%40gmail.com:Jumpers75%21@cluster0.wzahss.mongodb.net/equimind_production?appName=Cluster0")
    
    # Close connections
    local_client.close()
    prod_client.close()
    
except Exception as e:
    print(f"\n❌ Migration failed with error:")
    print(f"   {str(e)}")
    exit(1)
