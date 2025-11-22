import asyncio
import json
from motor.motor_asyncio import AsyncIOMotorClient
import os

# MongoDB connection
mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind_production"

new_tools = [
  {
    "id": "arousal-balance-90s-reset",
    "name": "90-Second Arousal Balance Reset",
    "category": "Arousal Balancing / Competition Nerves",
    "instructions": "You are allowed to feel amped and still ride with clarity. 1) Stand or sit tall and plant your feet. 2) Inhale gently through your nose for a count of 4, noticing the expansion in your ribs and back. 3) Exhale with a soft sigh for a count of 6–8, letting your shoulders drop. 4) On each exhale, silently repeat: "Steady and ready." 5) Complete 8–10 breaths, then quickly scan your body: jaw, shoulders, hands, thighs. Loosen any area still gripping. 6) Step toward your ride with the phrase: "I can use this energy to focus."",
    "duration_minutes": 2
  },
  {
    "id": "competition-nerves-label-and-aim",
    "name": "Competition Nerves: Label and Aim",
    "category": "Arousal Balancing / Competition Nerves",
    "instructions": "This tool channels your nervous energy instead of trying to erase it. 1) Notice your body signals (butterflies, buzzing, heat, shallow breath). 2) Say out loud or in your mind: "This is my body preparing to perform." 3) Label the feeling with a helpful word: excited, charged, switched on. 4) Choose one task to aim this energy at (for example: "Ride the first centerline with softness and straightness."). 5) Visualize sending the energy into that specific task instead of letting it spread everywhere.",
    "duration_minutes": 3
  },
  {
    "id": "walk-ring-pressure-release",
    "name": "Walk-the-Ring Pressure Release",
    "category": "Arousal Balancing / Competition Nerves",
    "instructions": "Use this if you feel keyed up while waiting near the arena. 1) Walk slowly around your warm-up or a quiet space, feeling your feet roll from heel to toe. 2) On each exhale, let your arms swing a little and imagine excess pressure draining into the ground. 3) Choose a simple cue phrase such as: "Breathe and ride" or "Soft and accurate." 4) Repeat this phrase in rhythm with your steps and breath. 5) After 2–3 minutes, pause, roll your shoulders, and imagine you and your horse stepping into a calmer bubble together.",
    "duration_minutes": 3
  },

  {
    "id": "show-ring-box-breathing",
    "name": "Show Ring Box Breathing",
    "category": "Breathing / HRV",
    "instructions": "Use this when you feel your heart racing before entering the ring. 1) Imagine tracing a square in your mind. 2) Inhale through your nose for 4 counts (side one of the square). 3) Hold your breath gently for 4 counts (side two). 4) Exhale slowly through pursed lips for 4 counts (side three). 5) Pause empty for 4 counts (side four). 6) Repeat this box 6–8 times, keeping your shoulders soft and your jaw unclenched. 7) When finished, take one normal breath and say: "Steady body, clear mind."",
    "duration_minutes": 3
  },
  {
    "id": "competition-exhale-extend",
    "name": "Competition Exhale-Extend Breathing",
    "category": "Breathing / HRV",
    "instructions": "If your breathing feels tight and high in your chest, use this reset. 1) Place one hand on your belly, one on your chest. 2) Inhale gently through your nose for 3–4 counts, letting your belly move slightly more than your chest. 3) Exhale for 6–8 counts through slightly parted lips, like fogging a mirror quietly. 4) With each exhale, picture the tension flowing out of your hands, thighs, and jaw. 5) Complete 10–12 breaths. 6) Finish by imagining sending one slow, calm breath down the reins to your horse.",
    "duration_minutes": 4
  },

  {
    "id": "clear-round-mini-visualization",
    "name": "Clear Round Mini Visualization",
    "category": "Visualization / Imagery",
    "instructions": "Use this 3-minute imagery right before you ride. 1) Close your eyes or soften your gaze. 2) Picture yourself entering the arena with shoulders soft, hands steady, and breathing smooth. 3) Run through the first 3–5 movements or jumps: see your track, feel your body staying tall and centered, and your horse responding to light aids. 4) Imagine making one small mistake and calmly correcting it, proving to your brain that you can adapt. 5) End the visualization with a clear, confident finish and a sense of quiet pride in your chest.",
    "duration_minutes": 3
  },
  {
    "id": "competition-start-gate-visual",
    "name": "At-the-Gate Calm Start Visual",
    "category": "Visualization / Imagery",
    "instructions": "Use this while waiting at the in-gate. 1) Look at the arena and imagine a calm bubble forming around the space where you and your horse will ride. 2) See yourself walking in with a relaxed jaw, long leg, and gentle contact. 3) Picture your first transition or first turn going well: you breathe out, your horse softens, and you stay balanced. 4) Let the image play like a short movie with one key phrase such as: "Soft, accurate, present." 5) Open your eyes and step into that bubble as if you are stepping into the movie you just watched.",
    "duration_minutes": 2
  },
  {
    "id": "ride-your-strength-highlight",
    "name": "Ride Your Strength Highlight",
    "category": "Visualization / Imagery",
    "instructions": "This tool uses confidence to quiet nerves. 1) Identify one strength movement or skill (for example: transitions, rhythm, or accurate lines). 2) Close your eyes and replay a memory where you rode that strength well. 3) Notice the details: your posture, your horse's response, and how your body felt. 4) Now visualize bringing that exact same quality into today's ride, especially in the first third of your test or course. 5) Finish with: "I know how to do this. I've done it before."",
    "duration_minutes": 3
  },

  {
    "id": "competition-pre-ride-focus-3x3",
    "name": "Competition Pre-Ride Focus 3×3",
    "category": "Competition Focus / Pre-Ride Routine",
    "instructions": "Use this to organize your mind before mounting. 1) Name 3 things that are going well today (for example: horse is warmed up, I know my pattern, I'm prepared). 2) Name 3 simple ride goals (for example: breathe in the corners, soft hands, ride forward off the leg). 3) Name 3 things you will let go of (for example: the score, other riders' opinions, yesterday's ride). 4) Take one slow breath after each set of three. 5) Mount or walk to the gate holding only the 3 simple ride goals.",
    "duration_minutes": 4
  },
  {
    "id": "mounting-block-focus-sequence",
    "name": "Mounting Block Focus Sequence",
    "category": "Competition Focus / Pre-Ride Routine",
    "instructions": "Use the mounting block as a reset point. 1) Before you step up, pause and place one hand on your horse's neck, feeling their breathing for 2–3 breaths. 2) Step onto the block and take one slow inhale, imagining your spine lengthening. 3) As you exhale, say your ride mantra (for example: "Calm and clear."). 4) Mount slowly, paying attention to each movement instead of rushing. 5) Once in the saddle, check three soft points: fingers, jaw, and thighs. 6) Only then ask your horse to walk off.",
    "duration_minutes": 3
  },
  {
    "id": "in-gate-one-thing-focus",
    "name": "In-Gate One-Thing Focus",
    "category": "Competition Focus / Pre-Ride Routine",
    "instructions": "When you feel overwhelmed by instructions and expectations, use this tool. 1) Ask yourself: "What is the ONE thing that would help this ride most right now?" (for example: ride forward, keep breathing, look ahead). 2) Say that one thing in your mind on every inhale and exhale. 3) As you enter the arena, imagine placing that one focus on the center of the ring, like a guiding star. 4) Any time your mind wanders, bring it gently back to that single focus.",
    "duration_minutes": 2
  },

  {
    "id": "low-energy-5-minute-activation",
    "name": "Low Energy 5-Minute Activation",
    "category": "Activation / Grounding",
    "instructions": "Use this when you feel flat or unmotivated before riding. 1) Set a 5-minute timer. 2) March in place or walk briskly around the barn, swinging your arms and gently rolling your shoulders. 3) Inhale through your nose for 3 counts, exhale through your mouth for 3 counts to create a light, energizing rhythm. 4) With each step, repeat a short phrase like: "Waking up my body." 5) When the timer ends, pause, place a hand on your chest, and notice any increase in warmth, heartbeat, or alertness.",
    "duration_minutes": 5
  },
  {
    "id": "grounding-check-in-activate",
    "name": "Grounding Check-In and Activate",
    "category": "Activation / Grounding",
    "instructions": "Use this when you feel spacey or disconnected. 1) Name 5 things you can see, 4 things you can feel, 3 things you can hear, 2 things you can smell, and 1 thing you can taste. 2) Then do 10 small calf raises or heel drops to wake up your lower body. 3) Take three slightly quicker, deeper breaths to bring a bit more energy online. 4) End by touching your horse's neck or shoulder and noticing their warmth and smell, reconnecting you to the present moment.",
    "duration_minutes": 4
  },
  {
    "id": "micro-goal-activation-ride",
    "name": "Micro-Goal Activation Ride Prep",
    "category": "Activation / Grounding",
    "instructions": "When you feel too tired to think about a full ride, shrink the task. 1) Ask yourself: "What is the smallest useful thing I could do with my horse today?" (for example: 10 minutes of walking with transitions, or 5 minutes of grooming and hand-walking). 2) Say that micro-goal out loud. 3) Take 3 energizing breaths, lifting your chest slightly on the inhale. 4) Start only that micro-goal. 5) If you feel more energy afterward, you may choose to continue—but success is completing the small task you committed to.",
    "duration_minutes": 3
  },

  {
    "id": "gentle-shoulder-and-hip-reset",
    "name": "Gentle Shoulder and Hip Reset",
    "category": "Somatic Reset / Gentle Movement",
    "instructions": "Use this when your body feels heavy or stiff. 1) Stand with your feet hip-width apart. 2) Roll your shoulders forward and back 5–8 times, slow and easy. 3) Place your hands on your hips and gently circle them 5 times in each direction. 4) Shift your weight from one foot to the other, feeling the ground under each foot. 5) Take 3 slow breaths, letting your exhale be slightly longer than your inhale. 6) Notice if you feel even 10% more awake and willing to move toward your ride.",
    "duration_minutes": 4
  },
  {
    "id": "barn-aisle-stretch-walk",
    "name": "Barn Aisle Stretch and Walk",
    "category": "Somatic Reset / Gentle Movement",
    "instructions": "For days when you feel drained but still want to show up. 1) Walk down the barn aisle at a relaxed pace. 2) Every 8–10 steps, pause and reach your arms overhead in a comfortable stretch, then let them drop. 3) Gently twist your torso right and left, keeping your hips facing forward. 4) Repeat this walk–stretch–twist cycle for 3–5 minutes. 5) As you move, repeat to yourself: "Showing up is enough; small steps count."",
    "duration_minutes": 5
  },
  {
    "id": "mounted-walk-body-wake-up",
    "name": "Mounted Walk Body Wake-Up",
    "category": "Somatic Reset / Gentle Movement",
    "instructions": "Use this if you feel low energy already in the saddle. 1) At the walk, gently alternately roll each shoulder back, one at a time. 2) Lightly swing your lower leg forward and back within the stirrup to loosen your hips. 3) Do a set of 5–8 light two-point positions at the walk, standing slightly in your stirrups and sitting back down slowly. 4) Take 3 quicker breaths in and out, then settle back into a smoother rhythm. 5) Notice if your body feels more awake and your posture more alive.",
    "duration_minutes": 4
  },

  {
    "id": "why-i-ride-values-reminder",
    "name": "Why I Ride Values Reminder",
    "category": "Values & Motivation Reflection",
    "instructions": "Use this when your motivation feels low. 1) Take a moment with a note app or journal. 2) Write down 3 reasons you ride that have nothing to do with scores or ribbons (for example: connection with my horse, being outdoors, feeling strong in my body). 3) Circle the one that feels most important today. 4) Ask: "What is one small action I can take today that honors this value?" 5) Commit to that action, even if it is only grooming or a short walk.",
    "duration_minutes": 5
  },
  {
    "id": "values-check-when-tired",
    "name": "Values Check When Tired",
    "category": "Values & Motivation Reflection",
    "instructions": "When you are exhausted and unsure whether to ride, check in with your values. 1) Rate your physical energy 1–10 and emotional bandwidth 1–10. 2) Ask: "Will engaging with my horse in a gentle way today move me closer to the rider and person I want to be?" 3) If yes, choose a low-demand activity such as hand-grazing, grooming, or a short walk under saddle. 4) If no, choose a rest action that still honors your value (for example: stretching at home, reading about horsemanship, or planning a future ride).",
    "duration_minutes": 4
  },
  {
    "id": "future-rider-self-note",
    "name": "Note from Future Rider Self",
    "category": "Values & Motivation Reflection",
    "instructions": "Use this when you doubt whether small efforts matter. 1) Imagine a future version of you 6–12 months from now, riding with more ease and confidence. 2) Ask: "What would that future rider thank me for doing today?" 3) Write 2–3 short sentences as if they are speaking to you (for example: "Thank you for showing up even when you were tired. Those small walks added up."). 4) Choose one tiny step that aligns with that message and do only that today.",
    "duration_minutes": 6
  },

  {
    "id": "training-ride-mindfulness-scan",
    "name": "Training Ride Mindfulness Scan",
    "category": "Mindfulness / Grounding",
    "instructions": "Best for training days when your mind is scattered. 1) At the walk, bring your attention to three anchors: your seat in the saddle, your feet in the stirrups, and your hands on the reins. 2) Spend 3–4 breaths focusing on each anchor in turn, noticing sensations without judging them. 3) When your mind wanders to worries or to-do lists, gently bring it back to one anchor. 4) After 2–3 minutes, choose one simple intention for the ride such as: "Notice my breath every long side."",
    "duration_minutes": 5
  },
  {
    "id": "arena-edges-5-senses",
    "name": "Arena Edges 5-Senses Grounding",
    "category": "Mindfulness / Grounding",
    "instructions": "Use this when you feel mentally far away from your training ride. 1) At the halt or walk, look around the arena and name 4 things you can see (letters, rails, trees). 2) Notice 3 things you can feel (saddle, reins, air on your face). 3) Listen for 2 different sounds (hoof beats, birds, barn noises). 4) Take 1 slow breath and let your shoulders drop. 5) Begin your work from this grounded state, returning to one sense at a time if you drift.",
    "duration_minutes": 3
  },

  {
    "id": "hand-graze-connection-ritual",
    "name": "Hand-Graze Connection Ritual",
    "category": "Horse Connection & Focus",
    "instructions": "Use this on low-energy or recovery days. 1) Bring your horse to a safe grazing area. 2) While they graze, sync your breathing with their chewing rhythm for 1–2 minutes. 3) Gently stroke their neck or shoulder, paying full attention to the feel of their coat and the movement of their muscles. 4) Spend a few breaths simply appreciating them as your partner, without any agenda. 5) End by thanking them out loud or in your mind for sharing their time and energy with you.",
    "duration_minutes": 5
  },
  {
    "id": "focus-circle-in-hand",
    "name": "In-Hand Focus Circle",
    "category": "Horse Connection & Focus",
    "instructions": "Use this when your horse feels distracted on a training day. 1) In a halter and lead, walk a medium-sized circle together at a calm pace. 2) Each time your horse's attention leaves you, gently ask for a small change (for example: halt, step sideways, or change direction) and then return to the circle. 3) Keep your own breathing slow and your shoulders relaxed so you are not adding tension. 4) After 5 minutes, notice whether your horse is checking in with you more frequently.",
    "duration_minutes": 5
  },

  {
    "id": "10-minute-skill-focus-block",
    "name": "10-Minute Single Skill Focus",
    "category": "Skill Development / Exploration",
    "instructions": "Ideal for training days with limited energy or time. 1) Choose ONE small skill to work on (for example: walk–halt transitions, straightness on the long side, or rhythm over poles). 2) Set a 10-minute timer. 3) Warm up briefly, then spend the entire 10 minutes experimenting with small adjustments related to that single skill. 4) When the timer ends, cool down and stop—even if it went imperfectly. 5) Mentally note one thing that improved and one thing to try differently next time.",
    "duration_minutes": 10
  },
  {
    "id": "playful-pattern-exploration",
    "name": "Playful Pattern Exploration",
    "category": "Skill Development / Exploration",
    "instructions": "Use this when you want to lighten the mood of training. 1) Set up a very simple pattern: for example, ride a large figure-eight or a serpentine with wide loops. 2) Ride the pattern at the walk, experimenting with different focus points on each pass (for example: one time focus on bend, next on rhythm, next on breathing). 3) Allow some curiosity and playfulness instead of aiming for perfection. 4) After 10–12 minutes, end the ride with a stretchy walk and acknowledge what you and your horse explored together.",
    "duration_minutes": 10
  }
]

async def add_tools():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🌱 Adding {len(new_tools)} new tools to {db_name}...\n")
    
    # Count existing tools
    existing_count = await db.mental_strategies.count_documents({})
    print(f"📊 Current tools in database: {existing_count}")
    
    # Check for duplicates
    existing_ids = set()
    async for doc in db.mental_strategies.find({}, {"id": 1}):
        existing_ids.add(doc.get("id"))
    
    tools_to_add = []
    skipped = []
    
    for tool in new_tools:
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
        print(f"\n✅ Successfully added {len(result.inserted_ids)} new tools!")
        
        # Show breakdown by category
        print("\n📋 Tools added by category:")
        category_counts = {}
        for tool in tools_to_add:
            cat = tool["category"]
            category_counts[cat] = category_counts.get(cat, 0) + 1
        
        for cat in sorted(category_counts.keys()):
            print(f"   • {cat}: {category_counts[cat]} tools")
        
        # Show new total
        new_count = await db.mental_strategies.count_documents({})
        print(f"\n📈 Total tools in database: {existing_count} → {new_count} (+{new_count - existing_count})")
        
        # Show all categories now in database
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
