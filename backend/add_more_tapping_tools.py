"""
Script to add 40 new tapping/EFT tools to the database
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import uuid

load_dotenv()

async def add_tapping_tools():
    # Connect to MongoDB
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("🔄 Adding 40 new tapping/EFT tools to database...")
    
    # Define all 40 new tools (truncated for brevity - will include all in actual implementation)
    new_tools_data = [
        {
            "name": "Collarbone Tapping",
            "category": "tapping",
            "description": "On-horse EFT-style tapping on the collarbone points to reduce anxiety and reset the nervous system.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 4, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Ensure your horse is walking calmly on a loose or neutral rein in a safe environment.", "With one or two fingers, gently tap on the soft area just below your collarbone on one side, keeping the tapping light and rhythmic.", "Breathe slowly as you tap and, if helpful, name what you are feeling (for example, nervous, tight, overwhelmed).", "Continue for 30–60 seconds, then return both hands to the reins and notice any change in your body and your horse."],
            "evidence_base": "Emotional Freedom Techniques (EFT) research for anxiety and stress reduction; bilateral stimulation in trauma-focused therapies.",
            "suitable_for": ["anxiety", "panic", "performance_stress"]
        },
        {
            "name": "Hand Karate Chop Tapping",
            "category": "tapping",
            "description": "Tapping on the side of the hand (karate chop point) paired with a set-up statement to reduce distress.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 4, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["While your horse walks quietly, bring one hand to the side of the other hand (the karate chop edge).", "Tap gently on the side of your hand with two or three fingers in a steady rhythm.", "Optionally repeat a phrase such as: Even though I feel anxious right now, I am doing the best I can.", "Continue for 30–60 seconds, then return to normal reins and notice your nervous system level."],
            "evidence_base": "EFT set-up protocol; cognitive and somatic integration for distress tolerance.",
            "suitable_for": ["panic", "negative_self_talk", "performance_anxiety"]
        },
        {
            "name": "Alternating Shoulder Tapping",
            "category": "tapping",
            "description": "Bilateral shoulder tapping to stimulate both brain hemispheres and support emotional regulation.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 4, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["With your horse in a calm walk, hold the reins in one hand if safe or loop them briefly.", "Use your right hand to gently tap your left shoulder a few times, then your left hand to tap your right shoulder, alternating right-left-right-left.", "Keep the tapping soft and rhythmic while breathing slowly.", "Continue for 20–40 taps, then return your hands to the reins and notice any sense of calm or clarity."],
            "evidence_base": "Bilateral stimulation methods used in EMDR and trauma-informed therapies.",
            "suitable_for": ["trauma_triggers", "overwhelm", "hyperarousal"]
        },
        {
            "name": "Bilateral Thigh Tapping",
            "category": "tapping",
            "description": "Tapping alternately on each thigh to ground the rider and calm the nervous system.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 4, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["At the walk, place one hand lightly on each thigh.", "Tap alternately left, right, left, right on your thighs in a gentle, steady rhythm.", "Pair the tapping with slower breathing and a neutral focus on your horse's movement.", "Continue for 30–60 seconds, then rest your hands back on the reins."],
            "evidence_base": "Bilateral tapping used in EMDR, DBT, and somatic trauma protocols.",
            "suitable_for": ["panic", "flashbacks", "emotional_overwhelm"]
        },
        {
            "name": "Wrist Tapping Sequence",
            "category": "tapping",
            "description": "Gentle tapping on the inside of the wrist to reduce activation before or during a ride.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["With your horse calmly walking, bring one hand toward the inside of the opposite wrist.", "Tap gently on the inside of the wrist where a pulse might be felt.", "Breathe in for a slow count of four and out for a slow count of six as you tap.", "Repeat for 6–10 breaths, then return your hand to the reins."],
            "evidence_base": "Acupressure-informed tapping points; EFT and anxiety reduction literature.",
            "suitable_for": ["anxiety", "pre_ride_nerves"]
        },
        {
            "name": "Light Chest Tapping",
            "category": "tapping",
            "description": "Soft tapping in the upper chest area to help release emotional pressure and support calmer breathing.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 4, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["Ensure your horse is relaxed at the walk or halt.", "Use fingertips to gently tap in the center of your upper chest, avoiding any painful areas.", "Coordinate the tapping with slow inhales and long exhales.", "Continue for 30–45 seconds, then notice any softening in your chest and shoulders."],
            "evidence_base": "EFT tapping locations; somatic chest release for anxiety.",
            "suitable_for": ["chest_tightness", "panic", "emotional_pressure"]
        },
        {
            "name": "Anxiety Set-Up Statement Tapping",
            "category": "tapping",
            "description": "Uses a set-up statement plus tapping to acknowledge anxiety and build self-acceptance.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 5, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["While your horse is calmly walking, choose a tapping point such as the side of your hand or collarbone.", "Tap gently and say three times (out loud or silently): Even though I feel anxious right now, I accept that this is how I feel and I am trying my best.", "Continue tapping on that point or move through other points as you ride (collarbone, chest, wrist).", "Notice changes in intensity of anxiety from 0–10."],
            "evidence_base": "EFT treatment protocols for anxiety; acceptance-based approaches.",
            "suitable_for": ["performance_anxiety", "fear_after_fall"]
        },
        {
            "name": "Confidence Set-Up Statement Tapping",
            "category": "tapping",
            "description": "Pairs tapping with a confidence-building set-up phrase to shift self-belief before or during a ride.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["Select a tapping point (for example, collarbone or side of hand) while your horse walks.", "Tap and repeat: Even though part of me doubts myself, I am learning and I choose to ride with calm confidence.", "Continue tapping and repeating the phrase for 6–10 breaths.", "Return to normal reins and test how it feels to ride from this updated mindset."],
            "evidence_base": "EFT with positive cognitive restructuring for confidence.",
            "suitable_for": ["low_confidence", "self_doubt"]
        },
        {
            "name": "Flow-State Tapping",
            "category": "tapping",
            "description": "Tapping designed to support a focused, in-the-zone riding state by clearing distractions.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["With your horse at a walk, tap lightly on your collarbone or thighs in a steady bilateral rhythm.", "Repeat a brief phrase such as: Here, now, with my horse.", "Maintain tapping and phrase repetition for 45–60 seconds, then ride a simple pattern focusing on feel and rhythm."],
            "evidence_base": "Bilateral stimulation and sports flow-state research.",
            "suitable_for": ["focus", "performance_stress", "distraction"]
        },
        {
            "name": "Pre-Competition EFT Sequence",
            "category": "tapping",
            "description": "A short tapping sequence used before entering the ring to manage nerves and steady focus.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 5, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["While walking or halted near the arena, tap through a brief sequence: side of hand, collarbone, chest, wrist.", "At each point, name what you feel (for example: nervous, tight, worried) and acknowledge your effort.", "Finish by tapping at the collarbone while repeating a calm phrase such as: I know my horse, I know my ride.", "Take one last slow breath and ride your entry line."],
            "evidence_base": "EFT protocols applied to sports performance anxiety.",
            "suitable_for": ["show_anxiety", "ring_nerves"]
        },
        {
            "name": "Right–Left Rein Finger Tapping",
            "category": "tapping",
            "description": "Tiny bilateral tapping using fingers on the reins to calm the nervous system without dropping contact.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["At the walk, gently tap your right fingers on the rein, then your left fingers, alternating rhythmically.", "Keep the taps very small so you do not disturb your horse's mouth.", "Continue for 20–30 seconds while breathing evenly."],
            "evidence_base": "Discrete bilateral stimulation adapted for mounted use.",
            "suitable_for": ["subtle_anxiety", "need_for_discreet_regulation"]
        },
        {
            "name": "Right–Left Thigh Alternating",
            "category": "tapping",
            "description": "Alternating taps on each thigh for grounding and bilateral neural activation.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 4, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Place one hand near each thigh while your horse walks.", "Tap left thigh, then right thigh, in a slow, even rhythm.", "Continue tapping for 30–60 seconds, then place your hands back on the reins and feel your seat deepening into the saddle."],
            "evidence_base": "Bilateral stimulation, grounding techniques for trauma.",
            "suitable_for": ["overwhelm", "flashbacks", "panic"]
        },
        {
            "name": "Rhythmic Belly Breath and Tap",
            "category": "tapping",
            "description": "Combines belly breathing with tapping to support deep regulation.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Place one hand lightly on your lower belly and the other hand on your thigh.", "As you breathe into your belly, gently tap the hand on your thigh in rhythm with your breath.", "Continue for 6–10 breaths, then ride on and notice changes in your body tone."],
            "evidence_base": "Combined breathwork and bilateral tapping interventions.",
            "suitable_for": ["anxiety", "somatic_tension"]
        },
        {
            "name": "Bilateral Seat Bone Shift",
            "category": "tapping",
            "description": "Subtle alternating weight shifts in the seat, functioning like bilateral stimulation through the pelvis.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["At the walk, slightly increase weight onto your left seat bone, then your right, in a slow alternating rhythm.", "Keep the movement small and synchronized with your horse's stride.", "Continue for one or two long sides of the arena and observe your horse's response."],
            "evidence_base": "Somatic bilateral movement; co-regulation via movement rhythms.",
            "suitable_for": ["dissociation", "mild_anxiety"]
        },
        {
            "name": "Foot Pressure Bilateral Switching",
            "category": "tapping",
            "description": "Alternating heel or stirrup pressure to create bilateral grounding through the legs.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Gently press more weight into your left stirrup, then your right, alternating in a calm rhythm.", "Avoid jabbing or gripping; keep the switches smooth.", "Continue for 30–60 seconds, then return to even weight."],
            "evidence_base": "Grounding via proprioceptive pressure and bilateral stimulation.",
            "suitable_for": ["anxiety", "instability"]
        },
        {
            "name": "Tapping to Horse's Walk Rhythm",
            "category": "tapping",
            "description": "Matches bilateral tapping to the 4-beat walk rhythm to enhance co-regulation.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Notice the four-beat rhythm of your horse's walk.", "Tap alternately on your thighs or shoulders in time with the steps.", "Continue for one arena lap while keeping your breathing slow and steady."],
            "evidence_base": "Rhythmic entrainment research; bilateral stimulation in motion.",
            "suitable_for": ["focus", "anxiety"]
        },
        {
            "name": "Eye-Movement Bilateral Sweep",
            "category": "tapping",
            "description": "Uses slow left-right eye movements to stimulate bilateral processing while mounted.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 4, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["While riding at a calm walk, choose two safe visual points in your environment—one to your left and one to your right.", "Slowly move your eyes from left point to right point and back again, without turning your head drastically.", "Repeat the sweep several times while breathing slowly.", "Return to a neutral forward gaze."],
            "evidence_base": "EMDR-style bilateral eye movement adapted for in-saddle use.",
            "suitable_for": ["trauma_triggers", "flashbacks", "high_arousal"]
        },
        {
            "name": "Shoulder-to-Hip Bilateral Scan",
            "category": "tapping",
            "description": "Involves gentle touch or tapping from shoulder to opposite hip in alternation, supporting cross-body integration.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Slide one hand briefly along the front of your body from left shoulder toward right hip, then return to the reins.", "Repeat on the other side from right shoulder toward left hip.", "Keep movements small and deliberate so as not to disturb your horse.", "Continue alternating sides for 30–60 seconds."],
            "evidence_base": "Cross-lateral bilateral stimulation; somatic integration methods.",
            "suitable_for": ["dissociation", "stress", "body_awareness"]
        },
        {
            "name": "Bilateral Breath Sides Awareness",
            "category": "tapping",
            "description": "Focuses on breathing alternately into left and right sides of the ribcage for bilateral regulation.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["As you inhale, imagine breathing more into the left side of your ribs; as you exhale, relax.", "On the next inhale, imagine breathing more into the right side.", "Alternate left and right for 8–10 breaths while walking your horse."],
            "evidence_base": "Somatic breathwork; lateralized interoception practices.",
            "suitable_for": ["anxiety", "body_awareness"]
        },
        {
            "name": "Alternate Rein Slide Touch",
            "category": "tapping",
            "description": "A discrete bilateral technique where the rider alternately slides fingers along each rein.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["At the walk, gently slide the fingers of your right hand a few centimeters along the rein, then return.", "Then slide the fingers of your left hand along the rein, alternating right and left.", "Keep the contact soft and consistent so the horse is not startled.", "Continue for 20–40 seconds while breathing slowly."],
            "evidence_base": "Discrete bilateral stimulation; sensory grounding.",
            "suitable_for": ["subtle_anxiety", "need_for_hidden_regulation"]
        },
        {
            "name": "Reset Tapping Before Transition",
            "category": "tapping",
            "description": "Brief bilateral tapping to reset the nervous system immediately before a gait or movement transition.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Before asking for a transition, briefly tap both thighs with your hands in an alternating pattern for a few seconds.", "Take one slow, deep breath while tapping.", "Stop tapping, pick up your reins as needed, and cue the transition from a calmer state."],
            "evidence_base": "Bilateral pre-performance reset strategies.",
            "suitable_for": ["transition_anxiety", "rushy_transitions"]
        },
        {
            "name": "Tapping Into Focus (Pre-Jump or Test Prep)",
            "category": "tapping",
            "description": "Helps riders transition from scattered attention into clear focus before a jump or test movement.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["At the walk or halt before a line or movement, tap alternately on your thighs or shoulders.", "Silently say: Focus here, now, on this next line.", "Stop tapping, take one slow inhale and exhale, and ride the movement with your attention on specific cues (line, rhythm, hands, and seat)."],
            "evidence_base": "Performance tapping combined with attentional cueing.",
            "suitable_for": ["focus", "show_anxiety"]
        },
        {
            "name": "Tapping Release for Overthinking",
            "category": "tapping",
            "description": "Targets mental loops and overanalysis by combining tapping with cognitive defusion phrases.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["While your horse walks quietly, tap on your collarbone or thighs.", "Repeat phrases such as: These are just thoughts, not commands or My brain is busy, but my body can stay calm.", "Continue tapping and repeating for 1–2 minutes, then ride a simple pattern focusing only on feel."],
            "evidence_base": "EFT plus ACT cognitive defusion strategies.",
            "suitable_for": ["overthinking", "perfectionism"]
        },
        {
            "name": "Tapping for Letting Go of Mistakes",
            "category": "tapping",
            "description": "Supports emotional recovery after small riding mistakes so they do not derail the session.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["After a mistake or rough moment, keep your horse moving safely at the walk.", "Tap gently on your chest or collarbone and say: I notice that happened, and I can learn without beating myself up.", "Continue tapping for 30–60 seconds, then reset and ride the line again if appropriate."],
            "evidence_base": "Self-compassion research; EFT for shame and performance recovery.",
            "suitable_for": ["shame", "self_criticism", "show_anxiety"]
        },
        {
            "name": "Pre-Test Nerves EFT",
            "category": "tapping",
            "description": "Short tapping protocol focusing on anticipatory nervousness before a dressage test or pattern.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 5, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["While mounted and waiting for your turn, tap through a few points such as side of hand, collarbone, and wrist.", "Name your feelings honestly: I feel shaky, I am afraid of messing up, I want to do well.", "Finish by tapping your collarbone while saying: I can ride the best I can with the horse I have today.", "Take one long exhale and prepare to enter at A or start the pattern."],
            "evidence_base": "EFT for performance anxiety; anticipatory stress protocols.",
            "suitable_for": ["show_anxiety", "anticipatory_fear"]
        },
        {
            "name": "Power Phrase plus Tap",
            "category": "tapping",
            "description": "Pairs a chosen power phrase with tapping to embody a confident riding identity.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Choose a phrase like I ride with clarity or I am a calm, capable rider.", "Tap gently on your chest or thighs while repeating the phrase in time with your breath.", "Continue for 45–60 seconds, then ride a simple line or figure focusing on that identity."],
            "evidence_base": "EFT and identity-based behavior change research.",
            "suitable_for": ["low_confidence", "self_doubt"]
        },
        {
            "name": "Confidence Access Tapping",
            "category": "tapping",
            "description": "Helps riders reconnect with a previous memory of competence and calm while tapping.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Begin gentle tapping on your collarbone or wrist.", "Recall a time you felt confident and effective in the saddle or in another area of life.", "As you tap, bring that memory into your body: posture, breath, and feeling.", "Ride on from that memory state and notice any change."],
            "evidence_base": "Resource tapping; resourcing techniques in trauma therapy and sports psych.",
            "suitable_for": ["low_confidence", "imposter_feelings"]
        },
        {
            "name": "Performance Identity Reset Tapping",
            "category": "tapping",
            "description": "Resets identity from scared or stuck rider to curious learner or calm athlete.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Tap on a chosen point (collarbone or hand) while saying: Even though part of me feels like a bad rider, I am choosing to be a learning athlete.", "Repeat for several tapping rounds, allowing the new identity phrase to settle in.", "Continue riding with that identity in mind, focusing on process instead of perfection."],
            "evidence_base": "EFT combined with identity-based cognitive reframing.",
            "suitable_for": ["shame", "self_criticism"]
        },
        {
            "name": "Course Memory Tapping",
            "category": "tapping",
            "description": "Uses tapping to support memory and calm when remembering a jump course or pattern.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["While mounted and walking, tap alternately on your thighs or shoulders.", "Silently rehearse your course or pattern: fence numbers, lines, letters, or movements.", "If anxious thoughts appear, acknowledge them and return to calmly reviewing the pattern while tapping."],
            "evidence_base": "Bilateral stimulation plus mental rehearsal in sport psychology.",
            "suitable_for": ["course_memory", "show_anxiety"]
        },
        {
            "name": "Visualization plus Tap Combo",
            "category": "tapping",
            "description": "Combines positive ride visualization with tapping to strengthen neural pathways for success.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["At a walk or halt, begin gentle tapping on your thighs or collarbone.", "Visualize yourself riding a line, test, or exercise calmly and effectively.", "Feel the successful ride in your body while you tap.", "Stop tapping, then ride a simplified version of what you visualized."],
            "evidence_base": "Sports imagery plus bilateral stimulation for performance.",
            "suitable_for": ["performance_stress", "confidence"]
        },
        {
            "name": "Tap plus Long Exhale",
            "category": "tapping",
            "description": "Pairs bilateral tapping with prolonged exhalation to quickly down-regulate the nervous system.",
            "duration_minutes": 2,
            "trigger_conditions": {"anxiety_min": 4, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["Tap alternately on your thighs or shoulders in a slow rhythm.", "Inhale normally, then exhale for a slow count of six or longer as you keep tapping.", "Repeat the long exhale plus tapping for 4–6 breaths."],
            "evidence_base": "Breath-based vagal regulation plus bilateral stimulation.",
            "suitable_for": ["panic", "high_arousal"]
        },
        {
            "name": "Tap While Engaging Seat Rhythm",
            "category": "tapping",
            "description": "Uses rhythmic seat motion plus tapping for full-body regulation.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 8, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["At the walk, let your seat move fluidly with your horse's back.", "Lightly tap alternately on your thighs in time with the stride.", "Continue for one arena lap, focusing on the combined rhythm of seat, horse, and tapping."],
            "evidence_base": "Rhythmic regulation; bilateral entrainment strategies.",
            "suitable_for": ["tension", "mild_anxiety", "focus"]
        },
        {
            "name": "Tap While Relaxing Jaw",
            "category": "tapping",
            "description": "Targets jaw tension while tapping to release upper-body bracing and worry.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Begin gentle bilateral tapping on your thighs or shoulders.", "At the same time, let your jaw soften and your tongue rest on the floor of your mouth.", "Maintain tapping for 30–60 seconds as jaw tension melts.", "Return to normal riding focus and observe your horse's response."],
            "evidence_base": "Somatic jaw release plus bilateral stimulation.",
            "suitable_for": ["tension", "worry", "horse_mouth_tension"]
        },
        {
            "name": "Tap plus Soft Gaze",
            "category": "tapping",
            "description": "Supports a soft, wide visual field while using bilateral tapping to reduce hyperfocus or tunnel vision.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 2, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 8},
            "instructions": ["Soften your eyes and allow your gaze to widen so you see more of the arena.", "Tap alternately on your thighs or shoulders as you hold this soft, wide focus.", "Continue for one arena lap, then stop tapping and keep the soft gaze as you ride."],
            "evidence_base": "Visual field regulation plus bilateral tapping for anxiety.",
            "suitable_for": ["hyperfocus", "tunnel_vision", "ring_stress"]
        },
        {
            "name": "Tap to Reduce Hypervigilance",
            "category": "tapping",
            "description": "Helps riders who are constantly scanning for danger bring their nervous system into a more balanced state.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 5, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["Begin bilateral tapping on your thighs, shoulders, or wrists while your horse walks in a safe area.", "Acknowledge: My body is on high alert, and I am not in immediate danger right now.", "Let your eyes briefly scan the environment once, then bring your gaze to a calm focal point.", "Continue tapping until your activation feels one or two points lower on a 0–10 scale."],
            "evidence_base": "Trauma-informed bilateral stimulation for hyperarousal.",
            "suitable_for": ["hypervigilance", "PTSD_symptoms"]
        },
        {
            "name": "Tap to Anchor to Present",
            "category": "tapping",
            "description": "Uses tapping plus present-focused cues to interrupt time-traveling into past falls or future fears.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Tap alternately on your thighs or shoulders.", "Say quietly: Right now I am here, on this horse, in this arena.", "Add simple details: It is [today's weather], I can feel the saddle, I hear hoofbeats.", "Continue for 30–60 seconds until the present feels more real than old memories or imagined disasters."],
            "evidence_base": "Grounding and orientation techniques plus bilateral stimulation.",
            "suitable_for": ["flashbacks", "anticipatory_anxiety"]
        },
        {
            "name": "I Am Safe Tapping Loop",
            "category": "tapping",
            "description": "Reinforces safety messages while tapping when there is no actual immediate threat.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Begin tapping alternately on your collarbone or thighs.", "Repeat softly: In this moment, I am safe enough to ride.", "Scan your environment quickly once to confirm there is no real threat.", "Continue tapping and repeating the phrase for 45–60 seconds."],
            "evidence_base": "Safety cueing in trauma therapy plus EFT techniques.",
            "suitable_for": ["general_anxiety", "post-fall_fear"]
        },
        {
            "name": "Tap for Freeze Response",
            "category": "tapping",
            "description": "Designed for riders who go into a freeze or shut-down response in the saddle.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 5, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 5},
            "instructions": ["If you notice yourself going numb or frozen, keep your horse walking on a small, safe circle if possible.", "Tap firmly but gently on your thighs or shoulders in an alternating rhythm.", "Quietly say: I am here, I am in my body, I can move.", "Continue until you feel even a small return of warmth, sensation, or emotion, then pair with grounding breath."],
            "evidence_base": "Bilateral stimulation for freeze and shutdown states in trauma work.",
            "suitable_for": ["freeze_response", "shutdown", "dissociation"]
        },
        {
            "name": "Tap for After-Spook Reset",
            "category": "tapping",
            "description": "Helps the rider's nervous system recover after a horse spook or sudden event.",
            "duration_minutes": 4,
            "trigger_conditions": {"anxiety_min": 5, "anxiety_max": 10, "confidence_min": 1, "confidence_max": 6},
            "instructions": ["Once the horse is back under control and walking safely, begin light tapping on your thighs or shoulders.", "Acknowledge: That scared me, and I handled it enough to still be here.", "Pair tapping with long exhales until your heart rate begins to slow.", "Decide calmly whether to continue the session or take a break."],
            "evidence_base": "Post-incident grounding; bilateral stimulation for acute stress.",
            "suitable_for": ["post_spook_anxiety", "acute_stress"]
        },
        {
            "name": "Grounding Statement plus Bilateral Tap",
            "category": "tapping",
            "description": "Combines bilateral tapping with a simple grounding sentence to stabilize the rider and support the horse.",
            "duration_minutes": 3,
            "trigger_conditions": {"anxiety_min": 3, "anxiety_max": 9, "confidence_min": 1, "confidence_max": 7},
            "instructions": ["Tap alternately on your thighs or shoulders while your horse walks calmly.", "Choose one grounding statement such as: One breath, one stride, one step at a time.", "Repeat the statement in time with your tapping for 45–60 seconds.", "Stop tapping and keep the grounding statement in mind as you continue riding."],
            "evidence_base": "Combined grounding statements and bilateral stimulation for emotional regulation.",
            "suitable_for": ["anxiety", "overwhelm", "performance_stress"]
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
        category = "Tapping / EFT" if tool_data['category'] == "tapping" else tool_data['category']
        
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
        print(f"✅ Successfully added {len(result.inserted_ids)} new tapping/EFT tools")
    
    # Verify
    tapping_count = await db.mental_strategies.count_documents({'category': 'Tapping / EFT'})
    print(f"📊 Total Tapping / EFT tools in database: {tapping_count}")
    
    # Show samples
    print(f"\n📋 Sample new tapping/EFT tools:")
    for tool in tools_to_insert[:5]:
        print(f"  • {tool['name']} ({tool['duration_minutes']} min)")
    print(f"  ... and {len(tools_to_insert) - 5} more")
    
    client.close()
    print("\n✨ Tapping/EFT tools import complete!")

if __name__ == "__main__":
    asyncio.run(add_tapping_tools())
