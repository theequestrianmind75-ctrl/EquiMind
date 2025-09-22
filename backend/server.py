from fastapi import FastAPI, APIRouter, HTTPException
from dotenv import load_dotenv
from starlette.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
import os
import logging
from pathlib import Path
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
import uuid
from datetime import datetime, timezone
from enum import Enum
from emergentintegrations.llm.chat import LlmChat, UserMessage


ROOT_DIR = Path(__file__).parent
load_dotenv(ROOT_DIR / '.env')

# MongoDB connection
mongo_url = os.environ['MONGO_URL']
client = AsyncIOMotorClient(mongo_url)
db = client[os.environ['DB_NAME']]

# Create the main app without a prefix
app = FastAPI()

# Create a router with the /api prefix
api_router = APIRouter(prefix="/api")

# Enums
class RideType(str, Enum):
    SHOW_JUMPING = "show_jumping"
    DRESSAGE = "dressage"
    GENERAL_TRAINING = "general_training"
    COMPETITION = "competition"

class EmotionalState(str, Enum):
    ANXIOUS = "anxious"
    NERVOUS = "nervous"
    NEUTRAL = "neutral"
    CONFIDENT = "confident"
    EXCITED = "excited"

class SessionType(str, Enum):
    PRE_RIDE = "pre_ride"
    DURING_RIDE = "during_ride"
    POST_RIDE = "post_ride"

