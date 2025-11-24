import asyncio
from motor.motor_asyncio import AsyncIOMotorClient

# MongoDB connection
mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind_production"

# Enhanced Distress Tolerance tools with complete metadata
enhanced_tools = [
  {
    "id": "3-minute-halt-stop-skill",
    "name": "The 3-Minute Halt (DBT STOP Skill)",
    "category": "Distress Tolerance",
    "description": "A pause-and-reset tool to interrupt emotional escalation and reassess whether it is safe and appropriate to ride, modify, or stop.",
    "instructions": "1. Stop: Pause all action immediately. Do not mount or continue the ride.\n2. Take a breath: Inhale slowly through your nose and lengthen the exhale through your mouth.\n3. Observe: Notice your thoughts, emotions, body sensations, and your horse's body language.\n4. Proceed mindfully: Choose the safest option—full ride, modified ride, groundwork only, or no ride today.",
    "duration_minutes": 3,
    "anxiety_level": [6, 7, 8, 9, 10],
    "confidence_level": [1, 2, 3, 4, 5],
    "effectiveness_rating": 4.7,
    "evidence_base": "DBT distress tolerance (STOP skill), sports psychology crisis reset",
    "suitable_for": ["high_anxiety", "panic", "overwhelm", "pre_ride", "in_ride", "safety_check"]
  },
  {
    "id": "temperature-reset-tip-skill",
    "name": "Temperature Reset (DBT TIP Skill)",
    "category": "Distress Tolerance",
    "description": "A rapid physiological downshift using cold temperature to lower emotional intensity before riding.",
    "instructions": "1. Apply cold water to your wrists, face, or the back of your neck for 20–30 seconds.\n2. If possible, step into cool fresh air and focus on slow, steady breathing.\n3. Notice changes in your heart rate, muscle tension, and mental intensity.\n4. Re-rate your anxiety from 0–10 and decide whether you need additional grounding before riding.",
    "duration_minutes": 2,
    "anxiety_level": [7, 8, 9, 10],
    "confidence_level": [1, 2, 3, 4],
    "effectiveness_rating": 4.6,
    "evidence_base": "DBT TIP skills, autonomic nervous system regulation research",
    "suitable_for": ["high_anxiety", "panic", "physiological_arousal", "pre_ride", "show_stress"]
  },
  {
    "id": "groundwork-first-rule",
    "name": "Groundwork First Rule",
    "category": "Distress Tolerance",
    "description": "A co-regulation routine using simple groundwork to assess emotional safety and readiness for riding.",
    "instructions": "1. Lead your horse at the walk for 3–5 minutes, focusing on a calm rhythm and clear boundaries.\n2. Add simple yielding or backing exercises to check connection and responsiveness.\n3. Notice your own breathing, tension, and thoughts as you move with your horse.\n4. Observe your horse's signals—head position, muscle tone, responsiveness, and startle level.\n5. Decide whether today is appropriate for a full ride, a modified ride, or groundwork only.",
    "duration_minutes": 5,
    "anxiety_level": [4, 5, 6, 7, 8],
    "confidence_level": [2, 3, 4, 5, 6, 7],
    "effectiveness_rating": 4.8,
    "evidence_base": "Somatic regulation, groundwork-based horsemanship, equine-assisted therapy principles",
    "suitable_for": ["pre_ride", "overwhelm", "horse_tension", "relationship_check", "safety_assessment"]
  },
  {
    "id": "name-it-to-tame-it",
    "name": "Name It to Tame It",
    "category": "Distress Tolerance",
    "description": "A cognitive-emotional tool where the rider labels their emotions to reduce overwhelm and regain clarity.",
    "instructions": "1. Pause and complete the sentence: \"I am feeling ____ because ____.\" Say it silently or out loud.\n2. Acknowledge that the emotion is valid without judging it as good or bad.\n3. Remind yourself: \"This emotion does not get to control my choices with my horse.\"\n4. Take three slow breaths and check whether your emotional intensity has shifted.",
    "duration_minutes": 2,
    "anxiety_level": [3, 4, 5, 6, 7],
    "confidence_level": [3, 4, 5, 6, 7],
    "effectiveness_rating": 4.4,
    "evidence_base": "Affect labeling research, neuropsychology of emotion regulation",
    "suitable_for": ["rumination", "overthinking", "moderate_anxiety", "pre_ride", "post_ride_processing"]
  },
  {
    "id": "dbt-sensory-anchors-rider",
    "name": "5-4-3-2-1 Sensory Anchors (Rider Edition)",
    "category": "Distress Tolerance",
    "description": "A grounding exercise using the barn and arena environment to bring attention back to the present moment.",
    "instructions": "1. Name 5 things you can see around you (e.g., arena rails, mountains, saddle, your horse's ears).\n2. Identify 4 things you can hear (hoofbeats, wind, voices, barn sounds).\n3. Notice 3 things you can touch (reins, your boots, your horse's coat or mane).\n4. Identify 2 scents you can smell (hay, leather, fresh air).\n5. Choose 1 grounding movement (press your heels into the ground, roll your shoulders, or place a hand on your horse's neck) and take a slow exhale.",
    "duration_minutes": 4,
    "anxiety_level": [3, 4, 5, 6, 7],
    "confidence_level": [2, 3, 4, 5, 6, 7, 8],
    "effectiveness_rating": 4.5,
    "evidence_base": "Grounding techniques, trauma-informed stabilization, mindfulness-based stress reduction",
    "suitable_for": ["dissociation", "mild_to_moderate_anxiety", "pre_ride", "in_ride", "show_environment"]
  },
  {
    "id": "wise-mind-saddle-check",
    "name": "Wise Mind Saddle Check",
    "category": "Distress Tolerance",
    "description": "A DBT-based decision tool to integrate emotion and logic before making a riding plan.",
    "instructions": "1. Emotion Mind: Ask yourself, \"What do I feel like doing right now with my horse?\" Notice impulses such as pushing through or avoiding.\n2. Reasonable Mind: Ask, \"Given my current state and my horse's behavior, what is the safest and most realistic plan?\"\n3. Wise Mind: Blend both and ask, \"What choice honors both safety and partnership?\"\n4. Clearly state your decision (e.g., full ride, walk-only ride, groundwork, or no ride) and commit to it for this session.",
    "duration_minutes": 3,
    "anxiety_level": [5, 6, 7, 8],
    "confidence_level": [2, 3, 4, 5, 6],
    "effectiveness_rating": 4.6,
    "evidence_base": "DBT Wise Mind model, decision-making under stress in sport",
    "suitable_for": ["decision_conflict", "fear_vs_drive", "pre_ride", "goal_adjustment", "safety_planning"]
  },
  {
    "id": "act-open-the-door-exercise",
    "name": "ACT Open the Door Exercise",
    "category": "Distress Tolerance",
    "description": "An acceptance-based practice that allows difficult emotions while choosing values-guided action with the horse.",
    "instructions": "1. Visualize a door in front of you labeled with your current emotion (e.g., anxiety, anger, grief).\n2. Imagine gently opening the door and allowing the emotion to be present without fighting or suppressing it.\n3. Ask yourself, \"What value do I want to ride from today?\" (e.g., safety, patience, connection, kindness, learning).\n4. Choose one small, concrete action that reflects that value—for example, a quiet walk ride, focused grooming, or simple groundwork.",
    "duration_minutes": 4,
    "anxiety_level": [4, 5, 6, 7, 8],
    "confidence_level": [2, 3, 4, 5, 6, 7],
    "effectiveness_rating": 4.5,
    "evidence_base": "Acceptance and Commitment Therapy (ACT), values-based behavior change",
    "suitable_for": ["value_conflict", "emotion_avoidance", "life_stress_spillover", "pre_ride", "post_ride_reflection"]
  },
  {
    "id": "sports-psychology-performance-reset",
    "name": "Sports Psychology Performance Reset",
    "category": "Distress Tolerance",
    "description": "A quick cue-based reset to interrupt negative self-talk and restore present-moment focus.",
    "instructions": "1. Notice unhelpful thoughts, such as \"I'm a bad rider\" or \"This ride will go badly.\"\n2. Internally say \"Stop\" or imagine a stop sign to interrupt the spiral.\n3. Choose a simple cue word or phrase like \"steady,\" \"soft,\" \"breathe,\" or \"present.\"\n4. Take one slow breath and repeat your cue word on the exhale as you return to the next small task with your horse.",
    "duration_minutes": 2,
    "anxiety_level": [3, 4, 5, 6, 7],
    "confidence_level": [3, 4, 5, 6, 7, 8],
    "effectiveness_rating": 4.3,
    "evidence_base": "Sports psychology self-talk interventions, performance routines research",
    "suitable_for": ["performance_anxiety", "negative_self_talk", "ring_nerves", "pre_ride", "in_ride"]
  },
  {
    "id": "co-regulation-through-body-position",
    "name": "Co-Regulation Through Body Position",
    "category": "Distress Tolerance",
    "description": "A somatic tool that uses posture and breath to send safety cues to the horse's nervous system.",
    "instructions": "1. Stand or sit with your feet grounded and briefly scan for tension in your jaw, shoulders, chest, back, and legs.\n2. Soften your jaw, drop your shoulders, and allow your chest and ribcage to gently expand.\n3. Take several slow exhales, imagining the breath traveling down into your seat and legs.\n4. While near or on your horse, maintain this softened posture and notice any changes in your horse's breathing, expression, or muscle tone.",
    "duration_minutes": 3,
    "anxiety_level": [4, 5, 6, 7, 8],
    "confidence_level": [2, 3, 4, 5, 6, 7],
    "effectiveness_rating": 4.7,
    "evidence_base": "Polyvagal theory, somatic regulation, equine-assisted psychotherapy observations",
    "suitable_for": ["mutual_tension", "horse_reactivity", "pre_ride", "in_ride", "bonding"]
  },
  {
    "id": "ride-alternatives-list",
    "name": "Ride Alternatives Menu",
    "category": "Distress Tolerance",
    "description": "A structured safety plan offering pre-chosen alternatives when emotional intensity is too high for a full ride.",
    "instructions": "1. Create a personal list of alternatives such as: grooming only, hand-walking, in-hand trail, groundwork, walk-only ride, or no ride today.\n2. Before mounting, rate your emotional intensity from 0–10.\n3. If your number is above your chosen safety threshold (for example, 6 or higher), commit to selecting one alternative instead of a full schooling ride.\n4. After the session, briefly reflect on how your emotional state and your horse's behavior changed using the alternative plan.",
    "duration_minutes": 5,
    "anxiety_level": [6, 7, 8, 9, 10],
    "confidence_level": [1, 2, 3, 4, 5],
    "effectiveness_rating": 4.8,
    "evidence_base": "Risk management in sport, DBT crisis planning, equine welfare guidelines",
    "suitable_for": ["high_anxiety", "safety_risk", "burnout", "return_to_riding", "post_fall_recovery"]
  },
  {
    "id": "is-this-a-riding-day",
    "name": "5-Minute Nervous System Reset",
    "category": "Distress Tolerance",
    "description": "A timed 5-minute sequence integrating breath, body, sensory awareness, and connection with the horse to return the nervous system to a safer range.",
    "instructions": "Minute 1 – Breath: Inhale for a count of 4 and exhale for a count of 6, repeating slowly.\nMinute 2 – Body: Drop your shoulders, soften your jaw, relax your grip in your hands, and release unnecessary tension.\nMinute 3 – Sensory Reset: Name 3 things you see, 2 things you hear, and 1 thing you can physically touch or feel.\nMinute 4 – Connection: Place a hand on your horse's neck or shoulder and allow your breath to sync with a calm rhythm.\nMinute 5 – Decision: Ask, \"Do I feel safe? Does my horse feel safe? What is the kindest choice for both of us—ride, modify, groundwork, or no ride today?\"",
    "duration_minutes": 5,
    "anxiety_level": [4, 5, 6, 7, 8, 9],
    "confidence_level": [1, 2, 3, 4, 5, 6],
    "effectiveness_rating": 4.9,
    "evidence_base": "Breathwork for autonomic regulation, grounding, co-regulation with animals, applied sports psychology routines",
    "suitable_for": ["overwhelm", "pre_ride", "post_scare", "after_work_stress", "transition_to_barn_mode"]
  }
]

