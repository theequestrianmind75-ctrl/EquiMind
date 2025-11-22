from pymongo import MongoClient

mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind_production"
client = MongoClient(mongo_url)
db = client[db_name]

print("📋 EXACT Category Names in Database:\n")

categories = db.mental_strategies.distinct("category")
for cat in sorted(categories):
    count = db.mental_strategies.count_documents({"category": cat})
    print(f'  "{cat}" - {count} tools')

print("\n\n📝 Sample Tool Names by Category:\n")

for cat in sorted(categories):
    print(f"--- {cat} ---")
    tools = list(db.mental_strategies.find(
        {"category": cat},
        {"name": 1, "_id": 0}
    ).limit(5))
    
    for tool in tools:
        print(f"  • {tool['name']}")
    print()

client.close()
