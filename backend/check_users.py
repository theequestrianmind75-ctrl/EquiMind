from pymongo import MongoClient

mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind"
client = MongoClient(mongo_url)
db = client[db_name]

print("👥 Checking users in database:\n")
user_count = db.users.count_documents({})
print(f"Total users: {user_count}")

if user_count > 0:
    users = list(db.users.find({}, {"email": 1, "name": 1, "_id": 0}))
    print("\nRegistered users:")
    for user in users:
        print(f"  • {user.get('email', 'N/A')} - {user.get('name', 'N/A')}")
else:
    print("\n❌ No users found in database!")
    print("\n💡 You need to create an account first:")
    print("   1. Go to the signup screen in the app")
    print("   2. Create a new account with email and password")

client.close()
