from pymongo import MongoClient
from dotenv import load_dotenv
import os
import json
from datetime import datetime

load_dotenv()

# Connect to MongoDB
mongo_url = os.getenv('MONGO_URL', 'mongodb://localhost:27017/')
db_name = os.getenv('DB_NAME', 'test_database')
client = MongoClient(mongo_url)
db = client[db_name]

# New tools from "Breathing Heart Rate Variability.docx"
breathing_tools = [
    {
        "name": "Breath-Sync Regulation (Somatic + HRV Training)",
        "category": "Breathing / HRV",
        "instructions": "Inhale for 3 steps → exhale for 4–5 steps. Let the exhale 'melt' into the saddle.",
        "duration_minutes": 1,
    },
    {
        "name": "Body Scan in Motion (Mindfulness-Based Stress Reduction)",
        "category": "Breathing / HRV",
        "instructions": "Notice seat bones, thigh tension, jaw, shoulders. Release tension deliberately into the saddle.",
        "duration_minutes": 2,
    },
    {
        "name": "Cognitive Grounding Through Sensory Anchors (CBT)",
        "category": "Breathing / HRV",
        "instructions": "Identify 3 things you see, 2 things you physically feel in the saddle, 1 sound in the environment.",
        "duration_minutes": 1,
    },
    {
        "name": "The 'Safe Seat' Reset (Somatic Trauma Model + Polyvagal)",
        "category": "Breathing / HRV",
        "instructions": "Deepen your breath. Let your weight drop into thighs + stirrups. Feel the horse's back move under you.",
        "duration_minutes": 1,
    },
    {
        "name": "Dual Awareness Cue (DBT Distress Tolerance)",
        "category": "Breathing / HRV",
        "instructions": "Say internally: 'My body is tense AND my horse is steady.'",
        "duration_minutes": 1,
    },
    {
        "name": "Micro-Goal Cueing (Sports Psychology)",
        "category": "Breathing / HRV",
        "instructions": "Set micro-goals like: 'Next 5 strides: steady hands.' or 'Next corner: soft seat.'",
        "duration_minutes": 1,
    },
    {
        "name": "Thought Labelling + Releasing (CBT + ACT)",
        "category": "Breathing / HRV",
        "instructions": "Identify the thought → name it → separate from it. For example: 'That's an anxious thought.' 'I don't have to act on it.'",
        "duration_minutes": 1,
    },
    {
        "name": "Peripheral Vision Expansion (Nervous System Regulation)",
        "category": "Breathing / HRV",
        "instructions": "Widen your gaze to include arena walls, sky line, etc.",
        "duration_minutes": 1,
    },
    {
        "name": "Interoception Check-In (Somatic + Mind-Body Integration)",
        "category": "Breathing / HRV",
        "instructions": "Ask yourself: 'Where is tension?' 'What is my breath doing?' 'Can I soften by 5%?'",
        "duration_minutes": 1,
    },
    {
        "name": "Co-Regulation Cue (Polyvagal + Equine Behavior Science)",
        "category": "Breathing / HRV",
        "instructions": "Match your breathing to the horse's exhale rhythm. Feel the sway of the walk. Visualize energy flowing downward.",
        "duration_minutes": 2,
    },
]