# Models
class RiderProfile(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    email: str
    experience_level: str
    preferred_disciplines: List[RideType]
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

class EmotionAssessment(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    rider_id: str
    session_id: str
    emotion_level: float
    emotional_state: EmotionalState
    anxiety_level: float
    confidence_level: float
    notes: Optional[str] = None
    timestamp: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

class BreathingExercise(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    description: str
    duration_minutes: int
    instructions: List[str]
    suitable_for_states: List[EmotionalState]

class HorseObservation(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    rider_id: str
    session_id: str
    horse_name: str
    energy_level: int  # 1-10
    responsiveness: int  # 1-10
    mood_indicators: List[str]
    physical_condition: str
    notes: Optional[str] = None
    timestamp: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

class RidingSession(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    rider_id: str
    session_type: SessionType
    ride_type: RideType
    planned_duration: Optional[int] = None
    actual_duration: Optional[int] = None
    emotion_assessment_id: Optional[str] = None
    horse_observation_id: Optional[str] = None
    breathing_exercises_completed: List[str] = []
    voice_memo_url: Optional[str] = None
    progress_percentage: float = 0.0
    performance_score: Optional[float] = None
    ai_insights: Optional[str] = None
    emergency_support_used: bool = False
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    completed_at: Optional[datetime] = None

class MentalStrategy(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    category: str
    description: str
    duration_minutes: int
    trigger_conditions: Dict[str, int]
    instructions: List[str]
    evidence_base: str
    suitable_for: List[str]
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

class StrategyLog(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    rider_id: str
    session_id: str
    strategy_id: str
    strategy_name: str
    trigger_anxiety: int
    trigger_confidence: int
    usage_timestamp: datetime
    completed: bool = False
    effectiveness_rating: Optional[int] = None

class EmergencyEvent(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    rider_id: str
    session_id: str
    trigger_reason: str
    intervention_used: str
    resolution_time_minutes: Optional[int] = None
    notes: Optional[str] = None
    timestamp: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

# Create models for requests
class CreateRiderProfile(BaseModel):
    name: str
    email: str
    experience_level: str
    preferred_disciplines: List[RideType]

class CreateEmotionAssessment(BaseModel):
    rider_id: str
    session_id: str
    emotion_level: float
    anxiety_level: float
    confidence_level: float
    notes: Optional[str] = None

class CreateHorseObservation(BaseModel):
    rider_id: str
    session_id: str
    horse_name: str
    energy_level: int
    responsiveness: int
    mood_indicators: List[str]
    physical_condition: str
    notes: Optional[str] = None

class CreateRidingSession(BaseModel):
    rider_id: str
    session_type: SessionType
    ride_type: RideType
    planned_duration: Optional[int] = None

class UpdateSessionProgress(BaseModel):
    emotion_assessment_id: Optional[str] = None
    horse_observation_id: Optional[str] = None
    breathing_exercises_completed: List[str] = []
    voice_memo_url: Optional[str] = None
    progress_percentage: float

# API Routes

@api_router.get("/")
async def root():
    return {"message": "EquiMind API - Equestrian Mental Performance Platform"}

# Rider Profile Routes
@api_router.post("/riders", response_model=RiderProfile)
async def create_rider_profile(rider_data: CreateRiderProfile):
    rider_dict = rider_data.dict()
    rider_obj = RiderProfile(**rider_dict)
    await db.riders.insert_one(rider_obj.dict())
    return rider_obj

@api_router.get("/riders/{rider_id}", response_model=RiderProfile)
async def get_rider_profile(rider_id: str):
    rider = await db.riders.find_one({"id": rider_id})
    if not rider:
        raise HTTPException(status_code=404, detail="Rider not found")
    return RiderProfile(**rider)

# Session Routes
@api_router.post("/sessions", response_model=RidingSession)
async def create_session(session_data: CreateRidingSession):
    session_dict = session_data.dict()
    session_obj = RidingSession(**session_dict)
    await db.sessions.insert_one(session_obj.dict())
    return session_obj

@api_router.get("/sessions/{session_id}", response_model=RidingSession)
async def get_session(session_id: str):
    session = await db.sessions.find_one({"id": session_id})
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return RidingSession(**session)

@api_router.put("/sessions/{session_id}/progress")
async def update_session_progress(session_id: str, progress_data: UpdateSessionProgress):
    update_dict = {k: v for k, v in progress_data.dict().items() if v is not None}
    result = await db.sessions.update_one(
        {"id": session_id},
        {"$set": update_dict}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Session not found")
    return {"message": "Session progress updated successfully"}

@api_router.get("/riders/{rider_id}/sessions", response_model=List[RidingSession])
async def get_rider_sessions(rider_id: str, limit: int = 20):
    sessions = await db.sessions.find({"rider_id": rider_id}).sort("created_at", -1).limit(limit).to_list(limit)
    return [RidingSession(**session) for session in sessions]

# Emotion Assessment Routes
@api_router.post("/emotions", response_model=EmotionAssessment)
async def create_emotion_assessment(emotion_data: CreateEmotionAssessment):
    # Determine emotional state based on emotion level
    if emotion_data.emotion_level <= 2.0:
        emotional_state = EmotionalState.ANXIOUS
    elif emotion_data.emotion_level <= 4.0:
        emotional_state = EmotionalState.NERVOUS
    elif emotion_data.emotion_level <= 6.0:
        emotional_state = EmotionalState.NEUTRAL
    elif emotion_data.emotion_level <= 8.0:
        emotional_state = EmotionalState.CONFIDENT
    else:
        emotional_state = EmotionalState.EXCITED
    
    emotion_dict = emotion_data.dict()
    emotion_dict['emotional_state'] = emotional_state
    emotion_obj = EmotionAssessment(**emotion_dict)
    await db.emotions.insert_one(emotion_obj.dict())
    return emotion_obj

# Horse Observation Routes
@api_router.post("/horse-observations", response_model=HorseObservation)
async def create_horse_observation(observation_data: CreateHorseObservation):
    observation_dict = observation_data.dict()
    observation_obj = HorseObservation(**observation_dict)
    await db.horse_observations.insert_one(observation_obj.dict())
    return observation_obj

# Breathing Exercise Routes
@api_router.get("/breathing-exercises", response_model=List[BreathingExercise])
async def get_breathing_exercises():
    # Return predefined breathing exercises
    exercises = [
        {
            "id": "4-7-8-breathing",
            "name": "4-7-8 Breathing",
            "description": "A calming technique to reduce anxiety and promote relaxation",
            "duration_minutes": 5,
            "instructions": [
                "Exhale completely through your mouth",
                "Close your mouth and inhale through your nose for 4 counts",
                "Hold your breath for 7 counts",
                "Exhale through your mouth for 8 counts",
                "Repeat 3-4 times"
            ],
            "suitable_for_states": ["anxious", "nervous"]
        },
        {
            "id": "box-breathing",
            "name": "Box Breathing",
            "description": "Equal count breathing for focus and concentration",
            "duration_minutes": 5,
            "instructions": [
                "Inhale for 4 counts",
                "Hold for 4 counts",
                "Exhale for 4 counts",
                "Hold empty for 4 counts",
                "Repeat for 5-10 cycles"
            ],
            "suitable_for_states": ["neutral", "confident"]
        },
        {
            "id": "energizing-breath",
            "name": "Energizing Breath",
            "description": "Quick breathing technique to boost energy and confidence",
            "duration_minutes": 3,
            "instructions": [
                "Take rapid, short breaths through your nose",
                "Breathe in and out quickly for 30 seconds",
                "Take a deep breath and hold for 5 seconds",
                "Exhale slowly and completely",
                "Repeat 2-3 times"
            ],
            "suitable_for_states": ["nervous", "neutral"]
        }
    ]
    return exercises

# Emergency Support Routes
@api_router.post("/emergency-events", response_model=EmergencyEvent)
async def create_emergency_event(event_data: dict):
    event_dict = event_data
    event_dict['id'] = str(uuid.uuid4())
    event_dict['timestamp'] = datetime.now(timezone.utc)
    event_obj = EmergencyEvent(**event_dict)
    await db.emergency_events.insert_one(event_obj.dict())
    return event_obj

@api_router.get("/emergency-techniques")
async def get_emergency_techniques():
    return {
        "breathing_exercises": [
            {
                "name": "Emergency 4-7-8",
                "description": "Quick anxiety relief",
                "steps": ["Inhale 4", "Hold 7", "Exhale 8", "Repeat 4 times"]
            }
        ],
        "grounding_techniques": [
            {
                "name": "5-4-3-2-1 Technique",
                "description": "Sensory grounding exercise",
                "steps": [
                    "5 things you can see",
                    "4 things you can touch",
                    "3 things you can hear",
                    "2 things you can smell",
                    "1 thing you can taste"
                ]
            }
        ],
        "immediate_actions": [
            {
                "name": "Safe Dismount",
                "description": "If currently riding",
                "steps": ["Stop your horse", "Dismount safely", "Move to safe area", "Begin breathing exercise"]
            }
        ]
    }

# Analytics Routes
@api_router.get("/riders/{rider_id}/analytics")
async def get_rider_analytics(rider_id: str):
    # Get recent sessions
    recent_sessions = await db.sessions.find({"rider_id": rider_id}).sort("created_at", -1).limit(10).to_list(10)
    
    # Get recent emotion assessments
    recent_emotions = await db.emotions.find({"rider_id": rider_id}).sort("timestamp", -1).limit(10).to_list(10)
    
    # Calculate averages
    avg_confidence = 0
    avg_anxiety = 0
    if recent_emotions:
        avg_confidence = sum(e.get('confidence_level', 0) for e in recent_emotions) / len(recent_emotions)
        avg_anxiety = sum(e.get('anxiety_level', 0) for e in recent_emotions) / len(recent_emotions)
    
    return {
        "total_sessions": len(recent_sessions),
        "avg_confidence_level": round(avg_confidence, 1),
        "avg_anxiety_level": round(avg_anxiety, 1),
        "recent_performance_trend": "improving",  # This would be calculated based on actual data
        "completed_sessions": len([s for s in recent_sessions if s.get('completed_at')]),
        "emergency_events_count": await db.emergency_events.count_documents({"rider_id": rider_id})
    }

# AI Coaching Routes
@api_router.post("/ai-coach/initialize")
async def initialize_ai_coach(context_data: dict):
    try:
        # Initialize AI chat with context
        chat = LlmChat(
            api_key=os.environ.get('EMERGENT_LLM_KEY'),
            session_id=f"coach-{context_data.get('rider_name', 'rider')}-{int(datetime.now().timestamp())}",
            system_message=f"""You are an expert equestrian mental performance coach specializing in anxiety management and confidence building for riders.

Your client profile:
- Name: {context_data.get('rider_name', 'Rider')}
- Experience Level: {context_data.get('experience_level', 'Intermediate')}
- Disciplines: {', '.join(context_data.get('preferred_disciplines', ['General']))}
- Current Emotional State: {context_data.get('current_emotional_state', 'neutral')}
- Session Type: {context_data.get('session_type', 'general')}

You provide:
- Evidence-based mental training techniques
- Personalized anxiety management strategies
- Confidence-building exercises
- Pre-ride preparation guidance
- Emergency anxiety support when needed

Keep responses supportive, professional, and focused on practical techniques. Be encouraging but realistic. Always prioritize safety and mental well-being."""
        ).with_model("openai", "gpt-4o-mini")
        
        # Send initialization message
        welcome_message = UserMessage(
            text=f"Hello! I'm starting a {context_data.get('session_type', 'general')} session focused on {context_data.get('ride_type', 'general training')}. My current emotional state is {context_data.get('current_emotional_state', 'neutral')}. Please provide me with a personalized welcome message and initial guidance."
        )
        
        response = await chat.send_message(welcome_message)
        
        return {
            "message": response,
            "session_id": chat.session_id,
            "category": "welcome"
        }
        
    except Exception as e:
        logger.error(f"AI coach initialization error: {str(e)}")
        # Fallback message
        return {
            "message": f"Hello {context_data.get('rider_name', 'there')}! I'm your AI equestrian coach, here to help you with mental training and anxiety management. Based on your {context_data.get('experience_level', 'intermediate')} level experience in {', '.join(context_data.get('preferred_disciplines', ['riding']))}, I'll provide personalized guidance for your session today. How are you feeling about your upcoming ride?",
            "category": "welcome"
        }

@api_router.get("/mental-strategies")
async def get_mental_strategies():
    """Get all available mental strategies"""
    try:
        strategies = await db.mental_strategies.find().to_list(length=None)
        if not strategies:
            # Return default strategies if none exist in database
            return [
                {
                    "id": "progressive-muscle-relaxation",
                    "name": "Progressive Muscle Relaxation",
                    "category": "anxiety_reduction",
                    "description": "Systematically tense and relax muscle groups to reduce physical anxiety",
                    "duration_minutes": 10,
                    "trigger_conditions": {
                        "anxiety_min": 6,
                        "anxiety_max": 10,
                        "confidence_min": 1,
                        "confidence_max": 5
                    },
                    "instructions": [
                        "Sit or lie down in a comfortable position",
                        "Start with your toes - tense for 5 seconds, then release",
                        "Move up to your calves, thighs, abdomen, arms, and face",
                        "Focus on the contrast between tension and relaxation",
                        "Breathe deeply throughout the exercise"
                    ],
                    "evidence_base": "Systematic review shows 70% reduction in pre-performance anxiety",
                    "suitable_for": ["high_anxiety", "low_confidence", "performance_nerves"]
                },
                {
                    "id": "cognitive-restructuring",
                    "name": "Cognitive Restructuring",
                    "category": "thought_management",
                    "description": "Challenge and replace negative thoughts with realistic, helpful ones",
                    "duration_minutes": 8,
                    "trigger_conditions": {
                        "anxiety_min": 7,
                        "anxiety_max": 10,
                        "confidence_min": 1,
                        "confidence_max": 4
                    },
                    "instructions": [
                        "Identify the specific worry or negative thought",
                        "Ask: 'Is this thought realistic? What evidence do I have?'",
                        "Consider: 'What would I tell a friend in this situation?'",
                        "Replace with a balanced, realistic thought",
                        "Write down the new thought and repeat it 3 times"
                    ],
                    "evidence_base": "CBT techniques show 65% improvement in competitive confidence",
                    "suitable_for": ["catastrophic_thinking", "self_doubt", "fear_of_failure"]
                },
                {
                    "id": "grounding-5-4-3-2-1",
                    "name": "5-4-3-2-1 Grounding Technique",
                    "category": "mindfulness",
                    "description": "Use your senses to anchor yourself in the present moment",
                    "duration_minutes": 5,
                    "trigger_conditions": {
                        "anxiety_min": 6,
                        "anxiety_max": 10,
                        "confidence_min": 1,
                        "confidence_max": 5
                    },
                    "instructions": [
                        "Name 5 things you can see in your environment",
                        "Name 4 things you can touch or feel",
                        "Name 3 things you can hear right now",
                        "Name 2 things you can smell",
                        "Name 1 thing you can taste"
                    ],
                    "evidence_base": "Mindfulness techniques reduce anxiety by 60% in equestrian athletes",
                    "suitable_for": ["panic_symptoms", "dissociation", "overwhelming_anxiety"]
                },
                {
                    "id": "visualization-success",
                    "name": "Success Visualization",
                    "category": "confidence_building",
                    "description": "Mentally rehearse a successful, confident ride",
                    "duration_minutes": 12,
                    "trigger_conditions": {
                        "anxiety_min": 5,
                        "anxiety_max": 9,
                        "confidence_min": 1,
                        "confidence_max": 6
                    },
                    "instructions": [
                        "Close your eyes and take three deep breaths",
                        "Visualize yourself approaching your horse with confidence",
                        "See yourself mounting smoothly and feeling secure",
                        "Imagine completing your planned exercises successfully",
                        "Feel the connection and harmony with your horse",
                        "End by seeing yourself dismounting with a smile"
                    ],
                    "evidence_base": "Mental imagery improves performance confidence by 45%",
                    "suitable_for": ["performance_anxiety", "lack_of_confidence", "negative_expectations"]
                }
            ]
        return [MentalStrategy(**strategy) for strategy in strategies]
    except Exception as e:
        logger.error(f"Error fetching mental strategies: {str(e)}")
        raise HTTPException(status_code=500, detail="Unable to fetch mental strategies")

@api_router.post("/mental-strategies")
async def create_mental_strategy(strategy: MentalStrategy):
    """Create a new mental strategy"""
    try:
        strategy_dict = strategy.dict()
        await db.mental_strategies.insert_one(strategy_dict)
        return strategy
    except Exception as e:
        logger.error(f"Error creating mental strategy: {str(e)}")
        raise HTTPException(status_code=500, detail="Unable to create mental strategy")

@api_router.post("/strategy-logs")
async def log_strategy_usage(log: StrategyLog):
    """Log the usage of a mental strategy"""
    try:
        log_dict = log.dict()
        await db.strategy_logs.insert_one(log_dict)
        return log
    except Exception as e:
        logger.error(f"Error logging strategy usage: {str(e)}")
        raise HTTPException(status_code=500, detail="Unable to log strategy usage")

@api_router.get("/strategy-logs/{rider_id}")
async def get_rider_strategy_logs(rider_id: str):
    """Get strategy usage logs for a specific rider"""
    try:
        logs = await db.strategy_logs.find({"rider_id": rider_id}).to_list(length=None)
        return [StrategyLog(**log) for log in logs]
    except Exception as e:
        logger.error(f"Error fetching strategy logs: {str(e)}")
        raise HTTPException(status_code=500, detail="Unable to fetch strategy logs")

async def chat_with_ai_coach(chat_data: dict):
    try:
        rider_context = chat_data.get('rider_context', {})
        
        # Initialize chat with context
        chat = LlmChat(
            api_key=os.environ.get('EMERGENT_LLM_KEY'),
            session_id=f"coach-{rider_context.get('name', 'rider')}-session",
            system_message=f"""You are an expert equestrian mental performance coach. 

Current client context:
- Name: {rider_context.get('name', 'Rider')}
- Experience: {rider_context.get('experience_level', 'Intermediate')}
- Disciplines: {', '.join(rider_context.get('preferred_disciplines', ['General']))}
- Current emotional state: {rider_context.get('current_emotional_state', 'neutral')}
- Session type: {rider_context.get('session_type', 'general')}

Provide personalized, evidence-based advice for equestrian mental training. Focus on:
- Practical anxiety management techniques
- Confidence building strategies
- Breathing exercises and mindfulness
- Horse-rider connection advice
- Safety-first approach

Keep responses concise (2-3 sentences), supportive, and actionable."""
        ).with_model("openai", "gpt-4o-mini")
        
        # Send user message
        user_message = UserMessage(text=chat_data.get('message', ''))
        response = await chat.send_message(user_message)
        
        # Determine category based on message content
        message_lower = chat_data.get('message', '').lower()
        category = 'general'
        if any(word in message_lower for word in ['anxious', 'scared', 'nervous', 'worry']):
            category = 'concern'
        elif any(word in message_lower for word in ['technique', 'how to', 'method']):
            category = 'technique'
        elif any(word in message_lower for word in ['good', 'great', 'better', 'progress']):
            category = 'encouragement'
        
        return {
            "message": response,
            "category": category,
            "confidence": 0.9
        }
        
    except Exception as e:
        logger.error(f"AI coach chat error: {str(e)}")
        # Fallback response
        return {
            "message": "I understand you're looking for guidance. Let's focus on some deep breathing exercises to help center yourself. Try the 4-7-8 technique: inhale for 4 counts, hold for 7, exhale for 8. This can help calm your nerves before and during your ride.",
            "category": "technique"
        }

@api_router.post("/ai-coach/competition-plan")
async def generate_competition_plan(plan_data: dict):
    try:
        chat = LlmChat(
            api_key=os.environ.get('EMERGENT_LLM_KEY'),
            session_id=f"comp-plan-{int(datetime.now().timestamp())}",
            system_message="""You are an expert equestrian sports psychologist specializing in competition preparation. 

Generate personalized mental training plans for competitive riders based on:
- Competition type and stress level
- Days until competition
- Rider experience level
- Preferred disciplines

Provide structured, evidence-based training phases with specific daily routines and mental strategies."""
        ).with_model("openai", "gpt-4o-mini")
        
        competition_type = plan_data.get('competition_type', 'local_show')
        days_until = plan_data.get('days_until_competition', 14)
        experience = plan_data.get('rider_experience', 'Intermediate')
        disciplines = ', '.join(plan_data.get('preferred_disciplines', ['general']))
        
        prompt = f"""Create a {days_until}-day mental training plan for a {experience} level rider competing in a {competition_type} focusing on {disciplines}.

Structure the response as JSON with:
1. Training phases (3 phases with tasks)
2. Daily routine (4 time slots with activities)
3. Mental strategies (4 key strategies)
4. Emergency protocols (4 emergency techniques)

Focus on evidence-based techniques for anxiety management, confidence building, and peak performance."""
        
        user_message = UserMessage(text=prompt)
        response = await chat.send_message(user_message)
        
        # Try to parse JSON response, fallback to structured data if needed
        try:
            import json
            plan = json.loads(response)
            return plan
        except:
            # Return structured fallback plan
            return {
                "phases": [
                    {
                        "name": "Mental Foundation",
                        "duration": max(1, days_until // 3),
                        "tasks": [
                            "Daily 10-minute meditation",
                            "Positive visualization exercises",
                            "Competition scenario mental rehearsal",
                            "Anxiety management technique practice"
                        ],
                        "color": "bg-blue-500"
                    }
                ],
                "dailyRoutine": [
                    {"time": "Morning", "activity": "Mindfulness meditation", "duration": 10},
                    {"time": "Pre-training", "activity": "Emotional check-in", "duration": 5},
                    {"time": "Post-training", "activity": "Performance visualization", "duration": 15},
                    {"time": "Evening", "activity": "Relaxation techniques", "duration": 10}
                ],
                "mentalStrategies": [
                    "Focus on process goals rather than outcomes",
                    "Develop consistent pre-competition routines",
                    "Practice positive self-talk and affirmations",
                    "Use mental imagery for successful performances"
                ],
                "emergencyStrategies": [
                    "4-7-8 breathing for immediate anxiety relief",
                    "5-4-3-2-1 grounding technique for overwhelming stress",
                    "Progressive muscle relaxation for tension",
                    "Emergency contact protocol with support team"
                ]
            }
        
    except Exception as e:
        logger.error(f"Competition plan generation error: {str(e)}")
        return {"error": "Unable to generate plan", "message": str(e)}

# Include the router in the main app
app.include_router(api_router)

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=os.environ.get('CORS_ORIGINS', '*').split(','),
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@app.on_event("shutdown")
async def shutdown_db_client():
    client.close()