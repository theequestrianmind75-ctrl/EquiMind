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
load_dotenv(ROOT_DIR / '.env', override=False)

# Setup logger
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# MongoDB setup - with fallbacks for local development
mongo_url = os.environ.get('MONGO_URL', 'mongodb://localhost:27017')
db_name = os.environ.get('DB_NAME', 'equimind')
logger.info(f"🔌 Connecting to MongoDB: {mongo_url.split('@')[-1] if '@' in mongo_url else mongo_url}")
logger.info(f"📊 Using database: {db_name}")
client = AsyncIOMotorClient(mongo_url)
db = client[db_name]

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
    subscription_tier: str = "none"  # "none", "standard", "premium"
    subscription_status: str = "inactive"  # "inactive", "active", "cancelled", "expired"
    subscription_start_date: Optional[datetime] = None
    subscription_end_date: Optional[datetime] = None
    stripe_customer_id: Optional[str] = None
    stripe_subscription_id: Optional[str] = None

class UserResponse(BaseModel):
    id: str
    email: str
    name: str

class Token(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse

class ToolAccess(BaseModel):
    tool_id: str
    tool_name: str
    accessed_at: datetime = Field(default_factory=datetime.utcnow)
    is_emergency: bool = False

class SessionCreate(BaseModel):
    session_type: str  # "pre-ride", "during-ride", "post-ride"
    ride_type: str  # "training", "competition", "trail", etc.
    context: Optional[str] = "training"  # "training" or "competition" - NEW FIELD
    rider_name: Optional[str] = None
    anxiety_level: Optional[int] = None
    confidence_level: Optional[int] = None
    rider_energy_level: Optional[int] = None  # 1-10 scale - NEW FIELD
    notes: Optional[str] = None
    strategies_used: Optional[List[str]] = []
    # Horse information
    horse_name: Optional[str] = None
    horse_energy_level: Optional[int] = None  # 1-10 scale
    horse_focus_level: Optional[int] = None  # 1-10 scale
    horse_responsiveness: Optional[int] = None  # 1-10 scale
    horse_notes: Optional[str] = None

class SessionUpdate(BaseModel):
    context: Optional[str] = None  # "training" or "competition" - NEW FIELD
    rider_name: Optional[str] = None
    anxiety_level: Optional[int] = None
    confidence_level: Optional[int] = None
    rider_energy_level: Optional[int] = None  # NEW FIELD
    notes: Optional[str] = None
    strategies_used: Optional[List[str]] = None
    completed: Optional[bool] = None
    # Horse information updates
    horse_name: Optional[str] = None
    horse_energy_level: Optional[int] = None
    horse_focus_level: Optional[int] = None
    horse_responsiveness: Optional[int] = None
    horse_notes: Optional[str] = None

class FeedbackCreate(BaseModel):
    session_id: str
    rating: int  # 1-5 stars
    comment: Optional[str] = None

class Feedback(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    session_id: str
    rating: int
    comment: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)

class SubscriptionTier(BaseModel):
    tier_id: str  # "standard" or "premium"
    name: str  # "Standard" or "Premium"
    price_monthly: float  # 25.00 or 35.00
    features: List[str]
    description: str

class SubscriptionUpdate(BaseModel):
    subscription_tier: str  # "standard" or "premium"
    subscription_status: str  # "active", "cancelled", "expired"
    subscription_start_date: Optional[datetime] = None
    subscription_end_date: Optional[datetime] = None

class Session(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    rider_id: str
    session_type: str
    ride_type: str
    context: str = "training"  # "training" or "competition" - NEW FIELD
    rider_name: Optional[str] = None
    anxiety_level: Optional[int] = None
    confidence_level: Optional[int] = None
    rider_energy_level: Optional[int] = None  # NEW FIELD
    notes: Optional[str] = None
    strategies_used: List[str] = []
    completed: bool = False
    # Horse information
    horse_name: Optional[str] = None
    horse_energy_level: Optional[int] = None
    horse_focus_level: Optional[int] = None
    horse_responsiveness: Optional[int] = None
    horse_notes: Optional[str] = None
    # During-ride tool tracking
    tools_accessed_during_ride: List[dict] = []  # List of {tool_id, tool_name, accessed_at, is_emergency, is_breathing}
    regular_tools_count: int = 0  # Count of regular (non-breathing, non-emergency) tools accessed
    breathing_tools_count: int = 0  # Count of breathing exercises accessed (separate 4-use limit)
    emergency_tools_count: int = 0  # Count of emergency tools accessed
    created_at: datetime = Field(default_factory=datetime.utcnow)
    completed_at: Optional[datetime] = None

class StrategyUpdate(BaseModel):
    name: Optional[str] = None
    category: Optional[str] = None
    description: Optional[str] = None
    instructions: Optional[str] = None
    duration_minutes: Optional[int] = None
    anxiety_level: Optional[List[int]] = None
    confidence_level: Optional[List[int]] = None

class RecommendationCreate(BaseModel):
    text: str  # The recommendation text
    trigger_condition: str  # e.g., "high_anxiety", "low_confidence", "anxiety_increased"
    priority: int = 1  # Higher priority shows first
    active: bool = True
    suggested_tool_names: Optional[List[str]] = []  # Tool names to suggest

class RecommendationUpdate(BaseModel):
    text: Optional[str] = None
    trigger_condition: Optional[str] = None
    priority: Optional[int] = None
    active: Optional[bool] = None
    suggested_tool_names: Optional[List[str]] = None

class Recommendation(BaseModel):
    id: str
    text: str
    trigger_condition: str
    priority: int
    active: bool
    suggested_tool_names: List[str] = []
    created_at: datetime

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

@api_router.post("/auth/check-email")
async def check_email(request: dict):
    """Check if an email exists in the database"""
    email = request.get("email")
    if not email:
        raise HTTPException(status_code=400, detail="Email is required")
    
    user = await db.users.find_one({"email": email})
    return {"exists": user is not None}

@api_router.post("/auth/reset-password")
async def reset_password(request: dict):
    """Reset user password - no email verification for MVP"""
    email = request.get("email")
    new_password = request.get("new_password")
    
    if not email or not new_password:
        raise HTTPException(status_code=400, detail="Email and new password are required")
    
    if len(new_password) < 6:
        raise HTTPException(status_code=400, detail="Password must be at least 6 characters")
    
    # Find user
    user = await db.users.find_one({"email": email})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Update password
    hashed_password = hash_password(new_password)
    await db.users.update_one(
        {"email": email},
        {"$set": {"hashed_password": hashed_password}}
    )
    
    return {"message": "Password reset successfully"}

# ==================== MENTAL STRATEGIES ROUTES ====================

@api_router.get("/mental-strategies")
async def get_mental_strategies(
    category: Optional[str] = None,
    min_anxiety: Optional[int] = None,
    max_anxiety: Optional[int] = None,
    min_confidence: Optional[int] = None,
    max_confidence: Optional[int] = None
):
    query = {}
    
    if category:
        query["category"] = {"$regex": category, "$options": "i"}
    
    # Define projection to fetch only required fields for better performance
    projection = {
        "_id": 1, "id": 1, "name": 1, "category": 1, 
        "instructions": 1, "anxiety_level": 1, "confidence_level": 1,
        "duration_minutes": 1, "is_crisis_tool": 1, "effectiveness_rating": 1
    }
    strategies = await db.mental_strategies.find(query, projection).limit(500).to_list(500)
    
    # Remove MongoDB _id and ensure id field exists
    for strategy in strategies:
        if '_id' in strategy:
            # If no 'id' field, use _id as id
            if 'id' not in strategy:
                strategy['id'] = str(strategy['_id'])
            del strategy['_id']
    
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
async def get_strategy(strategy_id: str):
    # Try to find by 'id' field first
    strategy = await db.mental_strategies.find_one({"id": strategy_id})
    
    # If not found, try finding by _id (MongoDB ObjectId)
    if not strategy:
        try:
            from bson import ObjectId
            strategy = await db.mental_strategies.find_one({"_id": ObjectId(strategy_id)})
        except Exception:
            pass
    
    if not strategy:
        raise HTTPException(status_code=404, detail="Strategy not found")
    
    if '_id' in strategy:
        # If no 'id' field, use _id as id
        if 'id' not in strategy:
            strategy['id'] = str(strategy['_id'])
        del strategy['_id']
    return strategy

@api_router.patch("/mental-strategies/{strategy_id}")
async def update_strategy(
    strategy_id: str,
    update_data: StrategyUpdate,
    current_user: dict = Depends(get_current_user)
):
    """Update a mental strategy - admin function"""
    # Try to find by 'id' field first
    strategy = await db.mental_strategies.find_one({"id": strategy_id})
    query_field = {"id": strategy_id}
    
    # If not found, try finding by _id (MongoDB ObjectId)
    if not strategy:
        try:
            from bson import ObjectId
            strategy = await db.mental_strategies.find_one({"_id": ObjectId(strategy_id)})
            query_field = {"_id": ObjectId(strategy_id)}
        except Exception:
            pass
    
    if not strategy:
        raise HTTPException(status_code=404, detail="Strategy not found")
    
    # Build update dict with only provided fields
    update_dict = {k: v for k, v in update_data.dict().items() if v is not None}
    
    if not update_dict:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    # Update the strategy
    await db.mental_strategies.update_one(
        query_field,
        {"$set": update_dict}
    )
    
    # Return updated strategy
    updated_strategy = await db.mental_strategies.find_one(query_field)
    if '_id' in updated_strategy:
        # If no 'id' field, use _id as id
        if 'id' not in updated_strategy:
            updated_strategy['id'] = str(updated_strategy['_id'])
        del updated_strategy['_id']
    return updated_strategy

@api_router.post("/mental-strategies/bulk-update")
async def bulk_update_strategies(
    updates: List[dict],
    current_user: dict = Depends(get_current_user)
):
    """Bulk update multiple strategies - admin function using bulk_write for performance"""
    from pymongo import UpdateOne
    
    bulk_operations = []
    
    for update in updates:
        strategy_id = update.get("id")
        if not strategy_id:
            continue
        
        # Build update dict
        update_dict = {}
        if "instructions" in update:
            update_dict["instructions"] = update["instructions"]
        if "name" in update:
            update_dict["name"] = update["name"]
        if "category" in update:
            update_dict["category"] = update["category"]
        if "duration_minutes" in update:
            update_dict["duration_minutes"] = update["duration_minutes"]
        
        if update_dict:
            bulk_operations.append(
                UpdateOne({"id": strategy_id}, {"$set": update_dict}, upsert=False)
            )
    
    # Execute all updates in a single database call
    if bulk_operations:
        result = await db.mental_strategies.bulk_write(bulk_operations, ordered=False)
        updated_count = result.modified_count
    else:
        updated_count = 0
    
    return {"updated": updated_count, "total": len(updates)}

# ==================== ADMIN ROUTES (NO JWT REQUIRED) ====================

class AdminAuth(BaseModel):
    password: str

ADMIN_PASSWORD = os.environ.get('ADMIN_PASSWORD', 'equimind2025')

@api_router.post("/admin/mental-strategies")
async def get_admin_mental_strategies(auth: AdminAuth):
    """Get all mental strategies for admin text editor - password protected"""
    if auth.password != ADMIN_PASSWORD:
        raise HTTPException(status_code=401, detail="Invalid admin password")
    
    strategies = await db.mental_strategies.find({}).to_list(1000)
    
    # Remove MongoDB _id and ensure id field exists
    for strategy in strategies:
        if '_id' in strategy:
            # If no 'id' field, use _id as id
            if 'id' not in strategy:
                strategy['id'] = str(strategy['_id'])
            del strategy['_id']
    
    return strategies

@api_router.post("/admin/bulk-update")
async def admin_bulk_update_strategies(
    request: dict
):
    """Bulk update strategies for admin - password protected"""
    password = request.get("password")
    if password != ADMIN_PASSWORD:
        raise HTTPException(status_code=401, detail="Invalid admin password")
    
    updates = request.get("updates", [])
    logger.info(f"📝 Bulk update request: {len(updates)} tools to update")
    
    from pymongo import UpdateOne
    
    bulk_operations = []
    skipped_count = 0
    
    for update in updates:
        strategy_id = update.get("id")
        if not strategy_id:
            logger.warning(f"⚠️  Skipping update - no ID provided")
            skipped_count += 1
            continue
        
        # Build update dict - only update if value is provided and not empty
        update_dict = {}
        if "instructions" in update and update["instructions"]:
            update_dict["instructions"] = update["instructions"]
        if "name" in update and update["name"]:
            update_dict["name"] = update["name"]
        if "category" in update and update["category"]:
            update_dict["category"] = update["category"]
        if "duration_minutes" in update:
            update_dict["duration_minutes"] = update["duration_minutes"]
        
        if update_dict:
            bulk_operations.append(
                UpdateOne({"id": strategy_id}, {"$set": update_dict}, upsert=False)
            )
        else:
            logger.warning(f"⚠️  No valid fields to update for tool ID: {strategy_id}")
            skipped_count += 1
    
    # Execute all updates in a single database call for better performance
    if bulk_operations:
        result = await db.mental_strategies.bulk_write(bulk_operations, ordered=False)
        updated_count = result.modified_count
    else:
        updated_count = 0
    
    logger.info(f"✅ Bulk update complete: {updated_count} updated, {skipped_count} skipped")
    return {"updated": updated_count, "total": len(updates), "skipped": skipped_count}

# ==================== SESSION ROUTES ====================

@api_router.post("/sessions", response_model=Session)
async def create_session(session_data: SessionCreate, current_user: dict = Depends(get_current_user)):
    session = Session(
        rider_id=current_user["user_id"],
        session_type=session_data.session_type,
        ride_type=session_data.ride_type,
        rider_name=session_data.rider_name,
        anxiety_level=session_data.anxiety_level,
        confidence_level=session_data.confidence_level,
        notes=session_data.notes,
        strategies_used=session_data.strategies_used or [],
        horse_name=session_data.horse_name,
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
    limit: int = 50
):
    query = {}
    if completed is not None:
        query["completed"] = completed
    
    sessions = await db.sessions.find(query).sort("created_at", -1).limit(limit).to_list(limit)
    return [Session(**s) for s in sessions]

@api_router.get("/sessions/{session_id}", response_model=Session)
async def get_session(session_id: str):
    session = await db.sessions.find_one({"id": session_id})
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return Session(**session)

@api_router.patch("/sessions/{session_id}", response_model=Session)
async def update_session(
    session_id: str,
    update_data: SessionUpdate
):
    session = await db.sessions.find_one({"id": session_id})
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

# ==================== DURING-RIDE SMART RECOMMENDATIONS ====================

@api_router.get("/during-ride/recommendations/{session_id}")
async def get_during_ride_recommendations(session_id: str):
    """
    Get smart tool recommendations based on pre-ride data
    Returns:
    - start_of_ride: 1 grounding tool (always shown)
    - during_ride: 2 tools based on anxiety/confidence/energy levels
    - emergency: 1 critical calming tool (always available, bypasses limits)
    """
    # Get the current session
    session = await db.sessions.find_one({"id": session_id})
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    
    anxiety_level = session.get("anxiety_level") or 5
    confidence_level = session.get("confidence_level") or 5
    rider_energy = session.get("rider_energy_level") or 5
    
    # Get all mental strategies
    all_strategies = await db.mental_strategies.find({}).to_list(length=1000)
    
    # Initialize recommendations
    recommendations = {
        "session_id": session_id,
        "start_of_ride": None,
        "during_ride": [],
        "emergency": None,
        "remaining_regular_tools": 2 - session.get("regular_tools_count", 0),
        "remaining_breathing_tools": 4 - session.get("breathing_tools_count", 0),
        "tools_accessed": session.get("tools_accessed_during_ride", [])
    }
    
    # START OF RIDE - Grounding/Centering tool
    grounding_tools = [s for s in all_strategies if "grounding" in s.get("name", "").lower() or 
                       "centering" in s.get("name", "").lower() or
                       "present" in s.get("name", "").lower() or
                       s.get("category", "") == "Mindfulness & Flow"]
    if grounding_tools:
        recommendations["start_of_ride"] = {
            "id": str(grounding_tools[0].get("_id", grounding_tools[0].get("id"))),
            "name": grounding_tools[0].get("name"),
            "category": grounding_tools[0].get("category"),
            "instructions": grounding_tools[0].get("instructions"),
            "reason": "Perfect to ground yourself and set intentions before starting"
        }
    
    # DURING RIDE - Smart recommendations based on pre-ride state
    # Exclude the start_of_ride tool to avoid duplicates
    start_of_ride_id = str(grounding_tools[0].get("_id", grounding_tools[0].get("id"))) if grounding_tools else None
    during_ride_tools = []
    
    # High anxiety (7-10) → Calming/breathing tools
    if anxiety_level >= 7:
        calming_tools = [s for s in all_strategies if 
                        s.get("category", "") in ["Breathing/HRV", "BODY RESET"] and
                        ("calm" in s.get("name", "").lower() or 
                         "breath" in s.get("name", "").lower() or
                         "relax" in s.get("name", "").lower()) and
                        str(s.get("_id", s.get("id"))) != start_of_ride_id]
        during_ride_tools.extend(calming_tools[:2])
        reason = "Your pre-ride anxiety was high - these tools will help calm your nervous system"
    
    # Low confidence (1-4) → Confidence-building tools
    elif confidence_level <= 4:
        confidence_tools = [s for s in all_strategies if 
                           ("confidence" in s.get("name", "").lower() or
                            "power" in s.get("name", "").lower() or
                            s.get("category", "") == "Tapping/EFT") and
                           str(s.get("_id", s.get("id"))) != start_of_ride_id]
        during_ride_tools.extend(confidence_tools[:2])
        reason = "Your pre-ride confidence was low - these tools will boost your self-assurance"
    
    # Low energy (1-4) → Energizing tools
    elif rider_energy <= 4:
        energy_tools = [s for s in all_strategies if 
                       ("energy" in s.get("name", "").lower() or
                        "activate" in s.get("name", "").lower() or
                        "power" in s.get("name", "").lower()) and
                       str(s.get("_id", s.get("id"))) != start_of_ride_id]
        during_ride_tools.extend(energy_tools[:2])
        reason = "Your pre-ride energy was low - these tools will help energize you"
    
    # Moderate levels → Breathing/body reset tools (NOT Mindfulness to avoid overlap)
    else:
        moderate_tools = [s for s in all_strategies if 
                         s.get("category", "") in ["Breathing/HRV", "BODY RESET"] and
                         str(s.get("_id", s.get("id"))) != start_of_ride_id]
        during_ride_tools.extend(moderate_tools[:2])
        reason = "These tools will help you maintain focus and presence during your ride"
    
    # Format during ride recommendations
    for tool in during_ride_tools[:2]:  # Max 2 tools
        recommendations["during_ride"].append({
            "id": str(tool.get("_id", tool.get("id"))),
            "name": tool.get("name"),
            "category": tool.get("category"),
            "instructions": tool.get("instructions"),
            "reason": reason
        })
    
    # EMERGENCY - Always available, bypasses limit
    emergency_tools = [s for s in all_strategies if 
                      s.get("category", "") == "Distress Tolerance" or
                      "crisis" in s.get("name", "").lower() or
                      "emergency" in s.get("name", "").lower()]
    
    # If no specific emergency tools, use powerful calming tools
    if not emergency_tools:
        emergency_tools = [s for s in all_strategies if 
                          s.get("category", "") == "Breathing/HRV" and
                          ("calm" in s.get("name", "").lower() or "breath" in s.get("name", "").lower())]
    
    if emergency_tools:
        recommendations["emergency"] = {
            "id": str(emergency_tools[0].get("_id", emergency_tools[0].get("id"))),
            "name": emergency_tools[0].get("name"),
            "category": emergency_tools[0].get("category"),
            "instructions": emergency_tools[0].get("instructions"),
            "reason": "Use this anytime you need immediate support - no limits"
        }
    
    return recommendations

@api_router.post("/during-ride/track-tool-access/{session_id}")
async def track_tool_access(session_id: str, tool_id: str, tool_name: str, tool_category: str = "", is_emergency: bool = False):
    """
    Track when a tool is accessed during a ride
    Enforces:
    - 2-tool limit for regular (non-breathing) tools
    - 4-tool limit for breathing exercises
    - Unlimited for emergency tools
    """
    # Get the current session
    session = await db.sessions.find_one({"id": session_id})
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    
    regular_count = session.get("regular_tools_count", 0)
    breathing_count = session.get("breathing_tools_count", 0)
    emergency_count = session.get("emergency_tools_count", 0)
    
    # Determine if this is a breathing exercise
    is_breathing = ("breathing" in tool_category.lower() or 
                   "hrv" in tool_category.lower() or 
                   "body reset" in tool_category.lower())
    
    # Check limits
    if not is_emergency:
        if is_breathing and breathing_count >= 4:
            raise HTTPException(
                status_code=400, 
                detail="Breathing exercise limit reached. You can access up to 4 breathing exercises per ride session."
            )
        elif not is_breathing and regular_count >= 2:
            raise HTTPException(
                status_code=400, 
                detail="Tool limit reached. You can access up to 2 regular tools per ride session. Breathing exercises have a separate limit of 4."
            )
    
    # Create tool access record
    tool_access = {
        "tool_id": tool_id,
        "tool_name": tool_name,
        "accessed_at": datetime.utcnow().isoformat(),
        "is_emergency": is_emergency,
        "is_breathing": is_breathing
    }
    
    # Update session
    update_data = {
        "$push": {"tools_accessed_during_ride": tool_access}
    }
    
    if is_emergency:
        update_data["$inc"] = {"emergency_tools_count": 1}
    elif is_breathing:
        update_data["$inc"] = {"breathing_tools_count": 1}
    else:
        update_data["$inc"] = {"regular_tools_count": 1}
    
    await db.sessions.update_one({"id": session_id}, update_data)
    
    # Return updated counts
    return {
        "success": True,
        "tool_accessed": tool_name,
        "is_emergency": is_emergency,
        "is_breathing": is_breathing,
        "regular_tools_remaining": 2 - (regular_count + (0 if (is_emergency or is_breathing) else 1)),
        "breathing_tools_remaining": 4 - (breathing_count + (1 if (is_breathing and not is_emergency) else 0)),
        "total_emergency_accesses": emergency_count + (1 if is_emergency else 0)
    }

# ==================== RECOMMENDATIONS ENDPOINTS ====================

@api_router.get("/trends")
async def get_trends():
    """Analyze trends across last 5 completed sessions"""
    # Get last 5 completed sessions
    sessions = await db.sessions.find({"completed": True}).sort("created_at", -1).limit(5).to_list(5)
    
    if len(sessions) < 2:
        return {
            "has_enough_data": False,
            "message": "Complete at least 2 sessions to see trends",
            "session_count": len(sessions)
        }
    
    # Calculate trends
    anxiety_levels = []
    confidence_levels = []
    ride_types = []
    horse_energy_levels = []
    horse_focus_levels = []
    
    for session in reversed(sessions):  # Oldest to newest
        if session.get("anxiety_level"):
            anxiety_levels.append(session["anxiety_level"])
        if session.get("confidence_level"):
            confidence_levels.append(session["confidence_level"])
        if session.get("ride_type"):
            ride_types.append(session["ride_type"])
        if session.get("horse_energy_level"):
            horse_energy_levels.append(session["horse_energy_level"])
        if session.get("horse_focus_level"):
            horse_focus_levels.append(session["horse_focus_level"])
    
    # Calculate anxiety trend
    anxiety_trend = "stable"
    if len(anxiety_levels) >= 2:
        if anxiety_levels[-1] < anxiety_levels[0] - 1:
            anxiety_trend = "decreasing"
        elif anxiety_levels[-1] > anxiety_levels[0] + 1:
            anxiety_trend = "increasing"
    
    # Calculate confidence trend
    confidence_trend = "stable"
    if len(confidence_levels) >= 2:
        if confidence_levels[-1] > confidence_levels[0] + 1:
            confidence_trend = "increasing"
        elif confidence_levels[-1] < confidence_levels[0] - 1:
            confidence_trend = "decreasing"
    
    # Find best session (lowest anxiety + highest confidence)
    best_session = None
    best_score = -999
    for session in sessions:
        anxiety = session.get("anxiety_level", 5)
        confidence = session.get("confidence_level", 5)
        score = confidence - anxiety  # Higher is better
        if score > best_score:
            best_score = score
            best_session = session
    
    # Pattern detection
    patterns = []
    
    # Competition anxiety pattern
    competition_sessions = [s for s in sessions if s.get("ride_type") == "competition"]
    if len(competition_sessions) >= 2:
        comp_avg_anxiety = sum(s.get("anxiety_level", 5) for s in competition_sessions) / len(competition_sessions)
        if comp_avg_anxiety > 6:
            patterns.append({
                "type": "competition_anxiety",
                "message": "You tend to have higher anxiety during competitions",
                "severity": "moderate"
            })
    
    # Confidence building pattern - only show if trend is NOT decreasing
    if len(confidence_levels) >= 3 and confidence_trend != "decreasing":
        recent_avg = sum(confidence_levels[-3:]) / 3
        if recent_avg > 6.5:  # Raised threshold to be more selective
            patterns.append({
                "type": "confidence_building",
                "message": "Your confidence has been consistently strong recently",
                "severity": "positive"
            })
    
    # Confidence declining pattern - show if decreasing
    if confidence_trend == "decreasing" and len(confidence_levels) >= 2:
        patterns.append({
            "type": "confidence_declining",
            "message": "Your confidence has decreased from earlier sessions - consider reviewing what changed",
            "severity": "moderate"
        })
    
    # Horse focus pattern
    if len(horse_focus_levels) >= 3:
        avg_focus = sum(horse_focus_levels) / len(horse_focus_levels)
        if avg_focus < 5:
            patterns.append({
                "type": "horse_focus_low",
                "message": "Your horse's focus has been lower than ideal across sessions",
                "severity": "moderate"
            })
    
    return {
        "has_enough_data": True,
        "session_count": len(sessions),
        "anxiety": {
            "current": anxiety_levels[-1] if anxiety_levels else None,
            "average": sum(anxiety_levels) / len(anxiety_levels) if anxiety_levels else None,
            "trend": anxiety_trend,
            "history": anxiety_levels
        },
        "confidence": {
            "current": confidence_levels[-1] if confidence_levels else None,
            "average": sum(confidence_levels) / len(confidence_levels) if confidence_levels else None,
            "trend": confidence_trend,
            "history": confidence_levels
        },
        "horse": {
            "avg_energy": sum(horse_energy_levels) / len(horse_energy_levels) if horse_energy_levels else None,
            "avg_focus": sum(horse_focus_levels) / len(horse_focus_levels) if horse_focus_levels else None,
        },
        "best_session": {
            "id": best_session.get("id") if best_session else None,
            "ride_type": best_session.get("ride_type") if best_session else None,
            "anxiety": best_session.get("anxiety_level") if best_session else None,
            "confidence": best_session.get("confidence_level") if best_session else None,
            "created_at": best_session.get("created_at") if best_session else None
        } if best_session else None,
        "patterns": patterns,
        "ride_type_distribution": {
            "training": ride_types.count("training"),
            "competition": ride_types.count("competition"),
            "trail": ride_types.count("trail"),
            "lesson": ride_types.count("lesson")
        }
    }

@api_router.get("/recommendations", response_model=List[Recommendation])
async def get_recommendations():
    """Get all active recommendations"""
    recommendations = await db.recommendations.find({"active": True}).sort("priority", -1).to_list(length=100)
    return [
        Recommendation(
            id=str(rec["_id"]),
            text=rec["text"],
            trigger_condition=rec["trigger_condition"],
            priority=rec["priority"],
            active=rec["active"],
            suggested_tool_names=rec.get("suggested_tool_names", []),
            created_at=rec.get("created_at", datetime.utcnow())
        )
        for rec in recommendations
    ]

@api_router.get("/admin/recommendations", response_model=List[Recommendation])
async def get_all_recommendations_admin():
    """Get all recommendations (including inactive) - Admin only"""
    recommendations = await db.recommendations.find({}).sort("priority", -1).to_list(length=1000)
    return [
        Recommendation(
            id=str(rec["_id"]),
            text=rec["text"],
            trigger_condition=rec["trigger_condition"],
            priority=rec["priority"],
            active=rec["active"],
            created_at=rec.get("created_at", datetime.utcnow())
        )
        for rec in recommendations
    ]

@api_router.post("/admin/recommendations", response_model=Recommendation)
async def create_recommendation(rec_data: RecommendationCreate):
    """Create new recommendation - Admin only"""
    rec_id = str(uuid.uuid4())
    rec_dict = {
        "_id": rec_id,
        "id": rec_id,
        "text": rec_data.text,
        "trigger_condition": rec_data.trigger_condition,
        "priority": rec_data.priority,
        "active": rec_data.active,
        "created_at": datetime.utcnow()
    }
    await db.recommendations.insert_one(rec_dict)
    return Recommendation(**rec_dict)

@api_router.patch("/admin/recommendations/{rec_id}", response_model=Recommendation)
async def update_recommendation(rec_id: str, rec_update: RecommendationUpdate):
    """Update recommendation - Admin only"""
    update_data = {k: v for k, v in rec_update.dict().items() if v is not None}
    if not update_data:
        raise HTTPException(status_code=400, detail="No update data provided")
    
    result = await db.recommendations.update_one(
        {"id": rec_id},
        {"$set": update_data}
    )
    
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Recommendation not found")
    
    updated_rec = await db.recommendations.find_one({"id": rec_id})
    return Recommendation(
        id=str(updated_rec["_id"]),
        text=updated_rec["text"],
        trigger_condition=updated_rec["trigger_condition"],
        priority=updated_rec["priority"],
        active=updated_rec["active"],
        created_at=updated_rec.get("created_at", datetime.utcnow())
    )

@api_router.delete("/admin/recommendations/{rec_id}")
async def delete_recommendation(rec_id: str):
    """Delete recommendation - Admin only"""
    result = await db.recommendations.delete_one({"id": rec_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Recommendation not found")
    return {"message": "Recommendation deleted successfully"}

# ==================== ADMIN DASHBOARD ROUTES ====================

@api_router.post("/admin/users")
async def get_all_users(auth: AdminAuth):
    """Get all users for admin dashboard - password protected"""
    if auth.password != ADMIN_PASSWORD:
        raise HTTPException(status_code=401, detail="Invalid admin password")
    
    users = await db.users.find({}, {"hashed_password": 0}).to_list(1000)
    
    # Convert _id to string and remove it
    for user in users:
        if '_id' in user:
            del user['_id']
    
    return users

@api_router.post("/admin/sessions/all")
async def get_all_sessions(auth: AdminAuth):
    """Get all sessions for admin dashboard - password protected"""
    if auth.password != ADMIN_PASSWORD:
        raise HTTPException(status_code=401, detail="Invalid admin password")
    
    sessions = await db.sessions.find({}).to_list(5000)
    
    # Convert _id to string and remove it
    for session in sessions:
        if '_id' in session:
            del session['_id']
    
    return sessions

@api_router.post("/admin/analytics")
async def get_admin_analytics(auth: AdminAuth):
    """Get analytics for admin dashboard - password protected"""
    if auth.password != ADMIN_PASSWORD:
        raise HTTPException(status_code=401, detail="Invalid admin password")
    
    # Get counts
    total_users = await db.users.count_documents({})
    total_tools = await db.mental_strategies.count_documents({})
    total_sessions = await db.sessions.count_documents({})
    
    # Get recent sessions (last 30 days)
    from datetime import datetime, timedelta
    thirty_days_ago = datetime.utcnow() - timedelta(days=30)
    recent_sessions = await db.sessions.count_documents({"created_at": {"$gte": thirty_days_ago}})
    
    # Get most used tools
    pipeline = [
        {"$unwind": "$tools_accessed"},
        {"$group": {"_id": "$tools_accessed.tool_name", "count": {"$sum": 1}}},
        {"$sort": {"count": -1}},
        {"$limit": 10}
    ]
    most_used_tools = await db.sessions.aggregate(pipeline).to_list(10)
    
    # Get category distribution
    category_pipeline = [
        {"$group": {"_id": "$category", "count": {"$sum": 1}}},
        {"$sort": {"count": -1}}
    ]
    category_distribution = await db.mental_strategies.aggregate(category_pipeline).to_list(10)
    
    return {
        "total_users": total_users,
        "total_tools": total_tools,
        "total_sessions": total_sessions,
        "recent_sessions_30d": recent_sessions,
        "most_used_tools": most_used_tools,
        "category_distribution": category_distribution
    }

@api_router.post("/admin/tools/delete")
async def admin_delete_tool(request: dict):
    """Delete a tool - password protected"""
    password = request.get("password")
    if password != ADMIN_PASSWORD:
        raise HTTPException(status_code=401, detail="Invalid admin password")
    
    tool_id = request.get("tool_id")
    if not tool_id:
        raise HTTPException(status_code=400, detail="Tool ID is required")
    
    result = await db.mental_strategies.delete_one({"id": tool_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Tool not found")
    
    return {"message": "Tool deleted successfully", "tool_id": tool_id}

@api_router.post("/admin/tools/create")
async def admin_create_tool(request: dict):
    """Create a new tool - password protected"""
    password = request.get("password")
    if password != ADMIN_PASSWORD:
        raise HTTPException(status_code=401, detail="Invalid admin password")
    
    tool_data = request.get("tool")
    if not tool_data:
        raise HTTPException(status_code=400, detail="Tool data is required")
    
    # Generate new ID if not provided
    if "id" not in tool_data or not tool_data["id"]:
        tool_data["id"] = str(uuid.uuid4())
    
    # Insert the tool
    await db.mental_strategies.insert_one(tool_data)
    
    return {"message": "Tool created successfully", "tool_id": tool_data["id"]}

@api_router.post("/admin/user/delete")
async def admin_delete_user(request: dict):
    """Delete a user - password protected"""
    password = request.get("password")
    if password != ADMIN_PASSWORD:
        raise HTTPException(status_code=401, detail="Invalid admin password")
    
    user_id = request.get("user_id")
    if not user_id:
        raise HTTPException(status_code=400, detail="User ID is required")
    
    result = await db.users.delete_one({"id": user_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="User not found")
    
    return {"message": "User deleted successfully", "user_id": user_id}

# ==================== SUBSCRIPTION ROUTES ====================

@api_router.get("/subscriptions/tiers")
async def get_subscription_tiers():
    """Get available subscription tiers"""
    tiers = [
        {
            "tier_id": "standard",
            "name": "Standard",
            "price_monthly": 25.00,
            "price_display": "$25/month",
            "features": [
                "All 205 mental performance tools",
                "Voice-guided coaching during rides",
                "Session tracking & analytics",
                "Post-ride reflection tools",
                "Personalized tool recommendations"
            ],
            "description": "Everything you need for mental performance"
        },
        {
            "tier_id": "premium",
            "name": "Premium",
            "price_monthly": 35.00,
            "price_display": "$35/month",
            "features": [
                "All 205 mental performance tools",
                "Voice-guided coaching during rides",
                "Session tracking & analytics",
                "Post-ride reflection tools",
                "Personalized tool recommendations",
                "Access to all video courses",
                "Digital downloads & guides",
                "Advanced training materials",
                "Exclusive premium content"
            ],
            "description": "Complete equestrian mental training package"
        }
    ]
    return tiers

@api_router.get("/subscriptions/status")
async def get_subscription_status(current_user: dict = Depends(get_current_user)):
    """Get current user's subscription status"""
    user = await db.users.find_one({"id": current_user["user_id"]})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    return {
        "user_id": user["id"],
        "subscription_tier": user.get("subscription_tier", "none"),
        "subscription_status": user.get("subscription_status", "inactive"),
        "subscription_start_date": user.get("subscription_start_date"),
        "subscription_end_date": user.get("subscription_end_date"),
        "has_access": user.get("subscription_status") == "active"
    }

@api_router.post("/subscriptions/update")
async def update_subscription(
    subscription_data: SubscriptionUpdate,
    current_user: dict = Depends(get_current_user)
):
    """Update user subscription (called after successful payment)"""
    user_id = current_user["user_id"]
    
    # Update user subscription in database
    await db.users.update_one(
        {"id": user_id},
        {"$set": {
            "subscription_tier": subscription_data.subscription_tier,
            "subscription_status": subscription_data.subscription_status,
            "subscription_start_date": subscription_data.subscription_start_date or datetime.utcnow(),
            "subscription_end_date": subscription_data.subscription_end_date
        }}
    )
    
    return {
        "success": True,
        "message": f"Subscription updated to {subscription_data.subscription_tier}",
        "subscription_tier": subscription_data.subscription_tier,
        "subscription_status": subscription_data.subscription_status
    }

# ==================== FEEDBACK ROUTES ====================

@api_router.post("/feedback", response_model=Feedback)
async def submit_feedback(feedback: FeedbackCreate, current_user: dict = Depends(get_current_user)):
    """Submit feedback for a session"""
    # Verify session exists and belongs to user
    session = await db.sessions.find_one({"id": feedback.session_id, "rider_id": current_user["user_id"]})
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    
    # Create feedback
    feedback_data = Feedback(
        user_id=current_user["user_id"],
        session_id=feedback.session_id,
        rating=feedback.rating,
        comment=feedback.comment
    )
    
    await db.feedback.insert_one(feedback_data.model_dump())
    return feedback_data

@api_router.post("/admin/feedback")
async def get_all_feedback(auth: AdminAuth):
    """Get all feedback for admin dashboard - password protected"""
    if auth.password != ADMIN_PASSWORD:
        raise HTTPException(status_code=401, detail="Invalid admin password")
    
    # Get all feedback with user and session info
    feedback_list = await db.feedback.find({}).sort("created_at", -1).to_list(1000)
    
    # Enrich with user and session data
    for feedback in feedback_list:
        # Get user info
        user = await db.users.find_one({"id": feedback["user_id"]}, {"email": 1, "name": 1})
        if user:
            feedback["user_email"] = user.get("email", "Unknown")
            feedback["user_name"] = user.get("name", "Unknown")
        
        # Get session info
        session = await db.sessions.find_one({"id": feedback["session_id"]}, {"session_type": 1, "ride_type": 1, "created_at": 1})
        if session:
            feedback["session_type"] = session.get("session_type", "Unknown")
            feedback["ride_type"] = session.get("ride_type", "Unknown")
            feedback["session_date"] = session.get("created_at")
        
        # Remove internal _id
        if '_id' in feedback:
            del feedback['_id']
    
    return feedback_list

# ==================== EXPORT ROUTE ====================

@app.get("/export/tools")
async def export_tools():
    """Download all rider tools as CSV file - public endpoint"""
    # Use Path for cross-environment compatibility
    file_path = Path(__file__).parent.parent / "rider_tools_export.csv"
    if not file_path.exists():
        raise HTTPException(status_code=404, detail="Export file not found")
    return FileResponse(
        path=str(file_path),
        filename="equimind_rider_tools.csv",
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=equimind_rider_tools.csv"}
    )

# Admin dashboard route
@app.get("/admin")
async def admin_dashboard():
    """Serve the admin dashboard"""
    admin_file = Path(__file__).parent / "static" / "admin.html"
    if not admin_file.exists():
        raise HTTPException(status_code=404, detail="Admin dashboard not found")
    return FileResponse(
        path=str(admin_file),
        media_type="text/html",
        headers={"Cache-Control": "no-cache"}
    )

# Root health check endpoint
@app.get("/")
async def root():
    """Health check endpoint for the root path"""
    return {
        "status": "healthy",
        "app": "EquiMind API",
        "version": "1.0.0",
        "message": "Welcome to EquiMind API. Visit /docs for API documentation."
    }

# Kubernetes health check endpoints
@app.get("/health")
async def health_check():
    """Health check endpoint for Kubernetes liveness probe"""
    return {"status": "healthy", "service": "equimind-api"}

@app.get("/healthz")
async def healthz():
    """Alternative health check endpoint (K8s convention)"""
    return {"status": "ok"}

@app.get("/ready")
async def readiness_check():
    """Readiness check - verifies database connectivity"""
    try:
        # Quick ping to verify database is accessible
        await db.command("ping")
        return {"status": "ready", "database": "connected"}
    except Exception as e:
        raise HTTPException(status_code=503, detail=f"Database not ready: {str(e)}")

# Include the router in the main app
app.include_router(api_router)

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def startup_db_init():
    """Initialize database on startup - sync tools from backup"""
    import asyncio
    
    async def background_init():
        """Run database initialization in background to not block startup"""
        try:
            # First, check if database needs initial setup (< 50 tools)
            from init_production_db import init_production_database
            logger.info("🚀 Starting database initialization check...")
            await init_production_database()
            
            # Then, always sync tools from backup to pick up any edits
            from sync_tools_to_production import sync_tools_to_production
            logger.info("🔄 Syncing tool edits from backup...")
            await sync_tools_to_production()
            
            logger.info("✅ Database initialization and sync complete")
        except Exception as e:
            logger.error(f"⚠️  Database initialization failed: {e}")
            # Don't crash the app, just log the error
    
    # Run database initialization in background (non-blocking)
    # This allows health checks to pass while DB initialization completes
    asyncio.create_task(background_init())

@app.on_event("shutdown")
async def shutdown_db_client():
    client.close()
