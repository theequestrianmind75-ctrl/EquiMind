import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv()

# MongoDB connection from environment
mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')

# New Distress Tolerance tools
new_tools = [
    {
        "id": "emergency-ground-tie-and-breathe",
        "name": "Emergency Ground-Tie & Breathe",
        "category": "Distress Tolerance",
        "description": "A mounted crisis tool for when the rider feels near panic or emotional overload and needs to rapidly stabilize and keep both horse and rider safe.",
        "instructions": "1. If it is safe to do so, bring your horse to a halt in the safest available spot (center of arena, away from traffic or obstacles).\n2. Shorten your reins just enough to maintain control without pulling, and sit deep in the saddle.\n3. Take 3–5 slow breaths: inhale through your nose for a count of 4, exhale through your mouth for a count of 6.\n4. Silently repeat a grounding phrase such as: \"I am here, I am on my horse, we are standing, we are safe right now.\"\n5. Scan for danger: if any real safety risk is present (loose horses, severe spook, unstable footing), dismount calmly and move both of you to a safer area.\n6. Once stable, decide whether to continue at the walk only, switch to groundwork, or end the ride for today.",
        "duration_minutes": 3,
        "anxiety_level": [7, 8, 9, 10],
        "confidence_level": [1, 2, 3, 4],
        "effectiveness_rating": 4.7,
        "evidence_base": "DBT crisis survival skills, grounding, breath-based autonomic regulation, equestrian risk management practices",
        "suitable_for": [
            "panic",
            "near_panic",
            "in_ride_crisis",
            "spook_response",
            "safety_check"
        ]
    },
    {
        "id": "barn-safe-space-time-out",
        "name": "Barn Safe Space Time-Out",
        "category": "Distress Tolerance",
        "description": "A short, structured time-out away from the horse to prevent escalation when the rider feels on the verge of losing emotional control.",
        "instructions": "1. Ensure your horse is secured safely (cross-ties, stall, or safe tie location) before stepping away.\n2. Tell yourself clearly: \"I am taking a 5-minute time-out to keep both of us safe.\" This frames the pause as a skill, not a failure.\n3. Move to a pre-chosen safe space at the barn (tack room, bathroom, car, quiet corner) where you can be physically away from stimuli.\n4. Use a grounding sequence while away: identify 3 things you see, 2 things you hear, and 1 thing you feel physically (chair, wall, floor under feet).\n5. Take at least 5 slow breaths, lengthening the exhale.\n6. At the end of the time-out, ask yourself: \"Am I calm enough to return and choose a safe plan—groundwork, gentle ride, or no ride today?\"",
        "duration_minutes": 5,
        "anxiety_level": [6, 7, 8, 9, 10],
        "confidence_level": [1, 2, 3, 4, 5],
        "effectiveness_rating": 4.6,
        "evidence_base": "DBT crisis time-out strategies, anger management, environmental modification for emotional regulation",
        "suitable_for": [
            "rage_building",
            "overwhelm",
            "conflict_at_barn",
            "pre_ride_crisis",
            "post_spook_distress"
        ]
    },
    {
        "id": "crisis-ride-stop-plan-dismount",
        "name": "Crisis Ride Stop Plan (Dismount & Decompress)",
        "category": "Distress Tolerance",
        "description": "A clear plan for safely ending a ride in progress when emotions or fear become too intense to continue mounted work.",
        "instructions": "1. Acknowledge the crisis without judgment: silently say, \"This is too much for me right now. Stopping is a smart, safe choice.\"\n2. Bring your horse to a walk and then a controlled halt in the safest available location.\n3. Dismount calmly and deliberately, keeping your breathing slow throughout the movement.\n4. Lead your horse at the walk for 2–3 minutes, allowing both of your nervous systems to downshift while you stay in motion.\n5. Once both of you are calmer, move to a safe area (grooming area, stall, or quiet corner) and untack or loosen tack as appropriate.\n6. Briefly debrief with yourself: what signs did you notice in your body and thoughts that told you it was time to stop? What did your horse show you? Log this as a success in using a safety plan, not a failure.",
        "duration_minutes": 7,
        "anxiety_level": [7, 8, 9, 10],
        "confidence_level": [1, 2, 3, 4],
        "effectiveness_rating": 4.8,
        "evidence_base": "DBT crisis planning, graded exposure with safety stops, equestrian safety and fall-prevention guidelines",
        "suitable_for": [
            "in_ride_crisis",
            "post_near_fall",
            "fear_spike",
            "flashback",
            "loss_of_control_feeling"
        ]
    },
    {
        "id": "call-and-connect-support-script",
        "name": "Call-and-Connect Support Script",
        "category": "Distress Tolerance",
        "description": "A phone-based connection script to prevent isolation and help the rider co-regulate with a trusted person during or after a barn crisis.",
        "instructions": "1. Identify 1–3 safe people ahead of time (coach, barn friend, therapist, partner) who are willing to be in your support list.\n2. When your distress feels too big to manage alone (e.g., shaking, crying, overwhelmed), step away to a safe spot and call or text one person on your list.\n3. Use this simple script: \"Hey, I'm at the barn and I'm really overwhelmed right now. My distress is about a ___ out of 10. I don't need you to fix it—I just need you to listen for a few minutes while I calm down.\"\n4. While on the call, focus on slowing your breathing and describing concrete facts (what happened, what your horse did, what you did) instead of global self-criticism.\n5. End the call by naming one next step: \"I'm going to do groundwork only,\" or \"I'm going to groom and then go home,\" or \"I'm going to sit in my car and listen to music for 10 minutes.\"\n6. Thank your support person and note that reaching out was a skillful crisis tool, not a burden.",
        "duration_minutes": 10,
        "anxiety_level": [6, 7, 8, 9, 10],
        "confidence_level": [1, 2, 3, 4, 5],
        "effectiveness_rating": 4.5,
        "evidence_base": "Social support buffering research, DBT phone coaching principles, co-regulation science",
        "suitable_for": [
            "high_anxiety",
            "panic",
            "post_fall",
            "shame_spike",
            "crisis_debrief"
        ]
    },
    {
        "id": "flashback-anchor-kit",
        "name": "Flashback Anchor Kit",
        "category": "Distress Tolerance",
        "description": "A sensory and cognitive grounding protocol for riders who experience trauma-related flashbacks, vivid memories, or intense fear spikes at the barn.",
        "instructions": "1. As soon as you notice flashback signs (sudden fear, images, feeling \"back there\" instead of \"here\"), move yourself and your horse to the safest available place (halt, dismount if needed, or secure your horse in a stall or tie area).\n2. Say to yourself (out loud if possible): \"This is a memory, not the present moment. I am at the barn today, not in the past.\"\n3. Use three sensory anchors from your environment: name one thing you can see, one thing you can touch (wall, saddle, gate), and one thing you can hear right now.\n4. Place a hand on your chest or thighs and take 5 slow breaths, feeling the physical contact.\n5. Decide on a very gentle next step: simply sitting near your horse, grooming, or leaving the ride for another day. Avoid forcing yourself to \"push through\" a flashback.\n6. Afterward, consider noting the trigger, what helped, and any patterns to discuss later with a therapist or trusted professional.",
        "duration_minutes": 6,
        "anxiety_level": [7, 8, 9, 10],
        "confidence_level": [1, 2, 3, 4],
        "effectiveness_rating": 4.6,
        "evidence_base": "Trauma-informed grounding, PTSD flashback management, DBT distress tolerance adaptations for trauma",
        "suitable_for": [
            "flashbacks",
            "trauma_triggers",
            "post_fall_trauma",
            "sound_triggers",
            "visual_triggers"
        ]
    }
]

