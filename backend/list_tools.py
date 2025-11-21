from pymongo import MongoClient
import os

mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')
client = MongoClient(mongo_url)
db = client[db_name]

print("📚 Available Tools by Category:\n")

categories = ['BODY RESET', 'Breathing/HRV', 'Mindfulness & Flow', 'Tapping/EFT']

for category in categories:
    tools = list(db.mental_strategies.find(
        {"category": {"$regex": category, "$options": "i"}},
        {"name": 1, "duration_minutes": 1}
    ).limit(15))
    
    print(f"\n{category} ({len(tools)} shown):")
    for tool in tools:
        duration = tool.get('duration_minutes', '?')
        print(f"  • {tool['name']} ({duration} min)")

client.close()
