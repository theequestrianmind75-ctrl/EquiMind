import asyncio
from motor.motor_asyncio import AsyncIOMotorClient

# MongoDB connection
mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind_production"

# New Distress Tolerance tools
distress_tolerance_tools = [
    {
        "id": "3-minute-halt-stop-skill",
        "name": "The 3-Minute Halt (DBT STOP Skill)",
        "category": "Distress Tolerance",
        "instructions": "This DBT skill helps you pause and regain safety when distress spikes. 1) STOP: Physically freeze. Do not react. Take your hands off the reins if needed. 2) TAKE A BREATH: Slow, deep breath in through your nose for 4 counts, out for 6 counts. Repeat 2-3 times. 3) OBSERVE: Notice what you feel in your body (tight chest, shaky hands), what you are thinking (I can't do this, my horse is going to bolt), and what the situation actually is (my horse shifted weight, I heard a loud noise). 4) PROCEED MINDFULLY: Ask yourself: What is the wise choice right now? Options: dismount and walk, do simple circles at the walk, take a break, or end the ride early. Choose the safest, most grounded action.",
        "duration_minutes": 3
    },
    {
        "id": "temperature-reset-tip-skill",
        "name": "Temperature Reset (DBT TIP Skill)",
        "category": "Distress Tolerance",
        "instructions": "Use temperature change to rapidly lower emotional intensity. 1) If at the barn: Splash cold water on your face, wrists, and neck, or hold an ice pack on the back of your neck for 30 seconds. 2) If riding: Take off your helmet briefly and let cool air hit your face and scalp (only if safe to do so). 3) If no water access: Use a cool, damp towel or cooling neck wrap. 4) After the temperature reset, take 3 slow breaths and reassess: Do I feel calmer? Can I continue safely? The cold activates your parasympathetic nervous system (your body's natural brake pedal) and interrupts the panic response.",
        "duration_minutes": 2
    },
    {
        "id": "groundwork-first-rule",
        "name": "Groundwork First Rule (Somatic Regulation)",
        "category": "Distress Tolerance",
        "instructions": "Spend 5 minutes on the ground with your horse before riding to co-regulate your nervous systems. 1) Lead your horse in a calm circle or figure-eight at the walk. Match your breathing to their steps. 2) Groom your horse slowly, focusing on their body warmth and breathing rhythm. Let your shoulders drop with each stroke. 3) Stand next to your horse's shoulder and sync your breathing: Inhale when they inhale, exhale when they exhale. Do this for 1-2 minutes. 4) Notice if your horse softens (licks and chews, sighs, drops their head). This is a sign that you are both regulating together. 5) Only mount when you feel your body calming and your horse is quiet and attentive.",
        "duration_minutes": 5
    },
    {
        "id": "name-it-to-tame-it",
        "name": "Name It to Tame It",
        "category": "Distress Tolerance",
        "instructions": "Labeling your emotion out loud reduces amygdala activation and helps you think more clearly. 1) Pause and say out loud (or in your mind): I am feeling... (scared, overwhelmed, frustrated, panicked). 2) Add the cause: because... (my horse is tense, I feel out of control, I am worried about falling). 3) Example: I am feeling scared because my horse is spooky today and I am worried I will fall off. 4) Take one slow breath after saying this. 5) Notice if the intensity decreases even slightly. Research shows that naming emotions activates the prefrontal cortex (your thinking brain) and calms the amygdala (your fear center).",
        "duration_minutes": 2
    },
    {
        "id": "dbt-sensory-anchors-rider",
        "name": "DBT Sensory Anchors (5-4-3-2-1 Rider Edition)",
        "category": "Distress Tolerance",
        "instructions": "Use your 5 senses to anchor yourself in the present moment when panic or overwhelm hits. 1) NAME 5 THINGS YOU CAN SEE: Arena letters, trees, my horse's ears, the ground, the fence. 2) NAME 4 THINGS YOU CAN FEEL: Reins in my hands, saddle under me, air on my face, my feet in the stirrups. 3) NAME 3 THINGS YOU CAN HEAR: My horse's hoof beats, birds, my breathing. 4) NAME 2 THINGS YOU CAN SMELL: My horse, leather, hay, fresh air. 5) NAME 1 THING YOU CAN MOVE GENTLY: Roll your shoulders, wiggle your toes in your stirrups, or rotate your ankles. This exercise interrupts your fight-or-flight response by redirecting your attention to the present moment instead of the fear story in your mind.",
        "duration_minutes": 3
    },
    {
        "id": "wise-mind-saddle-check",
        "name": "Wise Mind Saddle Check",
        "category": "Distress Tolerance",
        "instructions": "Use DBT Wise Mind to make a balanced decision about whether to continue riding. 1) Ask your REASONABLE MIND (logic): What are the facts? (Example: My horse is tense but not bolting. I am scared but not in immediate danger. The arena is safe.) 2) Ask your EMOTION MIND (feelings): What do I feel? (Example: I feel panicked. I want to get off. I feel unsafe.) 3) Ask your WISE MIND (intuition + logic): What is the wisest choice that honors both my safety and my goals? (Example: I will walk one more circle. If I still feel panicked, I will dismount and do groundwork instead.) 4) Make the decision and follow through without second-guessing. Wise Mind is the balance between logic and emotion—it keeps you safe while also helping you grow.",
        "duration_minutes": 3
    },
    {
        "id": "act-open-the-door-exercise",
        "name": "ACT Open the Door Exercise",
        "category": "Distress Tolerance",
        "instructions": "This Acceptance and Commitment Therapy (ACT) tool helps you allow difficult emotions while still choosing values-based action. 1) Notice the feeling you are resisting (fear, frustration, shame). Imagine it as a visitor knocking on your door. 2) Say to yourself: I can let this feeling be here. I do not have to fight it or fix it. It is just a feeling. 3) Ask yourself: What action would my best self take right now, even with this feeling present? (Example: My best self would stay calm, take a breath, and ride one more circle before deciding to stop.) 4) Take that action while allowing the feeling to stay. You do not have to feel good to do the right thing. 5) Notice: The feeling may soften when you stop fighting it and start moving toward your values.",
        "duration_minutes": 4
    },
    {
        "id": "sports-psychology-performance-reset",
        "name": "Sports Psychology Performance Reset",
        "category": "Distress Tolerance",
        "instructions": "Use a cue word paired with breath to reset your nervous system quickly during high-stress moments. 1) Choose a cue word that feels calming to you: Steady, Breathe, Center, Easy, or Soft. 2) Practice this reset BEFORE riding so it becomes automatic: Say your cue word in your mind, then take one slow breath in (4 counts) and out (6 counts). Repeat 3 times. 3) DURING RIDING: When you feel panic, tension, or overwhelm, say your cue word silently and pair it with one slow breath. 4) Your body will start to associate the cue word with calm. Over time, this reset will work faster and faster. 5) Pro tip: Elite athletes use cue words to stay focused under pressure. You are training your brain to respond to stress with calm instead of panic.",
        "duration_minutes": 2
    },
    {
        "id": "co-regulation-through-body-position",
        "name": "Co-Regulation Through Body Position",
        "category": "Distress Tolerance",
        "instructions": "Your body position directly affects your horse's nervous system. Use this tool to help both of you regulate. 1) SOFTEN YOUR JAW: Unclench your teeth. Let your jaw hang loose. (Tension in your jaw = tension in your whole body.) 2) DROP YOUR SHOULDERS: Roll them back and down, away from your ears. Let them feel heavy. 3) WIDEN YOUR CHEST: Sit tall but soft. Imagine your chest opening like a flower blooming. 4) EXHALE SLOWLY: Breathe out for 6 counts through slightly parted lips. Let the exhale feel like a sigh of relief. 5) Repeat this 3-5 times. Notice if your horse softens, licks and chews, or drops their head. When you regulate your body, your horse often follows.",
        "duration_minutes": 3
    },
    {
        "id": "ride-alternatives-list",
        "name": "Ride Alternatives List",
        "category": "Distress Tolerance",
        "instructions": "Pre-plan what you will do if riding feels unsafe or overwhelming. Having a plan reduces pressure and supports wise choices. 1) BEFORE YOU GO TO THE BARN: Write down 3 alternatives to riding. Examples: Do 10 minutes of groundwork (leading, backing, circles). Hand-walk my horse for 15 minutes. Groom my horse and practice breathing together. Postpone the ride and come back tomorrow. 2) WHEN YOU ARRIVE AT THE BARN: Check in with yourself using the Is This a Riding Day? assessment (see tool below). 3) IF DISTRESS IS HIGH (3+ warning signs): Choose one of your pre-planned alternatives instead of forcing yourself to ride. 4) Remind yourself: Choosing not to ride today is not failure. It is Wise Mind keeping you and your horse safe. You can always ride another day.",
        "duration_minutes": 5
    },
    {
        "id": "is-this-a-riding-day",
        "name": "Is This a Riding Day? Self-Assessment",
        "category": "Distress Tolerance",
        "instructions": "Use this checklist to assess whether today is a safe day to ride. Check each item that describes you today. MENTAL STATE: My thoughts are racing. I feel overwhelmed or emotionally flooded. I am catastrophizing or thinking in extremes. I feel disconnected, numb, or checked out. EMOTIONAL SIGNS: I feel anxious, irritable, or on edge. I feel dread approaching the barn. I feel pressure to push through. BODY SIGNS: I feel shaky, hot, tight, or lightheaded. My breathing is shallow or fast. I feel physically tense. HORSE FEEDBACK: My horse seems tense, watchy, or reactive. My horse is not standing still or is hyper-alert. My horse is mirroring my tension. DECISION GUIDE: If 3 or more items are checked, use distress tolerance tools (like STOP, Temperature Reset, or Groundwork First) before deciding to ride. If 5 or more items are checked, choose groundwork or no ride today for safety. This is not weakness. This is wisdom.",
        "duration_minutes": 4
    },
]

