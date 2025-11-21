from pymongo import MongoClient
import os

mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')
client = MongoClient(mongo_url)
db = client[db_name]

print("📊 Current Recommendations Coverage:\n")

# Group by trigger condition
pipeline = [
    {"$group": {"_id": "$trigger_condition", "count": {"$sum": 1}}},
    {"$sort": {"_id": 1}}
]

for result in db.recommendations.aggregate(pipeline):
    trigger = result['_id']
    count = result['count']
    print(f"✓ {trigger}: {count} recommendation(s)")
    
print("\n🔍 Checking for suggested_tool_names field:")
sample = db.recommendations.find_one({})
if sample and 'suggested_tool_names' in sample:
    print(f"✓ suggested_tool_names field EXISTS")
    print(f"  Example: {sample.get('suggested_tool_names', [])}")
else:
    print("❌ suggested_tool_names field MISSING - tools won't appear in 'Suggested Tools to Try'")

print("\n📈 Trigger Coverage Analysis:")
all_triggers = [
    'high_anxiety',
    'anxiety_increased', 
    'low_confidence',
    'confidence_decreased',
    'high_anxiety_low_confidence',
    'high_horse_energy_low_confidence',
    'low_horse_focus',
    'optimal_performance',
    'good_improvement',
    'optimal_horse_metrics',
    'default'
]

existing = [r['_id'] for r in db.recommendations.aggregate(pipeline)]
for trigger in all_triggers:
    status = "✓" if trigger in existing else "❌"
    print(f"{status} {trigger}")

client.close()
