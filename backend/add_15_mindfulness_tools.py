"""
Add 15 new mindfulness tools to the EquiMind database
These tools were created by the user and focus on mindfulness practices for riders
"""
import asyncio
import json
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv
import os
import uuid

load_dotenv()

MONGO_URL = os.getenv("MONGO_URL")
DB_NAME = os.getenv("DB_NAME", "equimind_production")

# 15 new mindfulness tools with proper structure
new_mindfulness_tools = [
    {
        "id": str(uuid.uuid4()),
        "name": "Breath-and-Footfall Mindful Matching",
        "category": "Mindfulness",
        "description": "A mounted mindfulness exercise that synchronizes your breath with your horse's footsteps to anchor attention in the present.",
        "duration_minutes": 5,
        "anxiety_level": [2, 3, 4, 5, 6, 7, 8],
        "confidence_level": [2, 3, 4, 5, 6, 7, 8],
        "instructions": "Put your horse in a relaxed walk in a familiar, safe space. Quietly count your horse's steps and match your inhale to two steps and your exhale to three or four steps. If you lose the rhythm, gently begin again without criticism. Continue for one or two arena laps, simply noticing the rhythm of breath and footfalls. At the end, briefly check in with how your body and your horse feel. Evidence base: Mindfulness-based stress reduction (MBSR), paced breathing, and rhythmic entrainment research.",
        "effectiveness_rating": 4.2,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Mindfulness-based stress reduction (MBSR), paced breathing, and rhythmic entrainment research",
            "suitable_for": ["anxiety", "focus", "body_awareness"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Anchor Word Mindful Riding",
        "category": "Mindfulness",
        "description": "Uses a single anchor word to train present-focused attention while riding.",
        "duration_minutes": 4,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7],
        "confidence_level": [2, 3, 4, 5, 6, 7, 8, 9],
        "instructions": "Choose a single word that represents how you want to ride today, such as 'steady', 'soft', or 'curious'. Begin at the walk and repeat your word silently with each exhale. When your mind wanders to worries or self-criticism, gently notice it and return to the anchor word. Allow your posture and aids to subtly reflect the quality of your word. Continue for several minutes or one full arena pattern. Evidence base: Mindfulness and attentional focus strategies from sports psychology.",
        "effectiveness_rating": 4.3,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Mindfulness and attentional focus strategies from sports psychology",
            "suitable_for": ["focus", "self_criticism", "performance_stress"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Mindful Corners Check-In",
        "category": "Mindfulness",
        "description": "Uses each arena corner as a mindfulness bell to check in with your body and horse.",
        "duration_minutes": 6,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7, 8],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8, 9],
        "instructions": "Ride on the rail at walk or trot in an arena with clear corners or markers. Decide that each time you reach a corner, you will do a 3-second mindfulness check. At each corner, briefly scan your jaw, shoulders, and seat and soften one area by 5%. Notice one thing about your horse's body language before you leave the corner. Continue for 6–8 corners, then reflect on any patterns you noticed. Evidence base: Mindfulness cueing using environmental anchors; equitation focus routines.",
        "effectiveness_rating": 4.1,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Mindfulness cueing using environmental anchors; equitation focus routines",
            "suitable_for": ["tension", "awareness", "connection"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Mindful Halt Reset",
        "category": "Mindfulness",
        "description": "A short halt-based mindfulness reset for both horse and rider to interrupt rushing and overthinking.",
        "duration_minutes": 3,
        "anxiety_level": [2, 3, 4, 5, 6, 7, 8, 9],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8],
        "instructions": "Ask your horse for a quiet, square-ish halt in a safe, familiar area. Once halted, soften your hands, lengthen your spine, and feel both seat bones evenly in the saddle. Take three slow, conscious breaths, noticing the feeling of your horse's barrel under your legs. If thoughts arise about past mistakes or future worries, name them as 'thoughts' and gently return to sensation. When you feel a small shift toward calm, walk on again with the same mindful awareness. Evidence base: Mindfulness-based cognitive therapy (MBCT) and grounding in present-moment sensation.",
        "effectiveness_rating": 4.4,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Mindfulness-based cognitive therapy (MBCT) and grounding in present-moment sensation",
            "suitable_for": ["overthinking", "rushing", "show_anxiety"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Mindful Circle Awareness",
        "category": "Mindfulness",
        "description": "A mindfulness drill focused on riding a circle with curious awareness of line, balance, and feel.",
        "duration_minutes": 5,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7],
        "confidence_level": [2, 3, 4, 5, 6, 7, 8, 9],
        "instructions": "Choose a simple 20-meter circle at walk or trot in a safe area. For the first lap, place your attention on the shape of the circle and gently adjust to keep it round. For the second lap, shift attention to your breathing while allowing the circle to continue on autopilot. For the third lap, focus on how your horse feels under you: rhythm, relaxation, and energy. Notice any urge to judge or criticize and instead stay curious and observational. Evidence base: Mindfulness in motion and attentional shifting techniques from sports psychology.",
        "effectiveness_rating": 4.2,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Mindfulness in motion and attentional shifting techniques from sports psychology",
            "suitable_for": ["focus", "perfectionism", "connection"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Reins as Sensation, Not Control",
        "category": "Mindfulness",
        "description": "A rein-focused mindfulness exercise that transforms the feel of the reins into a sensory anchor instead of a control lever.",
        "duration_minutes": 4,
        "anxiety_level": [2, 3, 4, 5, 6, 7, 8],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8, 9],
        "instructions": "At the walk, take a light, consistent rein contact. Direct your attention to the sensation between your fingers and the reins: texture, weight, and elasticity. Notice where you might be unnecessarily squeezing, bracing, or see-sawing. Softly adjust until your hands feel like flexible bridges rather than clamps. Maintain awareness of rein feel for one arena long side, then allow your focus to widen back to your whole body and horse. Evidence base: Mindful touch and equitation science on rein tension and horse welfare.",
        "effectiveness_rating": 4.3,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Mindful touch and equitation science on rein tension and horse welfare",
            "suitable_for": ["overcontrol", "hand_tension", "horse_mouth_softness"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Mindful Gait Transition Scan",
        "category": "Mindfulness",
        "description": "Invites mindful awareness before, during, and after each transition instead of reacting on autopilot.",
        "duration_minutes": 6,
        "anxiety_level": [2, 3, 4, 5, 6, 7, 8, 9],
        "confidence_level": [2, 3, 4, 5, 6, 7, 8, 9],
        "instructions": "Choose a simple pattern: walk–trot–walk or walk–halt–walk. Before each transition, take one conscious breath and quickly scan your seat, legs, and hands for tension. Ask for the transition with the smallest aid possible, staying fully present in your body. Notice how your horse responds without judging it as good or bad. After the transition, briefly reflect: What did I feel in my body? What did my horse show me? Evidence base: Mindfulness-based performance routines; feedback-focused learning in sport.",
        "effectiveness_rating": 4.1,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Mindfulness-based performance routines; feedback-focused learning in sport",
            "suitable_for": ["rushing_transitions", "awareness", "learning_mindset"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Weather-and-Environment Mindful Ride",
        "category": "Mindfulness",
        "description": "Uses the natural environment and weather as a mindfulness anchor instead of a source of distraction.",
        "duration_minutes": 5,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8, 9],
        "instructions": "At walk, notice the temperature on your skin, the feel of air, and any sun, clouds, or shade. Label sensations neutrally: 'cool on my face', 'breeze on my arms', 'sun on my back'. Allow sounds (wind, birds, nearby traffic) to be part of the ride instead of something to fight. If your mind jumps to 'what ifs' about the environment, gently return to labeling simple sensations. Continue for one or two laps, riding as if the environment is an ally in your awareness practice. Evidence base: Sensory-based mindfulness and exposure techniques in anxiety treatment.",
        "effectiveness_rating": 4.0,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Sensory-based mindfulness and exposure techniques in anxiety treatment",
            "suitable_for": ["mild_anxiety", "hypervigilance", "distraction"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Gratitude Micro-Moments in the Saddle",
        "category": "Mindfulness",
        "description": "Integrates brief moments of gratitude into a ride to shift attention from fear or frustration to appreciation.",
        "duration_minutes": 4,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7, 8],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8, 9],
        "instructions": "At the walk, identify one specific thing you appreciate about your horse (for example, their try, their personality, or their softness). On the next long side, identify one thing you appreciate about yourself as a rider (for example, your persistence or willingness to learn). Take one slow breath while holding each appreciation in mind. Sprinkle in two or three more micro-moments of gratitude throughout the ride whenever tension creeps in. Notice whether your tone toward yourself and your horse softens even slightly. Evidence base: Positive psychology gratitude interventions and mindfulness-based compassion practices.",
        "effectiveness_rating": 4.2,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Positive psychology gratitude interventions and mindfulness-based compassion practices",
            "suitable_for": ["burnout", "discouragement", "self_criticism"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Mindful Line Riding (Letter-to-Letter Focus)",
        "category": "Mindfulness",
        "description": "Focuses on riding from one arena marker to the next with full, present-moment attention.",
        "duration_minutes": 6,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7, 8],
        "confidence_level": [2, 3, 4, 5, 6, 7, 8, 9],
        "instructions": "Choose a simple route from one arena letter or landmark to another at walk or trot. From the moment you leave the letter, place all of your attention on the line: straightness, rhythm, and feel. If your mind wanders to scores, judgment, or others watching, gently redirect back to the feel of the line. On arrival at the next marker, take one conscious breath and then choose the next letter-to-letter line. Repeat for several lines, treating each line as its own small mindful ride. Evidence base: Task-focused attention strategies in sports performance and mindfulness of movement.",
        "effectiveness_rating": 4.3,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Task-focused attention strategies in sports performance and mindfulness of movement",
            "suitable_for": ["show_anxiety", "focus", "precision"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Body Part Spotlight: One Area at a Time",
        "category": "Mindfulness",
        "description": "Rotating mindfulness spotlight through different body parts to improve awareness and reduce tension.",
        "duration_minutes": 7,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7, 8],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8, 9],
        "instructions": "At a quiet walk, choose one body area to spotlight for one lap (for example, hands, shoulders, or hips). For that lap, place 80% of your attention on sensations in that area: pressure, movement, warmth, or tension. On the next lap, switch the spotlight to a different area and repeat. If you notice tension, soften by 5–10% without losing stability. Finish by riding one lap with wider awareness of your whole body and your horse. Evidence base: Somatic mindfulness and interoceptive awareness training.",
        "effectiveness_rating": 4.4,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Somatic mindfulness and interoceptive awareness training",
            "suitable_for": ["body_awareness", "tension_release", "refinement_of_aids"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Curious Observer Mindset Practice",
        "category": "Mindfulness",
        "description": "Trains riders to observe thoughts, feelings, and horse behavior with curiosity instead of judgment.",
        "duration_minutes": 6,
        "anxiety_level": [2, 3, 4, 5, 6, 7, 8, 9],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8],
        "instructions": "Begin your ride at walk and set the intention to be a curious observer of this session. When a thought arises like 'I'm doing this wrong' or 'My horse is being bad', mentally label it as a thought, not a fact. When your horse does something unexpected, silently ask, 'I wonder why that made sense to them?' instead of blaming. Keep returning to the stance of curiosity for one full exercise or pattern. At the end, notice whether you feel more open, less critical, or more able to learn from the ride. Evidence base: Acceptance and Commitment Therapy (ACT) cognitive defusion and mindfulness skills.",
        "effectiveness_rating": 4.5,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Acceptance and Commitment Therapy (ACT) cognitive defusion and mindfulness skills",
            "suitable_for": ["self_criticism", "frustration", "learning_mindset"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Mindful Mounting and First 10 Steps",
        "category": "Mindfulness",
        "description": "A pre-ride mindfulness ritual focused on the mounting block and the first 10 steps under saddle.",
        "duration_minutes": 5,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7, 8, 9],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8],
        "instructions": "At the mounting block, pause for one slow breath and feel your feet on the ground. As you mount, notice each contact point: hand on mane or neck, leg over the saddle, seat settling into place. Once seated, take two mindful breaths before moving off, noticing your horse's breathing and posture. Ask your horse to walk and count the first ten steps, staying fully present with each one. Only after these ten mindful steps, continue your ride as usual. Evidence base: Mindfulness rituals, pre-performance routines, and equine-assisted psychotherapy practices.",
        "effectiveness_rating": 4.3,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Mindfulness rituals, pre-performance routines, and equine-assisted psychotherapy practices",
            "suitable_for": ["pre_ride_anxiety", "connection", "grounding"],
            "phases": ["pre-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Thoughts on the Cloud Bank",
        "category": "Mindfulness",
        "description": "A cognitive defusion exercise that visualizes thoughts drifting by like clouds while attention returns to the horse.",
        "duration_minutes": 5,
        "anxiety_level": [2, 3, 4, 5, 6, 7, 8, 9],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8],
        "instructions": "At walk, imagine a big, open sky above the arena. When a worry or self-critical thought appears, picture placing it on a cloud and watching it drift across the sky. Name it gently as 'a worry', 'a judgment', or 'a memory' rather than a truth. Bring your attention back down into the feeling of your seat and your horse's movement. Repeat as many times as needed, allowing thoughts to pass without chasing them. Evidence base: Acceptance and Commitment Therapy (ACT) cognitive defusion and mindfulness imagery.",
        "effectiveness_rating": 4.4,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Acceptance and Commitment Therapy (ACT) cognitive defusion and mindfulness imagery",
            "suitable_for": ["rumination", "negative_self_talk", "show_anxiety"],
            "phases": ["during-ride"]
        }
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Mindful End-of-Ride Scan and Thank You",
        "category": "Mindfulness",
        "description": "A closing mindfulness ritual to integrate learning, calm the nervous system, and appreciate the horse.",
        "duration_minutes": 4,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        "instructions": "At the end of your ride, bring your horse to a relaxed walk or quiet halt. Scan your body from head to toe, noticing any areas that feel different compared to the start of the ride. Notice one way your horse tried for you today, even if it was imperfect. Take two slow breaths, exhaling any remaining tension you do not need to take home. Offer your horse a soft verbal or physical 'thank you' before dismounting. Evidence base: Mindfulness closing rituals, positive psychology reflection, and equine-assisted therapy practices.",
        "effectiveness_rating": 4.2,
        "is_crisis_tool": False,
        "metadata": {
            "evidence_base": "Mindfulness closing rituals, positive psychology reflection, and equine-assisted therapy practices",
            "suitable_for": ["integration", "gratitude", "emotional_regulation"],
            "phases": ["post-ride"]
        }
    }
]

