from pymongo import MongoClient
import os

mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')
client = MongoClient(mongo_url)
db = client[db_name]

print("📊 Database Stats:")
total = db.mental_strategies.count_documents({})
print(f"Total tools: {total}\n")

if total > 0:
    print("📚 Sample Tools:\n")
    tools = list(db.mental_strategies.find({}, {"name": 1, "category": 1, "duration_minutes": 1}).limit(20))
    
    for tool in tools:
        name = tool.get('name', 'Unknown')
        category = tool.get('category', 'Unknown')
        duration = tool.get('duration_minutes', '?')
        print(f"  • {name} | {category} | {duration} min")
    
    print("\n📋 All Categories:")
    categories = db.mental_strategies.distinct("category")
    for cat in sorted(categories):
        count = db.mental_strategies.count_documents({"category": cat})
        print(f"  • {cat}: {count} tools")
else:
    print("❌ No tools found in database!")

client.close()
