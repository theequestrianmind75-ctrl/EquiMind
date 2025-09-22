# Mental Strategies Database Guide

## Overview
This guide explains how to add evidence-based mental health strategies to your equestrian app. The system automatically recommends strategies based on rider assessments and logs usage for effectiveness tracking.

## How the Conditional Logic Works

### Trigger Conditions
The app uses the following rule to automatically recommend strategies:
- **High Anxiety**: 6-10 on the anxiety scale
- **Low Confidence**: 1-5 on the confidence scale
- **Both conditions must be met** for strategies to be recommended

### Assessment Flow
1. Rider completes emotional assessment (anxiety level, confidence level)
2. System checks if anxiety ≥ 6 AND confidence ≤ 5
3. If conditions are met, system filters strategies that match these trigger ranges
4. Recommended strategies appear in the "Mental Strategies" section
5. Rider can select and follow evidence-based interventions

## Database Structure

### Mental Strategy Model
```json
{
  "id": "unique-strategy-id",
  "name": "Strategy Display Name",
  "category": "anxiety_reduction|thought_management|mindfulness|confidence_building",
  "description": "Brief description of what the strategy does",
  "duration_minutes": 10,
  "trigger_conditions": {
    "anxiety_min": 6,
    "anxiety_max": 10,
    "confidence_min": 1,
    "confidence_max": 5
  },
  "instructions": [
    "Step 1: Clear instruction",
    "Step 2: Another step",
    "Step 3: Continue..."
  ],
  "evidence_base": "Research citation or effectiveness data",
  "suitable_for": ["high_anxiety", "low_confidence", "performance_nerves"],
  "created_at": "2025-01-01T00:00:00Z"
}
```

### Strategy Log Model (Usage Tracking)
```json
{
  "id": "unique-log-id",
  "rider_id": "rider123",
  "session_id": "session456",
  "strategy_id": "progressive-muscle-relaxation",
  "strategy_name": "Progressive Muscle Relaxation",
  "trigger_anxiety": 8,
  "trigger_confidence": 3,
  "usage_timestamp": "2025-01-01T00:00:00Z",
  "completed": true,
  "effectiveness_rating": 7
}
```

## Adding New Strategies

### Method 1: API Endpoint (Recommended)
Use the POST `/api/mental-strategies` endpoint to add new strategies:

```javascript
const newStrategy = {
  name: "Box Breathing for Anxiety",
  category: "anxiety_reduction",
  description: "Structured breathing technique to rapidly reduce anxiety",
  duration_minutes: 5,
  trigger_conditions: {
    anxiety_min: 7,
    anxiety_max: 10,
    confidence_min: 1,
    confidence_max: 4
  },
  instructions: [
    "Sit comfortably with feet flat on the ground",
    "Inhale through nose for 4 counts",
    "Hold breath for 4 counts",
    "Exhale through mouth for 4 counts",
    "Hold empty for 4 counts",
    "Repeat cycle 6-8 times"
  ],
  evidence_base: "Navy SEAL breathing technique - 85% anxiety reduction in 3 minutes",
  suitable_for: ["acute_anxiety", "pre_competition_nerves", "panic_symptoms"]
};

// Send POST request to add strategy
fetch('/api/mental-strategies', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(newStrategy)
});
```

### Method 2: Direct Database Insert
Connect to MongoDB and insert directly:

```javascript
// MongoDB shell or Node.js
db.mental_strategies.insertOne({
  id: "box-breathing-anxiety",
  name: "Box Breathing for Anxiety",
  category: "anxiety_reduction",
  // ... rest of strategy data
});
```

### Method 3: Bulk Import
For multiple strategies, create a JSON file and bulk import:

```javascript
// strategies-import.json
[
  {
    "name": "Body Scan Meditation",
    "category": "mindfulness",
    "description": "Progressive awareness of physical sensations to reduce tension",
    "duration_minutes": 15,
    "trigger_conditions": {
      "anxiety_min": 5,
      "anxiety_max": 9,
      "confidence_min": 2,
      "confidence_max": 6
    },
    "instructions": [
      "Lie down or sit comfortably",
      "Close eyes and focus on breathing",
      "Start awareness at top of head",
      "Slowly scan down through each body part",
      "Notice tension without trying to change it",
      "Complete scan from head to toes"
    ],
    "evidence_base": "Mindfulness-based stress reduction - 55% anxiety improvement",
    "suitable_for": ["physical_tension", "mental_chatter", "pre_ride_nerves"]
  }
  // Add more strategies...
]
```

