from pymongo import MongoClient

mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind"
client = MongoClient(mongo_url)
db = client[db_name]

print("📊 Database Stats:")
total = db.mental_strategies.count_documents({})
print(f"Total tools: {total}\n")

if total > 0:
    print("📋 All Categories with tool counts:")
    categories = db.mental_strategies.distinct("category")
    for cat in sorted(categories):
        count = db.mental_strategies.count_documents({"category": cat})
        print(f"  • {cat}: {count} tools")
    
    print("\n📚 Sample Tools from Each Category:\n")
    for cat in sorted(categories)[:4]:  # Show first 4 categories
        print(f"--- {cat} ---")
        tools = list(db.mental_strategies.find(
            {"category": cat},
            {"name": 1, "duration_minutes": 1}
        ).limit(5))
        
        for tool in tools:
            duration = tool.get('duration_minutes', '?')
            print(f"  • {tool['name']} ({duration} min)")
        print()

client.close()
