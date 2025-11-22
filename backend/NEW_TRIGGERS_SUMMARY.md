# New Triggers - Mapped to Existing Database Categories

## ✅ Using Exact Category Names from Database:
1. **"BODY RESET"** - 59 tools
2. **"Breathing / HRV"** - 19 tools  
3. **"Mindfulness & Flow"** - 10 tools
4. **"Tapping / EFT"** - 48 tools

---

## 🆕 New Trigger 1: High Confidence + High Anxiety

**Trigger ID:** `high_confidence_high_anxiety`

**When It Fires:**
- Post-ride confidence ≥ 7 (rider feels capable)
- Post-ride anxiety ≥ 6 (rider feels nervous/keyed up)
- Classic "competition nerves" pattern

**Tool Categories Used:**
1. **"Breathing / HRV"** (primary) - For arousal regulation
2. **"Tapping / EFT"** (secondary) - For nervous system balance
3. **"Mindfulness & Flow"** (tertiary) - For competition focus

**Specific Tools Recommended:**
- 4-2-6 Performance Breath (Breathing / HRV)
- Pre-Ride Anxiety Release (Tapping / EFT)
- Heart-Focused Breathing (Breathing / HRV)

**UI Message:**
> "You feel capable, but your nerves are high. Let's channel that energy into focus instead of overwhelm."

---

## 🆕 New Trigger 2: Low Energy / Low Motivation

**Trigger ID:** `low_energy_low_motivation`

**When It Fires:**
- Post-ride energy level ≤ 4
- Post-ride confidence ≤ 5 (not scared, just flat)
- No high anxiety (rider is depleted, not nervous)

**Tool Categories Used:**
1. **"BODY RESET"** (primary) - Gentle activation
2. **"Breathing / HRV"** (secondary) - Energy shift
3. **"Mindfulness & Flow"** (tertiary) - Reconnection

**Specific Tools Recommended:**
- Shoulder Rolls (Micro-Movement) (BODY RESET)
- Heart-Focused Breathing (Breathing / HRV)
- Five-Sense Horseback Scan (Mindfulness & Flow)

**UI Message:**
> "You're not broken—you're tired. Let's gently build a bit of momentum and reconnect with why you ride."

---

## 🆕 Context Modifier: Competition vs Training

### Context: Competition

**Trigger ID:** `context_competition`

**When It Fires:**
- Rider marks pre-ride as "Competition" context
- Applied as a secondary filter on top of emotional triggers

**Tool Categories Used:**
1. **"Breathing / HRV"** (primary) - Performance breathing
2. **"Tapping / EFT"** (secondary) - Pre-ride anxiety release
3. **"BODY RESET"** (tertiary) - Quick physical resets

**Specific Tools Recommended:**
- 4-2-6 Performance Breath (Breathing / HRV)
- Pre-Ride Anxiety Release (Tapping / EFT)
- Conscious Swallow Reset (BODY RESET)

**UI Message:**
> "You're in show mode. Let's get you competition-ready."

---

### Context: Training

**Trigger ID:** `context_training`

**When It Fires:**
- Rider marks pre-ride as "Training" context (default)
- Applied as a secondary filter on top of emotional triggers

**Tool Categories Used:**
1. **"Mindfulness & Flow"** (primary) - Awareness & skill building
2. **"BODY RESET"** (secondary) - Body scanning & interoception
3. **"Breathing / HRV"** (tertiary) - Connection-focused breathing

**Specific Tools Recommended:**
- Five-Sense Horseback Scan (Mindfulness & Flow)
- Horseback Body Scan (BODY RESET)
- Breath-Per-Stride Synchronization (Breathing / HRV)

**UI Message:**
> "You're in training mode. Let's work on skill development and connection."

---

## Implementation Plan

### Step 1: Update Pre-Ride Screen
Add context selection:
- Radio buttons or toggle: "Competition" or "Training" (default: Training)
- Store in session as `context` field

### Step 2: Add New Trigger Logic
Update `post-ride.tsx` trigger determination:
```javascript
// New trigger: High confidence + high anxiety
if (postConfidence >= 7 && postAnxiety >= 6) {
  triggers.push('high_confidence_high_anxiety');
}

// New trigger: Low energy / motivation
if (energyLevel <= 4 && postConfidence <= 5 && postAnxiety < 6) {
  triggers.push('low_energy_low_motivation');
}

// Context modifier
if (selectedSession?.context === 'competition') {
  triggers.push('context_competition');
} else {
  triggers.push('context_training');
}
```

### Step 3: Create New Recommendations in Database
Seed 4 new recommendation documents with:
- `trigger_condition`: matches trigger ID
- `text`: UI message
- `suggested_tool_names`: array of 3 specific tool names
- `priority`: set appropriately

### Step 4: Test
- Complete pre-ride with Competition context
- Complete post-ride with high confidence + high anxiety
- Verify recommendations and suggested tools appear

---

## Questions for Review

1. **Trigger Thresholds**: Do the numerical thresholds make sense?
   - High confidence: ≥ 7
   - High anxiety: ≥ 6
   - Low energy: ≤ 4

2. **Tool Selections**: Do the specific tool recommendations feel right for each state?

3. **Context Implementation**: Should context be:
   - Selected in pre-ride? ✅ (Recommended)
   - Inferred from other metrics?
   - Optional or required?

4. **Priority**: How should these new triggers rank vs existing ones?
   - Should "high_confidence_high_anxiety" override "high_anxiety"?
   - Should context always apply, or only when other triggers are ambiguous?

Please review and let me know if this mapping looks correct!
