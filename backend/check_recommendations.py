from pymongo import MongoClient

mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind"
client = MongoClient(mongo_url)
db = client[db_name]

print("📊 Checking Recommendations Database:\n")
count = db.recommendations.count_documents({})
print(f"Total recommendations: {count}")

if count > 0:
    recs = list(db.recommendations.find({}, {"trigger_condition": 1, "text": 1, "_id": 0}).limit(5))
    print("\nSample recommendations:")
    for rec in recs:
        print(f"  - {rec.get('trigger_condition')}: {rec.get('text')[:60]}...")
else:
    print("\n❌ Recommendations database is EMPTY - this is why they're not showing up!")

client.close()
