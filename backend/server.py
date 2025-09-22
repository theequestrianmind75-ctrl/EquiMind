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