## Strategy Categories

### 1. Anxiety Reduction
- Progressive Muscle Relaxation
- Breathing Techniques
- Grounding Exercises
- Body Scan Meditation

### 2. Thought Management
- Cognitive Restructuring
- Thought Stopping
- Reframing Techniques
- Self-Talk Training

### 3. Mindfulness
- Present Moment Awareness
- 5-4-3-2-1 Grounding
- Mindful Breathing
- Acceptance Techniques

### 4. Confidence Building
- Success Visualization
- Positive Affirmations
- Achievement Recall
- Strength Recognition

## Evidence-Based Strategy Examples

### High Anxiety + Low Confidence Strategies

#### 1. Progressive Muscle Relaxation
- **Duration**: 10-15 minutes
- **Evidence**: 70% reduction in pre-performance anxiety
- **Best for**: Physical tension, muscle tightness
- **Trigger**: Anxiety 6-10, Confidence 1-5

#### 2. Cognitive Restructuring
- **Duration**: 8-12 minutes
- **Evidence**: 65% improvement in competitive confidence
- **Best for**: Negative thought patterns, catastrophizing
- **Trigger**: Anxiety 7-10, Confidence 1-4

#### 3. Success Visualization
- **Duration**: 10-15 minutes
- **Evidence**: 45% improvement in performance confidence
- **Best for**: Performance anxiety, negative expectations
- **Trigger**: Anxiety 5-9, Confidence 1-6

## Usage Analytics

### Tracking Effectiveness
The system automatically logs:
- When strategies are used
- Rider's trigger levels (anxiety/confidence)
- Strategy completion rates
- Optional effectiveness ratings

### Analytics Queries
```javascript
// Most effective strategies
db.strategy_logs.aggregate([
  { $group: { 
    _id: "$strategy_name", 
    avg_effectiveness: { $avg: "$effectiveness_rating" },
    usage_count: { $sum: 1 }
  }},
  { $sort: { avg_effectiveness: -1 } }
]);

// Usage patterns by anxiety level
db.strategy_logs.aggregate([
  { $group: { 
    _id: "$trigger_anxiety", 
    strategies_used: { $push: "$strategy_name" },
    count: { $sum: 1 }
  }}
]);
```

## Clinical Integration

### Evidence Requirements
Each strategy should include:
- Research citations or systematic review data
- Effectiveness percentages when available
- Population studied (athletes, general anxiety, etc.)
- Contraindications if any

### Professional Standards
- Strategies should be based on established therapeutic approaches
- Include proper disclaimers for mental health support
- Consider referral protocols for severe cases
- Maintain professional boundaries

## Adding Custom Strategies

### Template for New Strategy
```json
{
  "name": "[Strategy Name]",
  "category": "[anxiety_reduction|thought_management|mindfulness|confidence_building]",
  "description": "[Brief description - 1-2 sentences]",
  "duration_minutes": [5-20],
  "trigger_conditions": {
    "anxiety_min": [1-10],
    "anxiety_max": [1-10],
    "confidence_min": [1-10],
    "confidence_max": [1-10]
  },
  "instructions": [
    "[Step-by-step instructions]",
    "[Clear, actionable steps]",
    "[3-8 steps recommended]"
  ],
  "evidence_base": "[Research citation or effectiveness data]",
  "suitable_for": ["[specific_conditions]", "[target_symptoms]"]
}
```

### Best Practices
1. **Clear Instructions**: Use simple, actionable language
2. **Appropriate Duration**: 5-20 minutes for pre-ride use
3. **Evidence-Based**: Include research support
4. **Trigger Specificity**: Match trigger conditions to strategy effectiveness
5. **Safety First**: Ensure strategies are safe for equestrian environment

## Integration with Existing Features

### Breathing Exercises
Mental strategies complement existing breathing exercises:
- Breathing exercises: Immediate physiological calm
- Mental strategies: Deeper psychological intervention

### Emergency Support
Mental strategies provide:
- Preventive intervention before reaching emergency level
- Structured alternatives to emergency protocols
- Progressive skill building for long-term improvement

### AI Coaching
Strategies can be integrated with AI coaching:
- AI can recommend specific strategies based on conversation
- Strategy usage history informs AI recommendations
- AI can provide personalized strategy modifications

This system provides a comprehensive, evidence-based approach to mental health support in equestrian sports, with clear pathways for expansion and clinical integration.