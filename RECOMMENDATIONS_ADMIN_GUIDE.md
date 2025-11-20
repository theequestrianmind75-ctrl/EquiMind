# 📝 Recommendations Management Guide

## Overview

You now have full control over all post-ride recommendations. They're stored in your MongoDB database and can be edited through API calls or a custom admin interface.

---

## What Was Built

### Backend API Endpoints

**Get Active Recommendations (Public)**
```
GET /api/recommendations
```
Returns all active recommendations used by the app.

**Get All Recommendations (Admin)**
```
GET /api/admin/recommendations
```
Returns all recommendations including inactive ones.

**Create New Recommendation (Admin)**
```
POST /api/admin/recommendations
Body: {
  "text": "Your recommendation text here",
  "trigger_condition": "high_anxiety",
  "priority": 10,
  "active": true
}
```

**Update Recommendation (Admin)**
```
PATCH /api/admin/recommendations/{rec_id}
Body: {
  "text": "Updated text",
  "priority": 8,
  "active": false
}
```

**Delete Recommendation (Admin)**
```
DELETE /api/admin/recommendations/{rec_id}
```

---

## Trigger Conditions Explained

These determine **when** a recommendation shows up:

| Trigger Condition | When It Appears |
|-------------------|-----------------|
| `high_anxiety` | Post-ride anxiety ≥ 7 |
| `anxiety_increased` | Anxiety increased by 2+ points |
| `low_confidence` | Post-ride confidence ≤ 4 |
| `confidence_decreased` | Confidence dropped by 2+ points |
| `high_anxiety_low_confidence` | Anxiety ≥ 6 AND confidence ≤ 4 |
| `high_horse_energy_low_confidence` | Horse energy ≥ 7 AND rider confidence ≤ 4 |
| `low_horse_focus` | Horse focus ≤ 4 |
| `optimal_performance` | Anxiety ≤ 3 AND confidence ≥ 7 |
| `good_improvement` | Anxiety dropped 2+ AND confidence increased 2+ |
| `optimal_horse_metrics` | Horse energy 5-7, focus ≥ 6, responsiveness ≥ 6 |
| `default` | Shows when no other conditions match |

---

## Current Recommendations in Database

You have **20 initial recommendations** seeded across 11 trigger conditions:

- **high_anxiety**: 2 recommendations
- **anxiety_increased**: 2 recommendations
- **low_confidence**: 2 recommendations
- **confidence_decreased**: 2 recommendations
- **high_anxiety_low_confidence**: 2 recommendations
- **high_horse_energy_low_confidence**: 2 recommendations
- **low_horse_focus**: 2 recommendations
- **optimal_performance**: 2 recommendations
- **good_improvement**: 1 recommendation
- **optimal_horse_metrics**: 1 recommendation
- **default**: 2 recommendations

---

## How to Edit Recommendations

### Option 1: Direct Database Access (MongoDB Atlas)

1. Log into **MongoDB Atlas**
2. Go to **Collections** → `equimind_production` → `recommendations`
3. Click any recommendation to edit:
   - **text**: The recommendation message
   - **trigger_condition**: When it shows (see table above)
   - **priority**: Higher = shows first (1-10 scale)
   - **active**: true/false (inactive won't show)

### Option 2: API Calls (Using Postman or curl)

**Example: Update a recommendation**
```bash
curl -X PATCH https://your-backend-url.com/api/admin/recommendations/REC_ID_HERE \
  -H "Content-Type: application/json" \
  -d '{
    "text": "New improved recommendation text",
    "priority": 9
  }'
```

**Example: Create new recommendation**
```bash
curl -X POST https://your-backend-url.com/api/admin/recommendations \
  -H "Content-Type: application/json" \
  -d '{
    "text": "🐴 Check your horse saddle fit before blaming training issues.",
    "trigger_condition": "low_horse_focus",
    "priority": 6,
    "active": true
  }'
```

### Option 3: Build Custom Admin UI (Future Enhancement)

We can build a dedicated admin page where you can:
- See all recommendations in a table
- Edit text inline
- Change priorities with drag-and-drop
- Toggle active/inactive
- Preview which triggers apply

**Would you like me to build this UI for you?**

---

## Best Practices

### Writing Effective Recommendations

✅ **DO:**
- Start with an emoji for visual interest
- Keep it concise (1-2 sentences)
- Reference specific tools from your library
- Cite research when relevant ("research shows...")
- Use encouraging, non-judgmental language

❌ **DON'T:**
- Make assumptions about horse behavior
- Use technical jargon without explanation
- Be prescriptive ("you must...")
- Blame the rider for issues

### Managing Priority

- **Priority 10**: Most important, shows first
- **Priority 7-9**: Important secondary recommendations
- **Priority 4-6**: Helpful supplementary advice
- **Priority 1-3**: General/default suggestions

Multiple recommendations can have same priority. System shows top 4 by priority.

### Using Trigger Conditions

**Combine conditions for specificity:**
- Instead of one generic "low_confidence" recommendation
- Create 2-3 with different advice angles
- Let priority determine which shows first

**Create condition variations:**
- `high_anxiety` - acute anxiety management
- `anxiety_increased` - pattern recognition and intervention

---

## Testing Your Changes

### How to Test

1. **Make your edit** (MongoDB or API)
2. **Complete a post-ride session** with data matching your trigger:
   - E.g., set post-ride anxiety to 8 to test `high_anxiety`
3. **Check recommendations section** - your new/edited rec should appear

### Common Test Scenarios

**Test high anxiety:**
- Set post-ride anxiety to 8+

**Test confidence decrease:**
- Set pre-ride confidence to 7, post-ride to 4

**Test optimal performance:**
- Set anxiety to 2, confidence to 8

---

## Troubleshooting

**Recommendation not showing:**
- Check `active: true`
- Verify trigger condition matches current data
- Check priority (higher priority shows first, top 4 only)

**Wrong recommendation showing:**
- Check priorities - higher priority = shows first
- Verify trigger_condition spelling

**App crashes:**
- Check recommendation text doesn't have special characters breaking JSON
- Verify all fields are present (text, trigger_condition, priority, active)

---

## Database Backup

Before making major changes, create a backup:

```bash
cd /app/backend
python3 -c "
from pymongo import MongoClient
import json
import os
from dotenv import load_dotenv

load_dotenv()
client = MongoClient(os.getenv('MONGO_URL'))
db = client[os.getenv('DB_NAME')]

recs = list(db.recommendations.find({}))
with open('recommendations_backup.json', 'w') as f:
    json.dump(recs, f, default=str, indent=2)

print('✅ Backup saved to recommendations_backup.json')
"
```

---

## Next Steps

**Immediate:**
1. Review the 20 seeded recommendations
2. Edit any that don't fit your expertise
3. Test in the app

**Future Enhancements:**
1. **Admin UI** - Visual interface for managing recommendations
2. **Analytics** - Track which recommendations are most shown
3. **A/B Testing** - Test different recommendation versions
4. **Custom Triggers** - Add more specific trigger conditions
5. **Seasonal Recommendations** - Different advice for different times of year

**Let me know if you want me to build the Admin UI next!**

---

## Contact for Help

If you need assistance:
1. Check MongoDB Atlas for data
2. Test API endpoints with Postman
3. Review backend logs: `/var/log/supervisor/backend.err.log`

Remember: **You have complete control.** AI is no longer making recommendations - you are!
