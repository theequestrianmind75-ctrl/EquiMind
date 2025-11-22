# Context-Based Decision Tree Implementation

## Flow Overview

```
Pre-Ride: Select Context
    ↓
Post-Ride: Evaluate Metrics
    ↓
Decision Tree: Context + Emotional State
    ↓
Tool Selection: Context-Modified Recommendations
```

---

## Step 1: Pre-Ride Context Selection

**UI Addition:**
Add to pre-ride screen after name inputs:

```
┌─────────────────────────────────────┐
│ Ride Context                        │
├─────────────────────────────────────┤
│ ○ Training Ride (default)           │
│ ○ Competition / Show                │
└─────────────────────────────────────┘
```

**Stored in Session:**
```javascript
{
  context: "training" | "competition",
  // ... other session fields
}
```

---

## Step 2: Post-Ride Trigger Evaluation

### Priority Order:

#### If Context = "competition":
1. **Priority 1:** High Confidence + High Anxiety
   - `anxiety >= 7 && confidence >= 7`
   - Trigger: `high_confidence_high_anxiety_competition`
   
2. **Priority 2:** Low Energy + Low Anxiety
   - `energy <= 3 && anxiety <= 5`
   - Trigger: `low_energy_low_motivation_competition`
   
3. **Priority 3:** Existing Triggers (with competition context)
   - All existing triggers BUT tool selection favors competition-ready tools

#### If Context = "training":
1. **Priority 1:** Low Energy + Low Anxiety
   - `energy <= 3 && anxiety <= 5`
   - Trigger: `low_energy_low_motivation_training`
   
2. **Priority 2:** High Confidence + High Anxiety
   - `anxiety >= 7 && confidence >= 7`
   - Trigger: `high_confidence_high_anxiety_training`
   - Note: "You can use competition-nerves tools in training for simulation/rehearsal"
   
3. **Priority 3:** Existing Triggers (with training context)
   - All existing triggers BUT tool selection favors exploration/learning tools

---

## Step 3: Tool Selection Logic

### Context-Modified Tool Selection

**Example: High Anxiety Trigger**

```javascript
// Existing trigger: high_anxiety
// But now modified by context

if (context === "competition") {
  // Competition: Quick, performance-focused tools
  recommended_tools = [
    "4-2-6 Performance Breath",        // Fast arousal regulation
    "Conscious Swallow Reset",          // Quick physical reset
    "Pre-Ride Anxiety Release"          // Competition-specific tapping
  ]
} else { // training
  // Training: Exploratory, learning-focused tools
  recommended_tools = [
    "Five-Sense Horseback Scan",        // Awareness building
    "Horseback Body Scan",              // Interoception
    "Mindful Rein Contact Check"        // Skill development
  ]
}
```

---

## Database Structure for Recommendations

### New Fields in Recommendations Collection:

```javascript
{
  trigger_condition: "high_confidence_high_anxiety",
  context: "competition",  // NEW FIELD: "competition", "training", or "any"
  text: "You feel capable, but competition nerves are high...",
  suggested_tool_names: [
    "4-2-6 Performance Breath",
    "Pre-Ride Anxiety Release",
    "Heart-Focused Breathing"
  ],
  priority: 1
}
```

---

## Implementation Checklist

### Backend Changes:

1. **Update Session Model** (`server.py`)
   - Add `context` field: `Optional[str] = "training"`

2. **Create New Recommendations**
   - `high_confidence_high_anxiety` + `competition` context
   - `high_confidence_high_anxiety` + `training` context
   - `low_energy_low_motivation` + `competition` context
   - `low_energy_low_motivation` + `training` context
   - Update existing recommendations with `context: "any"`

3. **Update Recommendations Endpoint**
   - Filter by both `trigger_condition` AND `context`
   - Fall back to `context: "any"` if no exact match

### Frontend Changes:

1. **Pre-Ride Screen** (`pre-ride.tsx`)
   - Add context selection radio buttons
   - Store context in session creation/update

2. **Post-Ride Screen** (`post-ride.tsx`)
   - Update trigger determination logic
   - Check context FIRST, then evaluate emotional triggers
   - Pass context to recommendations API call

3. **Recommendation Fetching**
   - Send context as query parameter
   - Filter recommendations by context match

---

## Example API Call Flow

### Pre-Ride:
```javascript
POST /api/sessions
{
  rider_name: "Sarah",
  horse_name: "Thunder",
  context: "competition",  // NEW FIELD
  anxiety_level: 5,
  confidence_level: 6,
  // ...
}
```

### Post-Ride:
```javascript
// Determine triggers
const context = selectedSession.context; // "competition"
const triggers = [];

// Priority 1 in competition: high confidence + high anxiety
if (postAnxiety >= 7 && postConfidence >= 7) {
  triggers.push('high_confidence_high_anxiety');
}

// Fetch recommendations with context
GET /api/recommendations?context=competition&triggers=high_confidence_high_anxiety
```

### Backend Response:
```javascript
[
  {
    trigger_condition: "high_confidence_high_anxiety",
    context: "competition",
    text: "You feel capable, but competition nerves are high. Let's channel that energy into focus.",
    suggested_tool_names: [
      "4-2-6 Performance Breath",
      "Pre-Ride Anxiety Release",
      "Heart-Focused Breathing"
    ]
  }
]
```

---

## Questions for Approval

1. **Context Default**: Should default be "training" or should we force the rider to choose?

2. **Energy Metric**: Where do we capture "energy level" since it's not currently in the session model?
   - Add to pre-ride? (rider's energy level before ride)
   - Add to post-ride? (rider's energy level after ride)

3. **Threshold Values**: Confirm these are correct:
   - High confidence: ≥ 7
   - High anxiety: ≥ 7
   - Low energy: ≤ 3
   - Low anxiety: ≤ 5

4. **Tool Selection**: Should the same trigger in different contexts get:
   - Completely different tools? OR
   - Same tools but different order/priority?

5. **Fallback Logic**: If no context-specific recommendation exists, should we:
   - Show recommendations with `context: "any"`? ✅ (Recommended)
   - Show no recommendations?
   - Show generic message?

Ready to implement once you confirm these details!
