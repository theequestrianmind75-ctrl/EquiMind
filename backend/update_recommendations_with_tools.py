"""
Update recommendations with suggested tool names
"""
from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()

mongo_url = os.getenv('MONGO_URL', 'mongodb://localhost:27017/')
db_name = os.getenv('DB_NAME', 'equimind_production')
client = MongoClient(mongo_url)
db = client[db_name]

# Map trigger conditions to suggested tools
tool_suggestions = {
    "high_anxiety": [
        "Box Breath (Modified for Riding)",
        "4:8 Tension Melt Exhale",
        "The Safe Seat Reset (Somatic Trauma Model + Polyvagal)"
    ],
    "anxiety_increased": [
        "Cognitive Grounding Through Sensory Anchors (CBT)",
        "Thought Labelling + Releasing (CBT + ACT)",
        "Peripheral Vision Expansion (Nervous System Regulation)"
    ],
    "low_confidence": [
        "Micro-Goal Cueing (Sports Psychology)",
        "Pelvic 'Float' Reset",
        "Breath-Per-Stride Sync"
    ],
    "confidence_decreased": [
        "Peripheral Vision Expansion (Nervous System Regulation)",
        "The 'Downward Breath' (Polyvagal Down-Regulation)",
        "Micro-Goal Cueing (Sports Psychology)"
    ],
    "high_anxiety_low_confidence": [
        "Breath-Sync Regulation (Somatic + HRV Training)",
        "Co-Regulation Cue (Polyvagal + Equine Behavior Science)",
        "The 'Safe Seat Reset' (Somatic Trauma Model + Polyvagal)"
    ],
    "high_horse_energy_low_confidence": [
        "Interoception Check-In (Somatic + Mind-Body Integration)",
        "Dual Awareness Cue (DBT Distress Tolerance)",
        "The 'Safe Seat' Reset (Somatic Trauma Model + Polyvagal)"
    ],
    "low_horse_focus": [
        "Micro-Shake Release",
        "Eye-Softening Peripheral Vision",
        "Glute/Thigh Release Scan"
    ],
    "optimal_performance": [
        "Breath-Per-Stride Sync",
        "Heart-Space Breath",
        "Pelvic 'Float' Reset"
    ],
    "good_improvement": [
        "Breath-Per-Stride Sync",
        "Heart-Space Breath",
        "Sternum Drop Reset"
    ],
    "optimal_horse_metrics": [
        "Co-Regulation Cue (Polyvagal + Equine Behavior Science)",
        "Breath-Per-Stride Sync",
        "Pelvic 'Float' Reset"
    ],
    "default": [
        "Box Breath (Modified for Riding)",
        "Cognitive Grounding Through Sensory Anchors (CBT)",
        "Micro-Goal Cueing (Sports Psychology)"
    ],
}

print("🔧 Updating recommendations with suggested tools...")

updated_count = 0
for trigger, tools in tool_suggestions.items():
    result = db.recommendations.update_many(
        {"trigger_condition": trigger},
        {"$set": {"suggested_tool_names": tools}}
    )
    updated_count += result.modified_count
    print(f"   ✓ {trigger}: {result.modified_count} recommendations updated with {len(tools)} tool suggestions")

print(f"\n✅ Updated {updated_count} recommendations with tool suggestions")

# Verify
print("\n📊 Verification:")
recs_with_tools = db.recommendations.count_documents({"suggested_tool_names": {"$exists": True, "$ne": []}})
total_recs = db.recommendations.count_documents({})
print(f"   {recs_with_tools}/{total_recs} recommendations now have tool suggestions")