async def add_tools():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🌱 Adding {len(new_tools)} new Distress Tolerance crisis tools to {db_name}...\n")
    
    # Count existing tools
    existing_count = await db.mental_strategies.count_documents({})
    print(f"📊 Current tools in database: {existing_count}")
    
    # Count existing Distress Tolerance tools
    existing_distress = await db.mental_strategies.count_documents({"category": "Distress Tolerance"})
    print(f"📊 Current Distress Tolerance tools: {existing_distress}\n")
    
    # Check for duplicates and add
    added_count = 0
    skipped_count = 0
    
    for tool in new_tools:
        existing = await db.mental_strategies.find_one({"id": tool["id"]})
        if existing:
            print(f"⏭️  Skipped (already exists): {tool['name']}")
            skipped_count += 1
        else:
            await db.mental_strategies.insert_one(tool)
            print(f"✅ Added: {tool['name']}")
            added_count += 1
    
    # Final count
    final_count = await db.mental_strategies.count_documents({})
    final_distress = await db.mental_strategies.count_documents({"category": "Distress Tolerance"})
    
    print(f"\n📊 Final database stats:")
    print(f"   Total tools: {final_count}")
    print(f"   Distress Tolerance tools: {final_distress}")
    print(f"\n✨ Migration complete!")
    print(f"   Added: {added_count} tools")
    print(f"   Skipped: {skipped_count} tools")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(add_tools())
