from pymongo import MongoClient
import json
from datetime import datetime
from dotenv import load_dotenv
import os

load_dotenv()

# Connect to MongoDB
mongo_url = os.getenv('MONGO_URL', 'mongodb://localhost:27017/')
client = MongoClient(mongo_url)
db = client['equimind_mobile']

# Create backup
backup_data = {
    'backup_timestamp': datetime.now().isoformat(),
    'mental_strategies': list(db.mental_strategies.find({})),
    'users': list(db.users.find({})),
    'sessions': list(db.sessions.find({}))
}

# Convert ObjectId to string for JSON serialization
def convert_objectid(obj):
    if isinstance(obj, dict):
        return {k: convert_objectid(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_objectid(item) for item in obj]
    elif hasattr(obj, '__str__') and type(obj).__name__ == 'ObjectId':
        return str(obj)
    return obj

backup_data = convert_objectid(backup_data)

# Save backup
backup_filename = f'database_backup_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json'
with open(backup_filename, 'w') as f:
    json.dump(backup_data, f, indent=2)

print(f"✅ Database backup created: {backup_filename}")
print(f"📊 Backed up collections:")
print(f"   - mental_strategies: {len(backup_data['mental_strategies'])} documents")
print(f"   - users: {len(backup_data['users'])} documents")
print(f"   - sessions: {len(backup_data['sessions'])} documents")
