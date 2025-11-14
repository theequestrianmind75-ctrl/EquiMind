"""
Script to add 40 new somatic reset tools to the database
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import uuid
import json

load_dotenv()

async def add_somatic_tools():
    # Connect to MongoDB
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("🔄 Adding new somatic reset tools to database...")
    
    # Define all 40 new tools
    new_tools_data = [
        {
            "name": "Horseback Body Scan",
            "category": "somatic_reset",
            "description": "A mounted somatic body scan that releases tension and increases awareness of how the rider's body moves with the horse.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Place your horse in a relaxed walk or halt.", "Slowly scan your body from head to toe, noticing where you are holding tension.", "Release tension in small increments and observe how your horse responds."],
            "evidence_base": "Somatic experiencing, MBSR body scan, equine-assisted regulation.",
            "suitable_for": ["tension_release", "freeze_response", "body_awareness"]
        },
        {
            "name": "Conscious Swallow Reset",
            "category": "somatic_reset",
            "description": "Uses a slow, deliberate swallow to activate vagal pathways and reduce sympathetic arousal.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["Relax your tongue and jaw and take a slow breath in.", "Gently swallow once, noticing the softening in your throat and chest.", "Repeat 2–3 times while maintaining steady contact with your horse."],
            "evidence_base": "Polyvagal theory and vagal swallowing reflex research.",
            "suitable_for": ["hyperarousal", "panic", "tension"]
        },
        {
            "name": "Vagal Hum Exhale",
            "category": "somatic_reset",
            "description": "Uses humming on the exhale to stimulate the vagus nerve and calm both horse and rider.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["Take a slow inhale through your nose.", "Exhale with a gentle hum, letting the vibration soften your chest and throat.", "Repeat for 4–6 cycles and observe your horse's breathing or ear position."],
            "evidence_base": "Vagal toning research, breath-based nervous-system regulation.",
            "suitable_for": ["panic", "high_arousal", "horse_tension"]
        },
        {
            "name": "Jaw Release → Horse Release",
            "category": "somatic_reset",
            "description": "Softening the rider's jaw signals relaxation through the whole body, often resulting in the horse softening as well.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Relax your jaw by gently unclenching your teeth and letting your tongue drop from the roof of your mouth.", "Take one slow exhale as your jaw softens.", "Notice if your horse shows softening signals such as lowering its neck, licking, or blowing out."],
            "evidence_base": "Somatic jaw release, equine-rider tension mirroring.",
            "suitable_for": ["tension", "horse_softness", "connection"]
        },
        {
            "name": "Pelvic Float Reset",
            "category": "somatic_reset",
            "description": "Encourages the pelvis to follow the horse's movement in a fluid, unbraced pattern.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Imagine your pelvis floating like a buoy on water as your horse moves.", "Let your seat move freely without gripping or controlling.", "Allow small figure-8 motions to emerge naturally."],
            "evidence_base": "Feldenkrais-inspired somatic mobility; rider biomechanics.",
            "suitable_for": ["rigidity", "seat_mobility", "horse_back_relaxation"]
        },
        {
            "name": "Slow Blink Safety Signal",
            "category": "somatic_reset",
            "description": "Uses slow, soft eye blinks to cue the nervous system and the horse that there is no threat.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Relax your eyes and close them softly for a brief moment.", "Blink slowly several times, keeping your jaw soft.", "Pair the blinks with long exhales."],
            "evidence_base": "Polyvagal safety cues; equine calming-signal research.",
            "suitable_for": ["hypervigilance", "horse_anxiety", "relational_safety"]
        },
        {
            "name": "Polyvagal Anchor: Breath Down Spine",
            "category": "somatic_reset",
            "description": "Visualization of breath flowing down the spine to engage dorsal and ventral vagal regulation.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Inhale and imagine the breath traveling from the top of your spine downward.", "Exhale and imagine it grounding through your pelvis into the saddle.", "Repeat slowly for 6–10 breaths."],
            "evidence_base": "Polyvagal theory; somatic breath-based grounding.",
            "suitable_for": ["freeze_response", "dissociation", "tension"]
        },
        {
            "name": "Shoulder Rolls (Micro-Movement)",
            "category": "somatic_reset",
            "description": "Uses small shoulder rolls to release guarding and improve upper-body softness while mounted.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Roll your shoulders gently forward and then back in small circles.", "Keep the movement tiny so as not to unbalance the horse.", "Pair the roll with a slow exhale."],
            "evidence_base": "Somatic micro-movement therapy, postural release.",
            "suitable_for": ["upper_body_tension", "overcontrol"]
        },
        {
            "name": "Sternum Drop Reset",
            "category": "somatic_reset",
            "description": "Softening the sternum releases bracing in the upper chest and improves breathing efficiency.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Relax the front of your chest by imagining your sternum softening downward 1–2 centimeters.", "Let your rib cage widen naturally.", "Notice how your horse responds to your softer torso."],
            "evidence_base": "Somatic postural work; trauma-informed chest release.",
            "suitable_for": ["bracing", "tension", "shallow_breathing"]
        },
        {
            "name": "Side-Body Release",
            "category": "somatic_reset",
            "description": "Releases bracing in the rider's lateral line to increase symmetry and softness.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Gently lengthen through the right side of your body for one breath.", "Then lengthen the left side.", "Return to neutral and notice improved softness and mobility."],
            "evidence_base": "Somatic lateral-line release; body mapping.",
            "suitable_for": ["rigidity", "asymmetry"]
        },
        # 30 additional tools
        {
            "name": "TRE-Style Leg Soft Shake",
            "category": "somatic_reset",
            "description": "A micro-version of tension release (TRE) using gentle leg softening while mounted.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Allow one leg at a time to shake or quiver gently without losing contact.", "Keep movements small and safe.", "Notice release of tension through your hips and pelvis."],
            "evidence_base": "TRE trauma release exercises adapted for mounted safety.",
            "suitable_for": ["stored_tension", "freeze_response"]
        },
        {
            "name": "Wrist Shake-Out",
            "category": "somatic_reset",
            "description": "Releases hand and wrist tension that can travel through the reins to the horse.",
            "duration_minutes": 1,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Shake out one wrist at a time softly while keeping a neutral rein with the other hand.", "Switch sides.", "Return to the reins with softened fingers."],
            "evidence_base": "Somatic tension release, hand relaxation in fine-motor sports.",
            "suitable_for": ["overcontrol", "hand_tension"]
        },
        {
            "name": "Mirror Neuron Relaxation",
            "category": "somatic_reset",
            "description": "Uses calm visual focus to encourage the rider's body to soften through mirror-neuron pathways.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Focus on something calm and steady in the environment (tree, wall, horizon).", "Let your body mimic the stillness you are observing.", "Ride slowly while maintaining this soft gaze."],
            "evidence_base": "Mirror-neuron system research, equine-assisted therapy observations.",
            "suitable_for": ["hypervigilance", "nervous_energy"]
        },
        {
            "name": "Micro-Movement Spine Wave",
            "category": "somatic_reset",
            "description": "Small spinal undulation to release rigidity and improve harmony with horse movement.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Gently create a wave-like motion up your spine, matching your horse's movement.", "Keep the wave subtle and fluid.", "Repeat for one long side of the arena."],
            "evidence_base": "Feldenkrais spinal mobility techniques.",
            "suitable_for": ["rigidity", "bracing"]
        },
        {
            "name": "Neck Softening Within Safety",
            "category": "somatic_reset",
            "description": "Releases neck tension without compromising stability or balance.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Gently turn your head left and right within a safe range.", "Drop your chin slightly, softening the back of your neck.", "Keep shoulders soft while doing this."],
            "evidence_base": "Somatic neck release and posture regulation.",
            "suitable_for": ["tension", "headache_prevention"]
        },
        {
            "name": "Glute Release to Seat Deepening",
            "category": "somatic_reset",
            "description": "Releases glutes to improve seat depth and reduce bouncing or gripping.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Notice if your glutes feel tight or clenched.", "On each exhale, allow them to relax downward.", "Observe how your horse's back responds to a deeper seat."],
            "evidence_base": "Somatic tension release; rider seat biomechanics.",
            "suitable_for": ["seat_mobility", "tension"]
        },
        {
            "name": "Somatic Sigh Release",
            "category": "somatic_reset",
            "description": "Uses a gentle sigh to discharge upper-body tension.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Take a soft inhale through your nose.", "Exhale with a gentle sigh through your mouth.", "Repeat 3–4 times without collapsing your posture."],
            "evidence_base": "Somatic tension release and breath research.",
            "suitable_for": ["anxiety", "tension"]
        },
        {
            "name": "Hand Open–Close Release",
            "category": "somatic_reset",
            "description": "Opens and closes fingers gently to release hand bracing and rein tension.",
            "duration_minutes": 1,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Open your fingers wide for a moment without losing rein feel.", "Close gently, then reopen softly.", "Repeat several times while keeping wrists relaxed."],
            "evidence_base": "Somatic hand release; neuromuscular relaxation.",
            "suitable_for": ["hand_tension", "overcontrol"]
        },
        {
            "name": "Thigh Softening Scan",
            "category": "somatic_reset",
            "description": "Releases gripping in the thighs to increase horse-rider harmony.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Scan through both thighs to identify gripping or tension.", "Release each thigh by 5–10% on every exhale.", "Notice how your horse's back and stride respond."],
            "evidence_base": "Somatic release techniques; rider posture research.",
            "suitable_for": ["tension", "stability"]
        },
        {
            "name": "Lower Back Melt",
            "category": "somatic_reset",
            "description": "Relaxes the lower back to reduce bracing and improve balance.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Imagine your lower back melting downward like warm wax.", "Allow the movement of your horse to gently mobilize your spine.", "Maintain softness for several breaths."],
            "evidence_base": "Somatic lumbar release and mobility work.",
            "suitable_for": ["low_back_tension", "rigidity"]
        },
        {
            "name": "Internal Temperature Check",
            "category": "somatic_reset",
            "description": "Enhances interoception by noticing internal sensations of warmth, coolness, or temperature shifts.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Notice internal sensations such as warmth in your chest or coolness in your hands.", "Name each sensation without judging it.", "Ride one lap while maintaining internal awareness."],
            "evidence_base": "Interoceptive awareness and somatic mindfulness.",
            "suitable_for": ["dissociation", "anxiety"]
        },
        {
            "name": "Heartbeat Awareness",
            "category": "somatic_reset",
            "description": "Builds interoceptive awareness by noticing the pulse or heartbeat while riding.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Bring your attention to your heartbeat or pulse sensations.", "Notice if the rhythm changes as you breathe and ride.", "Pair heartbeat awareness with slow exhales."],
            "evidence_base": "Interoception research; somatic emotional regulation.",
            "suitable_for": ["panic", "hyperarousal"]
        },
        {
            "name": "Internal Energy Direction Downward",
            "category": "somatic_reset",
            "description": "Directs internal energy downward through the seat to create stability and security.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Imagine energy flowing downward from your chest through your seat.", "Let gravity assist the downward flow until your seat deepens.", "Stay connected with slow breathing."],
            "evidence_base": "Grounding and somatic energy-direction practices.",
            "suitable_for": ["anxiety", "tension", "instability"]
        },
        {
            "name": "Breath-to-Tension Mapping",
            "category": "somatic_reset",
            "description": "Maps where breath flows and where it does not, revealing areas of hidden tension.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Notice which parts of your body move with your breath.", "Notice which parts feel still or blocked.", "Direct breath gently toward blocked areas without forcing."],
            "evidence_base": "Breath mapping and somatic therapy research.",
            "suitable_for": ["tension", "body_awareness"]
        },
        {
            "name": "Sensation Naming (Tight, Warm, Buzzing)",
            "category": "somatic_reset",
            "description": "Names sensations to reduce emotional overwhelm and increase regulation.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Notice a sensation such as tightness, warmth, or buzzing.", "Name it simply without judgment.", "Stay with the sensation for one breath before shifting focus."],
            "evidence_base": "Somatic experiencing and mindfulness naming practices.",
            "suitable_for": ["emotional_overwhelm", "anxiety"]
        },
        {
            "name": "Expand vs Contract Body Check",
            "category": "somatic_reset",
            "description": "Identifies whether the body is bracing (contracted) or softening (expanded).",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Ask yourself: \"Is my body expanding or contracting right now?\"", "If contracting, soften one small area such as your jaw or ribs.", "Ride one long side noticing the shift."],
            "evidence_base": "Somatic contraction/expansion patterns in trauma and stress.",
            "suitable_for": ["bracing", "fear"]
        },
        {
            "name": "Somatic Allowing Practice",
            "category": "somatic_reset",
            "description": "Encourages the body to allow sensations without resisting them, reducing fight-or-flight escalation.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Notice a sensation or emotion arising in your body.", "Say internally: \"I can allow this sensation to be here.\"", "Breathe slowly and observe how the sensation shifts."],
            "evidence_base": "Somatic experiencing; acceptance-based emotion regulation.",
            "suitable_for": ["anxiety", "shutdown"]
        },
        {
            "name": "Micro-Postural Adjustments",
            "category": "somatic_reset",
            "description": "Uses tiny alignment shifts to break out of rigid posture cycles.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Shift your posture by just 2–5%: soften your shoulders, lengthen your spine, or adjust your pelvis.", "Keep the adjustments tiny to stay balanced.", "Repeat small resets every few strides."],
            "evidence_base": "Micro-movement somatic regulation.",
            "suitable_for": ["rigidity", "muscle_guarding"]
        },
        {
            "name": "Five Percent Softer Rule",
            "category": "somatic_reset",
            "description": "Asks the rider to soften their body by only 5%, preserving stability while reducing tension.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Choose one body area (jaw, shoulders, hands, thighs).", "Soften that area by just 5%, not more.", "Ride one lap and observe changes in your horse."],
            "evidence_base": "Somatic micro-softening and nervous system down-regulation.",
            "suitable_for": ["tension", "overcontrol"]
        },
        {
            "name": "Pressure Mapping Grip Awareness",
            "category": "somatic_reset",
            "description": "Raises awareness of where the rider is gripping unnecessarily.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Scan your body for any gripping: thighs, glutes, hands, arms.", "Release one gripping area by a small amount.", "Repeat for each area as needed."],
            "evidence_base": "Somatic awareness and pressure mapping research.",
            "suitable_for": ["bracing", "overcontrol"]
        },
        {
            "name": "Synchronize with Horse Swing",
            "category": "somatic_reset",
            "description": "Enhances rider-horse harmony by matching the swing of the horse's rib cage and back.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Feel your horse's ribcage swing left and right under your seat.", "Allow your hips and lower back to follow the movement.", "Stay soft and rhythmically connected for one arena lap."],
            "evidence_base": "Equine biomechanics; entrainment research.",
            "suitable_for": ["connection", "rhythm", "tension_release"]
        },
        {
            "name": "Seat Rhythm Calibration",
            "category": "somatic_reset",
            "description": "Improves seat timing and balance by calibrating movement against the horse's gait rhythm.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Sit quietly at the walk and tune into the rhythm of the gait.", "Match your seat movement precisely with each step.", "Notice increased stability and relaxation."],
            "evidence_base": "Rider biomechanics; somatic rhythm entrainment.",
            "suitable_for": ["balance", "connection"]
        },
        {
            "name": "Somatic Mirroring Exercise",
            "category": "somatic_reset",
            "description": "Encourages the rider to mirror the horse's relaxation patterns to create mutual regulation.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Observe your horse's breathing, rhythm, and posture.", "Mirror any softening or relaxing gesture your horse shows.", "Allow mutual regulation to develop between you."],
            "evidence_base": "Co-regulation and mirror neuron research.",
            "suitable_for": ["horse_connection", "anxiety"]
        },
        {
            "name": "Feel Horse Back Movement",
            "category": "somatic_reset",
            "description": "Trains the rider to sense the vertical and lateral movement of the horse's back.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Focus on how your horse's back lifts and swings under you.", "Follow the movement without bracing or forcing.", "Notice any areas where your body stiffens and soften them."],
            "evidence_base": "Equine proprioception awareness; somatic seat training.",
            "suitable_for": ["seat_mobility", "body_awareness"]
        },
        {
            "name": "Co-Release Rider Exhale → Horse Softens",
            "category": "somatic_reset",
            "description": "Uses the rider's exhale as a cue for the horse to soften or release tension.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["On each slow exhale, soften your entire torso.", "Notice if your horse drops its head, blows out, or relaxes.", "Continue pattern for one arena lap."],
            "evidence_base": "Co-regulation research; equine behavioral mirroring.",
            "suitable_for": ["horse_tension", "connection"]
        },
        {
            "name": "Heavy Seat Bones Grounder",
            "category": "somatic_reset",
            "description": "Helps the rider deepen into the saddle for stability and calm.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Imagine your seat bones dropping heavily into the saddle.", "Allow gravity to create stable contact.", "Maintain soft legs while doing so."],
            "evidence_base": "Somatic grounding principles; equitation seat training.",
            "suitable_for": ["instability", "tension"]
        },
        {
            "name": "Breath and Seat Integration",
            "category": "somatic_reset",
            "description": "Coordinates breath with seat movement to enhance unity with the horse.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["On each inhale, feel your pelvis rise with your horse's movement.", "On each exhale, allow your seat to deepen.", "Maintain integration for several cycles."],
            "evidence_base": "Somatic breath-seat integration work.",
            "suitable_for": ["seat_mobility", "connection"]
        },
        {
            "name": "Aid from Soft Body, Not Tension",
            "category": "somatic_reset",
            "description": "Redirects effort from braced muscles into soft, effective rider aids.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Before giving an aid, soften your torso and release gripping.", "Give the aid from softness rather than force.", "Notice your horse's acceptance of the aid."],
            "evidence_base": "Equitation science; somatic movement efficiency.",
            "suitable_for": ["overcontrol", "tension"]
        },
        {
            "name": "Pelvis–Hip–Knee Line Releasing",
            "category": "somatic_reset",
            "description": "Releases the pelvis-hip-knee line to improve suppleness and reduce gripping.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Notice the line from your pelvis to your knee on each side.", "Soften or lengthen through the line on the exhale.", "Switch sides and maintain symmetry."],
            "evidence_base": "Somatic line release and rider alignment.",
            "suitable_for": ["stability", "softness"]
        },
        {
            "name": "Soft Spine Visualization",
            "category": "somatic_reset",
            "description": "Encourages a flexible, responsive spine to reduce bracing.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 1, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 9},
            "instructions": ["Visualize your spine as a flexible chain rather than a stiff rod.", "Let it respond fluidly to your horse's movement.", "Hold softness for one arena long side."],
            "evidence_base": "Somatic imagery; Feldenkrais-based mobility.",
            "suitable_for": ["rigidity", "fear"]
        }
    ]
    
    # Convert to database format
    tools_to_insert = []
    for tool_data in new_tools_data:
        # Convert trigger conditions to arrays
        anxiety_min = tool_data['trigger_conditions']['anxiety_min']
        anxiety_max = tool_data['trigger_conditions']['anxiety_max']
        confidence_min = tool_data['trigger_conditions']['confidence_min']
        confidence_max = tool_data['trigger_conditions']['confidence_max']
        
        anxiety_level = list(range(anxiety_min, anxiety_max + 1))
        confidence_level = list(range(confidence_min, confidence_max + 1))
        
        # Convert instructions array to string
        instructions_text = "\n".join(tool_data['instructions'])
        
        # Map category to database category
        category = "Somatic Reset" if tool_data['category'] == "somatic_reset" else tool_data['category']
        
        tool = {
            'id': str(uuid.uuid4()),
            'name': tool_data['name'],
            'category': category,
            'description': tool_data['description'],
            'instructions': instructions_text,
            'duration_minutes': tool_data['duration_minutes'],
            'anxiety_level': anxiety_level,
            'confidence_level': confidence_level,
            'effectiveness_rating': 4.0,  # Default rating
            'evidence_base': tool_data.get('evidence_base', ''),
            'suitable_for': tool_data.get('suitable_for', [])
        }
        
        tools_to_insert.append(tool)
    
    # Insert tools
    if tools_to_insert:
        result = await db.mental_strategies.insert_many(tools_to_insert)
        print(f"✅ Successfully added {len(result.inserted_ids)} new somatic reset tools")
    
    # Verify
    somatic_count = await db.mental_strategies.count_documents({'category': 'Somatic Reset'})
    print(f"📊 Total Somatic Reset tools in database: {somatic_count}")
    
    # Show samples
    print(f"\n📋 Sample new somatic reset tools:")
    for tool in tools_to_insert[:5]:
        print(f"  • {tool['name']} ({tool['duration_minutes']} min)")
    print(f"  ... and {len(tools_to_insert) - 5} more")
    
    client.close()
    print("\n✨ Somatic reset tools import complete!")

if __name__ == "__main__":
    asyncio.run(add_somatic_tools())
