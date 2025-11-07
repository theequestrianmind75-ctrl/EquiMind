from fastapi import FastAPI, APIRouter, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.responses import FileResponse
from dotenv import load_dotenv
from starlette.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
import os
import logging
from pathlib import Path
from pydantic import BaseModel, Field, EmailStr
from typing import List, Optional
import uuid
from datetime import datetime, timedelta
import jwt
from passlib.context import CryptContext

ROOT_DIR = Path(__file__).parent
load_dotenv(ROOT_DIR / '.env')

# MongoDB connection
mongo_url = os.environ['MONGO_URL']
client = AsyncIOMotorClient(mongo_url)
db = client[os.environ['DB_NAME']]

# Security
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()
SECRET_KEY = os.environ.get('JWT_SECRET_KEY', 'your-secret-key-change-in-production')
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7  # 7 days

# Create the main app
app = FastAPI()
api_router = APIRouter(prefix="/api")

# ==================== MODELS ====================

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    name: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class User(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    email: EmailStr
    name: str
    hashed_password: str
    created_at: datetime = Field(default_factory=datetime.utcnow)

class UserResponse(BaseModel):
    id: str
    email: str
    name: str

class Token(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse

class SessionCreate(BaseModel):
    session_type: str  # "pre-ride", "during-ride", "post-ride"
    ride_type: str  # "training", "competition", "trail", etc.
    anxiety_level: Optional[int] = None
    confidence_level: Optional[int] = None
    notes: Optional[str] = None
    strategies_used: Optional[List[str]] = []
    # Horse information
    horse_energy_level: Optional[int] = None  # 1-10 scale
    horse_focus_level: Optional[int] = None  # 1-10 scale
    horse_responsiveness: Optional[int] = None  # 1-10 scale
    horse_notes: Optional[str] = None

class SessionUpdate(BaseModel):
    anxiety_level: Optional[int] = None
    confidence_level: Optional[int] = None
    notes: Optional[str] = None
    strategies_used: Optional[List[str]] = None
    completed: Optional[bool] = None
    # Horse information updates
    horse_energy_level: Optional[int] = None
    horse_focus_level: Optional[int] = None
    horse_responsiveness: Optional[int] = None
    horse_notes: Optional[str] = None

class Session(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    rider_id: str
    session_type: str
    ride_type: str
    anxiety_level: Optional[int] = None
    confidence_level: Optional[int] = None
    notes: Optional[str] = None
    strategies_used: List[str] = []
    completed: bool = False
    # Horse information
    horse_energy_level: Optional[int] = None
    horse_focus_level: Optional[int] = None
    horse_responsiveness: Optional[int] = None
    horse_notes: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    completed_at: Optional[datetime] = None

# ==================== AUTH HELPERS ====================

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)) -> dict:
    try:
        token = credentials.credentials
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise HTTPException(status_code=401, detail="Invalid authentication credentials")
        return {"user_id": user_id, "email": payload.get("email")}
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token has expired")
    except jwt.JWTError:
        raise HTTPException(status_code=401, detail="Could not validate credentials")

# ==================== AUTH ROUTES ====================

@api_router.get("/")
async def root():
    return {"message": "EquiMind API - Equestrian Mental Performance Platform"}

@api_router.post("/auth/register", response_model=Token)
async def register(user_data: UserCreate):
    # Check if user exists
    existing_user = await db.users.find_one({"email": user_data.email})
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create new user
    user = User(
        email=user_data.email,
        name=user_data.name,
        hashed_password=hash_password(user_data.password)
    )
    
    await db.users.insert_one(user.dict())
    
    # Create access token
    access_token = create_access_token(data={"sub": user.id, "email": user.email})
    
    return Token(
        access_token=access_token,
        token_type="bearer",
        user=UserResponse(id=user.id, email=user.email, name=user.name)
    )

@api_router.post("/auth/login", response_model=Token)
async def login(credentials: UserLogin):
    # Find user
    user_dict = await db.users.find_one({"email": credentials.email})
    if not user_dict:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
    # Verify password
    if not verify_password(credentials.password, user_dict["hashed_password"]):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
    # Create access token
    access_token = create_access_token(data={"sub": user_dict["id"], "email": user_dict["email"]})
    
    return Token(
        access_token=access_token,
        token_type="bearer",
        user=UserResponse(id=user_dict["id"], email=user_dict["email"], name=user_dict["name"])
    )

@api_router.get("/auth/me", response_model=UserResponse)
async def get_me(current_user: dict = Depends(get_current_user)):
    user_dict = await db.users.find_one({"id": current_user["user_id"]})
    if not user_dict:
        raise HTTPException(status_code=404, detail="User not found")
    return UserResponse(id=user_dict["id"], email=user_dict["email"], name=user_dict["name"])

# ==================== MENTAL STRATEGIES ROUTES ====================

@api_router.get("/mental-strategies")
async def get_mental_strategies(
    category: Optional[str] = None,
    min_anxiety: Optional[int] = None,
    max_anxiety: Optional[int] = None,
    min_confidence: Optional[int] = None,
    max_confidence: Optional[int] = None,
    current_user: dict = Depends(get_current_user)
):
    query = {}
    
    if category:
        query["category"] = {"$regex": category, "$options": "i"}
    
    strategies = await db.mental_strategies.find(query).to_list(1000)
    
    # Remove MongoDB _id field
    for s in strategies:
        if '_id' in s:
            del s['_id']
    
    # Filter by anxiety and confidence levels if provided
    if min_anxiety is not None or max_anxiety is not None or min_confidence is not None or max_confidence is not None:
        filtered = []
        for s in strategies:
            if min_anxiety is not None and not any(l >= min_anxiety for l in s.get("anxiety_level", [])):
                continue
            if max_anxiety is not None and not any(l <= max_anxiety for l in s.get("anxiety_level", [])):
                continue
            if min_confidence is not None and not any(l >= min_confidence for l in s.get("confidence_level", [])):
                continue
            if max_confidence is not None and not any(l <= max_confidence for l in s.get("confidence_level", [])):
                continue
            filtered.append(s)
        return filtered
    
    return strategies

@api_router.get("/mental-strategies/{strategy_id}")
async def get_strategy(strategy_id: str, current_user: dict = Depends(get_current_user)):
    strategy = await db.mental_strategies.find_one({"id": strategy_id})
    if not strategy:
        raise HTTPException(status_code=404, detail="Strategy not found")
    if '_id' in strategy:
        del strategy['_id']
    return strategy

# ==================== SESSION ROUTES ====================

@api_router.post("/sessions", response_model=Session)
async def create_session(session_data: SessionCreate, current_user: dict = Depends(get_current_user)):
    session = Session(
        rider_id=current_user["user_id"],
        session_type=session_data.session_type,
        ride_type=session_data.ride_type,
        anxiety_level=session_data.anxiety_level,
        confidence_level=session_data.confidence_level,
        notes=session_data.notes,
        strategies_used=session_data.strategies_used or [],
        horse_energy_level=session_data.horse_energy_level,
        horse_focus_level=session_data.horse_focus_level,
        horse_responsiveness=session_data.horse_responsiveness,
        horse_notes=session_data.horse_notes
    )
    
    await db.sessions.insert_one(session.dict())
    return session

@api_router.get("/sessions", response_model=List[Session])
async def get_sessions(
    completed: Optional[bool] = None,
    limit: int = 50,
    current_user: dict = Depends(get_current_user)
):
    query = {"rider_id": current_user["user_id"]}
    if completed is not None:
        query["completed"] = completed
    
    sessions = await db.sessions.find(query).sort("created_at", -1).limit(limit).to_list(limit)
    return [Session(**s) for s in sessions]

@api_router.get("/sessions/{session_id}", response_model=Session)
async def get_session(session_id: str, current_user: dict = Depends(get_current_user)):
    session = await db.sessions.find_one({"id": session_id, "rider_id": current_user["user_id"]})
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return Session(**session)

@api_router.patch("/sessions/{session_id}", response_model=Session)
async def update_session(
    session_id: str,
    update_data: SessionUpdate,
    current_user: dict = Depends(get_current_user)
):
    session = await db.sessions.find_one({"id": session_id, "rider_id": current_user["user_id"]})
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    
    update_dict = {k: v for k, v in update_data.dict().items() if v is not None}
    
    if update_data.completed:
        update_dict["completed_at"] = datetime.utcnow()
    
    await db.sessions.update_one(
        {"id": session_id},
        {"$set": update_dict}
    )
    
    updated_session = await db.sessions.find_one({"id": session_id})
    return Session(**updated_session)

@api_router.delete("/sessions/{session_id}")
async def delete_session(session_id: str, current_user: dict = Depends(get_current_user)):
    result = await db.sessions.delete_one({"id": session_id, "rider_id": current_user["user_id"]})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Session not found")
    return {"message": "Session deleted successfully"}

# Include the router in the main app
app.include_router(api_router)

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=["*"],
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
