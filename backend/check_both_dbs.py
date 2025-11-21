from pymongo import MongoClient

mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
client = MongoClient(mongo_url)

print("="*60)
print("DATABASE COMPARISON")
print("="*60)

for db_name in ['equimind', 'equimind_production']:
    db = client[db_name]
    print(f"\n📦 {db_name.upper()}")
    print("-"*60)
    
    tools_count = db.mental_strategies.count_documents({})
    print(f"   Mental Strategies: {tools_count}")
    
    recs_count = db.recommendations.count_documents({})
    print(f"   Recommendations: {recs_count}")
    
    users_count = db.users.count_documents({})
    print(f"   Users: {users_count}")
    
    sessions_count = db.sessions.count_documents({})
    print(f"   Sessions: {sessions_count}")

print("\n" + "="*60)
print(f"CURRENTLY CONFIGURED: {mongo_url.split('@')[1].split('?')[0]}")
print("="*60)

# Check backend .env
import os
with open('/app/backend/.env', 'r') as f:
    for line in f:
        if 'DB_NAME' in line:
            print(f"Backend .env setting: {line.strip()}")

client.close()
