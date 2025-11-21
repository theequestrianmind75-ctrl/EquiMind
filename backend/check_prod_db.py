from pymongo import MongoClient
import os

mongo_url = os.getenv('MONGO_URL')
client = MongoClient(mongo_url)

# Check both databases
for db_name in ['equimind', 'equimind_production']:
    db = client[db_name]
    print(f"\n📦 Database: {db_name}")
    
    strategies_count = db.mental_strategies.count_documents({})
    print(f"   mental_strategies: {strategies_count} documents")
    
    if strategies_count > 0:
        # Show sample
        sample = db.mental_strategies.find_one({}, {"name": 1, "category": 1})
        print(f"   Sample: {sample.get('name', 'N/A')} | {sample.get('category', 'N/A')}")
    
    recs_count = db.recommendations.count_documents({})
    print(f"   recommendations: {recs_count} documents")
    
    sessions_count = db.sessions.count_documents({})
    print(f"   sessions: {sessions_count} documents")

client.close()
