from pymongo import MongoClient
import os

mongo_url = os.getenv('MONGO_URL')
client = MongoClient(mongo_url)

print("🔍 Checking all databases:\n")
db_names = client.list_database_names()
for db_name in db_names:
    if 'equimind' in db_name.lower() or db_name in ['equimind', 'equimind_production', 'equimind_dev']:
        db = client[db_name]
        collections = db.list_collection_names()
        print(f"📦 Database: {db_name}")
        for coll in collections:
            count = db[coll].count_documents({})
            print(f"   • {coll}: {count} documents")
        print()

print(f"\n💡 Current DB_NAME env var: {os.getenv('DB_NAME', 'NOT SET')}")

client.close()