async def update_tools():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🔄 Updating {len(enhanced_tools)} Distress Tolerance tools with enhanced metadata...\n")
    
    updated_count = 0
    not_found = []
    
    for tool in enhanced_tools:
        tool_id = tool["id"]
        
        # Update the tool in the database
        result = await db.mental_strategies.update_one(
            {"id": tool_id},
            {"$set": tool}
        )
        
        if result.matched_count > 0:
            updated_count += 1
            print(f"✅ Updated: {tool['name']}")
            print(f"   Rating: {tool['effectiveness_rating']}/5.0")
            print(f"   Evidence: {tool['evidence_base'][:60]}...")
            print()
        else:
            not_found.append(tool['name'])
            print(f"❌ Not found: {tool['name']} (id: {tool_id})")
    
    if not_found:
        print(f"\n⚠️  {len(not_found)} tools not found in database:")
        for name in not_found:
            print(f"   - {name}")
    
    print(f"\n📊 Summary:")
    print(f"   Updated: {updated_count}/{len(enhanced_tools)} tools")
    
    # Verify all Distress Tolerance tools now have complete metadata
    dt_tools = await db.mental_strategies.find({"category": "Distress Tolerance"}).to_list(length=20)
    tools_with_metadata = sum(1 for t in dt_tools if 'effectiveness_rating' in t and 'evidence_base' in t)
    
    print(f"   Tools with complete metadata: {tools_with_metadata}/{len(dt_tools)}")
    
    client.close()

if __name__ == '__main__':
    asyncio.run(update_tools())