# New tools from "Body reset.docx"
body_reset_tools = [
    {
        "name": "4:8 Tension Melt Exhale",
        "category": "BODY RESET",
        "instructions": "Inhale for 4. Long exhale for 8. Imagine tension draining out of your shoulders and seat.",
        "duration_minutes": 1,
    },
    {
        "name": "Pelvic 'Float' Reset",
        "category": "BODY RESET",
        "instructions": "At walk, allow your pelvis to follow the horse's movement. Visualize the motion as a figure-8. Let your seat bones get heavy.",
        "duration_minutes": 1,
    },
    {
        "name": "Rib Cage Expansion Breath",
        "category": "BODY RESET",
        "instructions": "Inhale sideways into the ribs. Feel ribs widen into thighs. Exhale to soften chest + sternum.",
        "duration_minutes": 1,
    },
    {
        "name": "Somatic Swallow Release",
        "category": "BODY RESET",
        "instructions": "Inhale. Slow conscious swallow. Soft exhale.",
        "duration_minutes": 1,
    },
    {
        "name": "3-Point Contact Grounding",
        "category": "BODY RESET",
        "instructions": "Bring attention to 3 body-horse contact points: Seat bones, Inner calf, Reins through fingers. Exhale slowly.",
        "duration_minutes": 1,
    },
    {
        "name": "Breath-Per-Stride Sync",
        "category": "BODY RESET",
        "instructions": "Pick a rhythm: Inhale 2 strides / Exhale 3 strides. Or inhale 3 / exhale 4 for anxious riders.",
        "duration_minutes": 1,
    },
    {
        "name": "'Soft Jaw–Soft Horse' Release",
        "category": "BODY RESET",
        "instructions": "Loosen your jaw. Let tongue rest on the floor of your mouth. Exhale with a tiny sigh.",
        "duration_minutes": 1,
    },
    {
        "name": "Sternum Drop Reset",
        "category": "BODY RESET",
        "instructions": "Soften the sternum just 2%. Let shoulders widen instead of lift. Breathe gently.",
        "duration_minutes": 1,
    },
    {
        "name": "Low & Slow Belly Breath",
        "category": "BODY RESET",
        "instructions": "One hand on your thigh. Send breath into the lower belly. Exhale downwards through seat.",
        "duration_minutes": 1,
    },
    {
        "name": "Shoulder Blade 'Slide Down' Reset",
        "category": "BODY RESET",
        "instructions": "Slide shoulder blades into back pockets. Exhale.",
        "duration_minutes": 1,
    },
    {
        "name": "Micro-Shake Release",
        "category": "BODY RESET",
        "instructions": "While walking, allow one leg to shake out briefly. Or shake out wrists.",
        "duration_minutes": 1,
    },
    {
        "name": "Heart-Space Breath",
        "category": "BODY RESET",
        "instructions": "Inhale as if breathing into the space behind your collarbones. Exhale through the chest downward.",
        "duration_minutes": 1,
    },
    {
        "name": "Box Breath (Modified for Riding)",
        "category": "BODY RESET",
        "instructions": "Inhale 4. Hold 2. Exhale 6. Hold 2.",
        "duration_minutes": 1,
    },
    {
        "name": "Glute/Thigh Release Scan",
        "category": "BODY RESET",
        "instructions": "On exhale, check: 'Am I gripping?' Release thighs by 10%. Let seat deepen.",
        "duration_minutes": 1,
    },
    {
        "name": "The 'Downward Breath' (Polyvagal Down-Regulation)",
        "category": "BODY RESET",
        "instructions": "Inhale up the spine. Exhale down into the saddle.",
        "duration_minutes": 1,
    },
    {
        "name": "Slow Blink Reset",
        "category": "BODY RESET",
        "instructions": "Inhale. Slow soft blink. Exhale.",
        "duration_minutes": 1,
    },
    {
        "name": "Side-Body Stretch Breath",
        "category": "BODY RESET",
        "instructions": "Inhale and lengthen right side. Exhale soften. Repeat on left.",
        "duration_minutes": 1,
    },
    {
        "name": "Gentle 'Hum' Exhale",
        "category": "BODY RESET",
        "instructions": "Exhale with a low hum.",
        "duration_minutes": 1,
    },
    {
        "name": "'Open Hand' Reset",
        "category": "BODY RESET",
        "instructions": "Momentarily open each hand. Re-close with softness. Exhale.",
        "duration_minutes": 1,
    },
    {
        "name": "Eye-Softening Peripheral Vision",
        "category": "BODY RESET",
        "instructions": "Expand your gaze to include arena edges. Breathe slowly.",
        "duration_minutes": 1,
    },
]

# Combine all new tools
all_new_tools = breathing_tools + body_reset_tools

print(f"📊 Processing {len(all_new_tools)} new tools...")
print(f"   - Breathing / HRV: {len(breathing_tools)} tools")
print(f"   - BODY RESET: {len(body_reset_tools)} tools")

# Check for duplicates with existing tools
existing_tools = list(db.mental_strategies.find({}))
existing_names = {tool['name'].lower().strip() for tool in existing_tools}

print(f"\n📚 Existing database has {len(existing_tools)} tools")

# Process new tools and check for duplicates
tools_to_add = []
duplicates = []
merged_count = 0

for new_tool in all_new_tools:
    new_name_lower = new_tool['name'].lower().strip()
    
    # Check if tool with same name exists
    if new_name_lower in existing_names:
        duplicates.append(new_tool['name'])
        # Find the existing tool and merge
        existing = db.mental_strategies.find_one({'name': {'$regex': f'^{new_tool["name"]}$', '$options': 'i'}})
        if existing:
            # Update existing tool with new data
            update_data = {
                'instructions': new_tool['instructions'],
                'duration_minutes': new_tool['duration_minutes'],
                'category': new_tool['category'],
            }
            db.mental_strategies.update_one({'_id': existing['_id']}, {'$set': update_data})
            merged_count += 1
    else:
        # Prepare tool for insertion
        tool_doc = {
            'name': new_tool['name'],
            'category': new_tool['category'],
            'instructions': new_tool['instructions'],
            'duration_minutes': new_tool['duration_minutes'],
            'description': None,
            'anxiety_level': [1, 2, 3, 4, 5],  # Default: applicable to all levels
            'confidence_level': [1, 2, 3, 4, 5],  # Default: applicable to all levels
            'effectiveness_rating': 0,
            'created_at': datetime.utcnow(),
        }
        tools_to_add.append(tool_doc)

# Insert new tools
if tools_to_add:
    result = db.mental_strategies.insert_many(tools_to_add)
    print(f"\n✅ Inserted {len(result.inserted_ids)} new tools")
else:
    print("\n✅ No new tools to insert")

if merged_count > 0:
    print(f"🔄 Merged/updated {merged_count} duplicate tools")

if duplicates:
    print(f"\n📝 Duplicate tools found and merged:")
    for dup in duplicates:
        print(f"   - {dup}")

# Final count
final_count = db.mental_strategies.count_documents({})
print(f"\n📊 Final database statistics:")
print(f"   - Total tools: {final_count}")

# Count by category
categories = db.mental_strategies.distinct('category')
for cat in sorted(categories):
    count = db.mental_strategies.count_documents({'category': cat})
    print(f"   - {cat}: {count} tools")

print("\n✅ Data migration complete!")