async def add_mindfulness_tools():
    """Add 15 new mindfulness tools to the database"""
    print("🔌 Connecting to MongoDB...")
    client = AsyncIOMotorClient(MONGO_URL)
    db = client[DB_NAME]
    
    try:
        # Check current count
        current_count = await db.mental_strategies.count_documents({})
        print(f"📊 Current tool count: {current_count}")
        
        # Check if Mindfulness category exists
        mindfulness_count = await db.mental_strategies.count_documents({"category": "Mindfulness"})
        print(f"📊 Current Mindfulness tools: {mindfulness_count}")
        
        # Add the 15 new tools
        print(f"\n✨ Adding 15 new mindfulness tools...")
        result = await db.mental_strategies.insert_many(new_mindfulness_tools)
        print(f"✅ Successfully added {len(result.inserted_ids)} tools")
        
        # Verify new count
        new_count = await db.mental_strategies.count_documents({})
        new_mindfulness_count = await db.mental_strategies.count_documents({"category": "Mindfulness"})
        
        print(f"\n📊 New total tool count: {new_count} (was {current_count})")
        print(f"📊 New Mindfulness tool count: {new_mindfulness_count} (was {mindfulness_count})")
        print(f"✅ Added {new_count - current_count} tools")
        
        # Show sample of added tools
        print("\n📝 Sample of added tools:")
        for i, tool in enumerate(new_mindfulness_tools[:3], 1):
            print(f"  {i}. {tool['name']} ({tool['duration_minutes']} min)")
        print(f"  ... and {len(new_mindfulness_tools) - 3} more")
        
    except Exception as e:
        print(f"❌ Error adding tools: {e}")
        raise
    finally:
        client.close()
        print("\n🔌 Database connection closed")

if __name__ == "__main__":
    print("=" * 60)
    print("Adding 15 New Mindfulness Tools to EquiMind Database")
    print("=" * 60)
    asyncio.run(add_mindfulness_tools())
    print("\n✅ Migration complete!")
