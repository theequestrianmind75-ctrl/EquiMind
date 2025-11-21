from pymongo import MongoClient
import os

# Read from .env
with open('/app/backend/.env', 'r') as f:
    for line in f:
        if 'DB_NAME' in line and '=' in line:
            db_name = line.split('=')[1].strip().strip('"')
            break

mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
client = MongoClient(mongo_url)
db = client[db_name]

print(f"✅ Connected to: {db_name}")
print("="*60)

tools = db.mental_strategies.count_documents({})
recs = db.recommendations.count_documents({})
users = db.users.count_documents({})
sessions = db.sessions.count_documents({})

print(f"📚 Mental Strategies (Tools): {tools}")
print(f"💡 Recommendations: {recs}")
print(f"👥 Users: {users}")
print(f"📊 Sessions: {sessions}")
print("="*60)

if tools == 136 and recs == 20:
    print("✅ PRODUCTION DATABASE ACTIVE - All data present!")
else:
    print(f"⚠️  Expected 136 tools and 20 recommendations")

client.close()
