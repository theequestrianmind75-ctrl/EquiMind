import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv()

# MongoDB connection from environment
mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')

# New Mindfulness tools
new_tools = [
    {
        "id": "mindful-mounting-sequence",
        "name": "Mindful Mounting Sequence",
        "category": "Mindfulness & Flow",
        "description": "A grounded, step-by-step routine for mounting with awareness, calm breathing, and intentional connection to your horse.",
        "instructions": "1. Stand beside your horse with one hand on their shoulder and take a slow breath.\n2. Feel your feet on the ground and release tension in your jaw and shoulders.\n3. Place your foot in the stirrup slowly, pausing to exhale before mounting.\n4. Lower yourself softly into the saddle and take three breaths to settle your seat.\n5. Notice your horse's breathing and match it with your own for a few cycles.",
        "duration_minutes": 3,
        "anxiety_level": [2, 3, 4, 5, 6],
        "confidence_level": [3, 4, 5, 6, 7, 8],
        "effectiveness_rating": 4.7,
        "evidence_base": "MBSR, somatic grounding, equine-assisted mindfulness",
        "suitable_for": ["pre_ride", "anxiety", "mounting_nerves", "warmup"]
    },
    {
        "id": "breath-sync-with-horse",
        "name": "Breath Sync With Your Horse",
        "category": "Mindfulness & Flow",
        "description": "A co-regulation technique that synchronizes breath rhythms between horse and rider to create calm, safety, and connection.",
        "instructions": "1. Stand beside your horse's ribcage or shoulder.\n2. Place a soft hand on your horse (or hover your hand if preferred).\n3. Notice the rhythm of your horse's breathing.\n4. Let your own breath gently match their rhythm for 5–10 cycles.\n5. Once synced, take one long exhale and begin the ride or groundwork from this calmer state.",
        "duration_minutes": 2,
        "anxiety_level": [2, 3, 4, 5, 6],
        "confidence_level": [3, 4, 5, 6, 7],
        "effectiveness_rating": 4.8,
        "evidence_base": "Co-regulation research, polyvagal theory, mindfulness-based horsemanship",
        "suitable_for": ["pre_ride", "bonding", "horse_tension", "emotional_sync"]
    },
    {
        "id": "mindful-arena-entry",
        "name": "Mindful Arena Entry",
        "category": "Mindfulness & Flow",
        "description": "A short grounding ritual to create intentional focus and presence each time a rider steps into the arena.",
        "instructions": "1. Stop at the arena gate and take one slow breath.\n2. Set a single intention for the ride (e.g., 'soft hands,' 'connection,' 'patience').\n3. Notice three sounds and two sensations before entering.\n4. Enter the arena deliberately, allowing your breath to guide your pace.\n5. Begin the ride with your intention in mind.",
        "duration_minutes": 2,
        "anxiety_level": [1, 2, 3, 4],
        "confidence_level": [4, 5, 6, 7, 8],
        "effectiveness_rating": 4.5,
        "evidence_base": "Sports performance routines, MBSR, attentional control training",
        "suitable_for": ["pre_ride", "focus", "show_nerve_management"]
    },
    {
        "id": "body-scan-for-riders",
        "name": "60-Second Rider Body Scan",
        "category": "Mindfulness & Flow",
        "description": "A fast, targeted body scan that helps riders release tension that could interfere with connection or balance.",
        "instructions": "1. While standing or mounted, bring awareness to your head and relax your jaw.\n2. Scan down through your shoulders, letting them drop.\n3. Feel your ribs and soften around the diaphragm.\n4. Notice your hips and allow them to widen and settle.\n5. Release tension in your legs, knees, and ankles, allowing your weight to fall evenly.",
        "duration_minutes": 1,
        "anxiety_level": [2, 3, 4, 5],
        "confidence_level": [4, 5, 6, 7, 8],
        "effectiveness_rating": 4.6,
        "evidence_base": "Mindfulness-based stress reduction, somatic experiencing",
        "suitable_for": ["pre_ride", "in_ride", "tension_release", "position_improvement"]
    },
    {
        "id": "mindful-half-halt",
        "name": "Mindful Half-Halt",
        "category": "Mindfulness & Flow",
        "description": "A breath-centered version of the classical half-halt to improve balance, timing, and rider awareness.",
        "instructions": "1. Inhale softly as you prepare to rebalance.\n2. On your exhale, engage your core and close your fingers slightly.\n3. Allow your horse to respond, then release and soften.\n4. Keep attention on your breath to avoid over-aiding.\n5. Repeat only as needed with mindful intention.",
        "duration_minutes": 1,
        "anxiety_level": [1, 2, 3, 4],
        "confidence_level": [5, 6, 7, 8, 9],
        "effectiveness_rating": 4.7,
        "evidence_base": "Sports timing research, classical dressage principles, mindful movement",
        "suitable_for": ["in_ride", "balance", "communication", "dressage"]
    },
    {
        "id": "footfall-awareness-drill",
        "name": "Footfall Awareness Drill",
        "category": "Mindfulness & Flow",
        "description": "A rhythm-based attentional drill where the rider becomes mindful of each hoofbeat to enhance timing and presence.",
        "instructions": "1. At the walk, silently say '1-2-3-4' with each hooffall.\n2. Notice which hind leg you feel most clearly.\n3. Shift to trot or canter only when you can track rhythm without losing breath.\n4. Use the rhythm to anchor your attention during transitions.\n5. End by noticing how connected you feel to your horse's movement.",
        "duration_minutes": 3,
        "anxiety_level": [1, 2, 3, 4],
        "confidence_level": [4, 5, 6, 7, 8, 9],
        "effectiveness_rating": 4.6,
        "evidence_base": "Sports rhythm training, attentional focus protocols, equine biomechanics awareness",
        "suitable_for": ["in_ride", "timing", "movement_sync", "focus_training"]
    },
    {
        "id": "present-moment-reins-check",
        "name": "Present-Moment Reins Check",
        "category": "Mindfulness & Flow",
        "description": "A tactile mindfulness drill using rein contact to build awareness, softness, and moment-to-moment feel.",
        "instructions": "1. Hold the reins softly and notice the weight in your fingers.\n2. Take one slow exhale and feel contact lighten.\n3. Pay attention to subtle changes in your horse's mouth, neck, and poll.\n4. Adjust only as much as needed—no more, no less.\n5. Repeat every few minutes as a reset.",
        "duration_minutes": 1,
        "anxiety_level": [1, 2, 3, 4],
        "confidence_level": [4, 5, 6, 7, 8],
        "effectiveness_rating": 4.4,
        "evidence_base": "Mindfulness-based fine motor regulation, equitation science",
        "suitable_for": ["in_ride", "contact", "softness", "dressage", "jump_flatwork"]
    },
    {
        "id": "mindful-transition-focus",
        "name": "Mindful Transition Focus",
        "category": "Mindfulness & Flow",
        "description": "A mindfulness approach to transitions that improves clarity, timing, and emotional steadiness.",
        "instructions": "1. Before each transition, take one slow breath.\n2. Set a micro-intention: 'smooth,' 'balanced,' or 'quiet seat.'\n3. Ask for the transition lightly.\n4. Notice if your horse responds with tension or ease.\n5. Use your breath to soften any tightness.",
        "duration_minutes": 2,
        "anxiety_level": [1, 2, 3, 4],
        "confidence_level": [5, 6, 7, 8],
        "effectiveness_rating": 4.6,
        "evidence_base": "Sports timing and cue clarity, mindful movement practices",
        "suitable_for": ["in_ride", "focus", "soft_transitions", "flatwork"]
    },
    {
        "id": "post-ride-mindful-cooldown",
        "name": "Post-Ride Mindful Cooldown",
        "category": "Mindfulness & Flow",
        "description": "A closing mindfulness ritual that reinforces learning, calm, and gratitude after each ride.",
        "instructions": "1. Allow your horse to walk on a long rein.\n2. Take three slow breaths, letting your weight sink into the saddle.\n3. Notice your horse's footfalls and your body's movement.\n4. Gently reflect: What went well today? What felt connected?\n5. End by thanking your horse—silently or verbally.",
        "duration_minutes": 3,
        "anxiety_level": [1, 2, 3],
        "confidence_level": [6, 7, 8, 9],
        "effectiveness_rating": 4.9,
        "evidence_base": "Gratitude research, recovery-focused mindfulness, sports reflection practices",
        "suitable_for": ["post_ride", "cooldown", "emotional_reinforcement"]
    },
    {
        "id": "arena-edge-mindfulness-walk",
        "name": "Arena Edge Mindfulness Walk",
        "category": "Mindfulness & Flow",
        "description": "A structured walking practice around the arena to bring awareness to breathing, footfalls, and the environment.",
        "instructions": "1. Walk your horse on a loose rein along the arena edge.\n2. Match your breath to your horse's steps: inhale for 2 steps, exhale for 4.\n3. Notice sounds, shadows, light, and footing changes.\n4. Keep your eyes soft and avoid tunnel vision.\n5. Complete at least one full lap before beginning work.",
        "duration_minutes": 4,
        "anxiety_level": [2, 3, 4, 5],
        "confidence_level": [4, 5, 6, 7, 8],
        "effectiveness_rating": 4.7,
        "evidence_base": "Mindful walking (MBSR), equine sensory awareness training",
        "suitable_for": ["pre_ride", "warmup", "anxiety", "focus", "horse_spookiness"]
    }
]

async def add_tools():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🌱 Adding {len(new_tools)} new Mindfulness & Flow tools to {db_name}...\n")
    
    # Count existing tools
    existing_count = await db.mental_strategies.count_documents({})
    print(f"📊 Current tools in database: {existing_count}")
    
    # Count existing Mindfulness tools
    existing_mindfulness = await db.mental_strategies.count_documents({"category": "Mindfulness & Flow"})
    print(f"📊 Current Mindfulness & Flow tools: {existing_mindfulness}\n")
    
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
    final_mindfulness = await db.mental_strategies.count_documents({"category": "Mindfulness & Flow"})
    
    print(f"\n📊 Final database stats:")
    print(f"   Total tools: {final_count}")
    print(f"   Mindfulness & Flow tools: {final_mindfulness}")
    print(f"\n✨ Migration complete!")
    print(f"   Added: {added_count} tools")
    print(f"   Skipped: {skipped_count} tools")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(add_tools())
