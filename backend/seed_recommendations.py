"""
Seed initial recommendations into the database
"""
from pymongo import MongoClient
from dotenv import load_dotenv
import os
from datetime import datetime
import uuid

load_dotenv()

mongo_url = os.getenv('MONGO_URL', 'mongodb://localhost:27017/')
db_name = os.getenv('DB_NAME', 'equimind_production')
client = MongoClient(mongo_url)
db = client[db_name]

# Initial recommendations based on your equestrian expertise
initial_recommendations = [
    {
        "text": "🧘 Try 'Box Breath' or '4:8 Tension Melt Exhale' from BODY RESET before your next ride to regulate your nervous system.",
        "trigger_condition": "high_anxiety",
        "priority": 10
    },
    {
        "text": "💡 Consider practicing 'The Safe Seat Reset' during rides when anxiety spikes - it activates your parasympathetic nervous system.",
        "trigger_condition": "high_anxiety",
        "priority": 9
    },
    {
        "text": "🎯 Your anxiety increased during the ride. Try 'Cognitive Grounding Through Sensory Anchors' (identify 3 things you see, 2 things you feel) to stay present.",
        "trigger_condition": "anxiety_increased",
        "priority": 8
    },
    {
        "text": "💭 Practice 'Thought Labeling + Releasing' - name the anxious thought and separate from it: 'That's an anxious thought, I don't have to act on it.'",
        "trigger_condition": "anxiety_increased",
        "priority": 7
    },
    {
        "text": "💪 Build confidence with 'Micro-Goal Cueing' - set small achievable goals like '5 steady strides' or 'one smooth corner.'",
        "trigger_condition": "low_confidence",
        "priority": 10
    },
    {
        "text": "🌟 Try EFT Tapping sequences specifically for confidence building - research shows tapping reduces cortisol by 24%.",
        "trigger_condition": "low_confidence",
        "priority": 9
    },
    {
        "text": "🔄 Your confidence dropped during this ride. This is normal! Review what went well first, then identify one specific skill to practice next time.",
        "trigger_condition": "confidence_decreased",
        "priority": 8
    },
    {
        "text": "📚 Consider the 'Peripheral Vision Expansion' technique - widening your gaze reduces amygdala activation and improves calm focus.",
        "trigger_condition": "confidence_decreased",
        "priority": 7
    },
    {
        "text": "⚠️ High anxiety + low confidence pattern detected. This is a common cycle. Start with 'Breath-Sync Regulation' (3-count inhale, 4-5 count exhale) to interrupt the stress response.",
        "trigger_condition": "high_anxiety_low_confidence",
        "priority": 10
    },
    {
        "text": "🐴 Practice 'Co-Regulation' - match your breathing to your horse's rhythm. Research shows horses' calm state can regulate rider's nervous system.",
        "trigger_condition": "high_anxiety_low_confidence",
        "priority": 9
    },
    {
        "text": "🐎 Your horse's high energy may be overwhelming your confidence. Practice 'Interoception Check-In' - notice where tension lives in your body and soften by 5%.",
        "trigger_condition": "high_horse_energy_low_confidence",
        "priority": 8
    },
    {
        "text": "💡 Use 'Dual Awareness' statements: 'My horse has energy AND I can stay grounded.' This DBT technique prevents catastrophic thinking.",
        "trigger_condition": "high_horse_energy_low_confidence",
        "priority": 7
    },
    {
        "text": "👁️ Your horse's focus was low. Try the 'Micro-Shake Release' for yourself between exercises - releasing your tension helps your horse regulate too.",
        "trigger_condition": "low_horse_focus",
        "priority": 6
    },
    {
        "text": "🎯 Consider shorter, more varied exercises next session. Horses' attention spans are 10-15 minutes - break training into smaller chunks.",
        "trigger_condition": "low_horse_focus",
        "priority": 5
    },
    {
        "text": "✨ Excellent session! Low anxiety + high confidence. Document what you did in pre-ride prep - this is your optimal state formula.",
        "trigger_condition": "optimal_performance",
        "priority": 10
    },
    {
        "text": "🎊 Consider this your 'flow state' session. Research shows this anxiety-confidence combo predicts peak performance. Repeat your pre-ride routine!",
        "trigger_condition": "optimal_performance",
        "priority": 9
    },
    {
        "text": "📈 Great progress! Your anxiety decreased AND confidence increased. You're building emotional resilience - this is the goal of mental training.",
        "trigger_condition": "good_improvement",
        "priority": 8
    },
    {
        "text": "🐴 Your horse showed optimal metrics (balanced energy, good focus, strong responsiveness). Your mental state likely contributed to this - keep doing what you're doing!",
        "trigger_condition": "optimal_horse_metrics",
        "priority": 7
    },
    {
        "text": "💭 Great job completing your session! Review the Rider Tools library for techniques that match your specific goals.",
        "trigger_condition": "default",
        "priority": 1
    },
    {
        "text": "📊 Track patterns over multiple sessions to identify your optimal pre-ride preparation routine.",
        "trigger_condition": "default",
        "priority": 1
    },
]

print("🌱 Seeding recommendations...")

# Clear existing recommendations
db.recommendations.delete_many({})
print("✨ Cleared existing recommendations")

# Insert new recommendations
for rec in initial_recommendations:
    rec_id = str(uuid.uuid4())
    rec_dict = {
        "_id": rec_id,
        "id": rec_id,
        "text": rec["text"],
        "trigger_condition": rec["trigger_condition"],
        "priority": rec["priority"],
        "active": True,
        "created_at": datetime.utcnow()
    }
    db.recommendations.insert_one(rec_dict)

print(f"✅ Successfully seeded {len(initial_recommendations)} recommendations")

# Show summary by trigger condition
print("\n📊 Recommendations by trigger condition:")
pipeline = [
    {"$group": {"_id": "$trigger_condition", "count": {"$sum": 1}}},
    {"$sort": {"count": -1}}
]
for result in db.recommendations.aggregate(pipeline):
    print(f"   - {result['_id']}: {result['count']} recommendations")

print("\n✅ Seeding complete! You can now edit these recommendations through the admin panel.")