async def add_tools():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🌱 Adding {len(distress_tolerance_tools)} Distress Tolerance tools to {db_name}...\n")
    
    # Count existing tools
    existing_count = await db.mental_strategies.count_documents({})
    print(f"📊 Current tools in database: {existing_count}")
    
    # Check for duplicates
    existing_ids = set()
    async for doc in db.mental_strategies.find({}, {"id": 1}):
        existing_ids.add(doc.get("id"))
    
    tools_to_add = []
    skipped = []
    
    for tool in distress_tolerance_tools:
        if tool["id"] in existing_ids:
            skipped.append(tool["name"])
        else:
            tools_to_add.append(tool)
    
    if skipped:
        print(f"\n⚠️  Skipping {len(skipped)} duplicate tools:")
        for name in skipped:
            print(f"   - {name}")
    
    if tools_to_add:
        result = await db.mental_strategies.insert_many(tools_to_add)
        print(f"\n✅ Successfully added {len(result.inserted_ids)} new Distress Tolerance tools!")
        
        print("\n📋 Tools added:")
        for tool in tools_to_add:
            print(f"   • {tool['name']} ({tool['duration_minutes']} min)")
        
        # Show new total
        new_count = await db.mental_strategies.count_documents({})
        print(f"\n📈 Total tools in database: {existing_count} → {new_count} (+{new_count - existing_count})")
        
        # Show Distress Tolerance category count
        dt_count = await db.mental_strategies.count_documents({"category": "Distress Tolerance"})
        print(f"📊 Distress Tolerance category now has: {dt_count} tools")
        
        # Show all categories
        print("\n🗂️  All categories in database:")
        all_categories = await db.mental_strategies.distinct("category")
        for i, cat in enumerate(sorted(all_categories), 1):
            count = await db.mental_strategies.count_documents({"category": cat})
            print(f"   {i}. {cat} ({count} tools)")
    else:
        print("\n✓ No new tools to add (all already exist)")
    
    client.close()

if __name__ == '__main__':
    asyncio.run(add_tools())
