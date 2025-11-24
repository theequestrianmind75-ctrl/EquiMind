# EquiMind Deployment Guide

## 🚀 Deployment Overview

This deployment includes:
- **190 mental strategy tools** (up from 107 in production)
- **24 recommendations** with full mindfulness tool mappings
- **18 Distress Tolerance tools** with crisis filtering
- **20 Mindfulness & Flow tools** fully integrated

## 🛡️ Safety Features

### Automatic Backup Before Restoration
When the app detects that production has fewer tools than expected, it will:

1. **Create safety backup** of current production data
   - Location: `/app/backend/safety_backups/`
   - Format: `production_tools_YYYYMMDD_HHMMSS.json`
   - Format: `production_recs_YYYYMMDD_HHMMSS.json`

2. **Validate backup files** before proceeding
   - Checks for valid JSON
   - Verifies tool count (must have 50+ valid tools)
   - Aborts if backup is corrupted

3. **Perform restoration**
   - Delete old data
   - Insert new data
   - Restore recommendations

4. **Verify success**
   - Compare final counts with expected
   - Log detailed results
   - Report any discrepancies

### What Gets Updated
- ✅ `mental_strategies` collection (107 → 190 tools)
- ✅ `recommendations` collection (old → new mappings)

### What Stays Untouched
- ✅ `users` collection (all production users preserved)
- ✅ `sessions` collection (all ride data preserved)

## 📊 Expected Deployment Flow

```
Backend Starts
    ↓
Check Production DB
    ↓
Found: 107 tools, Expected: 190 tools
    ↓
🛡️ Create Safety Backup
    ↓
📦 Load backup_mental_strategies_LATEST.json (190 tools)
📦 Load backup_recommendations_LATEST.json (24 recs)
    ↓
🗑️ Delete 107 old tools
    ↓
✅ Insert 190 new tools
✅ Insert 24 recommendations
    ↓
🔍 Verify: 190 tools, 24 recommendations
    ↓
✅ Restoration Complete!
```

## 🚨 Emergency Rollback

If something goes wrong, use the rollback script:

```bash
cd /app/backend
python3 rollback_to_production_backup.py
```

This will:
1. List all available safety backups
2. Restore the most recent production backup
3. Verify restoration success

To restore a specific backup:
```bash
python3 rollback_to_production_backup.py 20251124_013000
```

## 📋 Deployment Checklist

### Before Deployment
- ✅ Backup files created (190 tools, 24 recommendations)
- ✅ Safety mechanism implemented
- ✅ Rollback script ready
- ✅ User data preservation verified
- ✅ No breaking API changes

### During Deployment
- Users may experience 30-60 second downtime
- Active sessions will be preserved
- JWT tokens will remain valid

### After Deployment
- Check logs for restoration messages
- Verify tool count: 190 tools
- Verify recommendation count: 24 recommendations
- Test new features:
  - Distress Tolerance category with Crisis filter
  - Mindfulness tools in recommendations
  - No emojis in recommendations

## 🔍 Monitoring Deployment

Watch for these log messages:

**Success Messages:**
```
🛡️ SAFETY MODE: Creating production backup before restoration...
✅ Production backup saved: 107 tools, X recommendations
✅ VERIFICATION PASSED:
   - Tools: 190 (all with valid instructions)
   - Recommendations: 24
```

**Warning Messages (Need Attention):**
```
⚠️ WARNING: Expected 190 tools, got X
🔄 ROLLBACK AVAILABLE: /app/backend/safety_backups/production_tools_TIMESTAMP.json
```

**Error Messages (Use Rollback):**
```
❌ RESTORATION FAILED: [error message]
🔄 ROLLBACK AVAILABLE: Check /app/backend/safety_backups/
```

## 📞 If Things Go Wrong

1. **Check logs** for specific error messages
2. **Verify backup exists** in `/app/backend/safety_backups/`
3. **Run rollback script** if needed
4. **Contact support** with:
   - Error messages from logs
   - Safety backup timestamp
   - Tool count before/after

## ✅ Post-Deployment Verification

1. **Test Login**
   - Production users should be able to log in
   - Sessions should be preserved

2. **Test New Features**
   - Navigate to Rider Tools
   - Check for "Distress Tolerance" category
   - Click "Crisis Tools" button (should filter to 5 tools)
   - Check for "Mindfulness & Flow" category (should have 20 tools)

3. **Test Recommendations**
   - Complete a post-ride analysis
   - Verify mindfulness tools appear in suggestions
   - Verify no emojis in recommendation text

4. **Verify Tool Count**
   - Should show 190 total tools across all categories

## 🎯 Success Criteria

- ✅ Backend starts without errors
- ✅ Database has 190 tools
- ✅ Database has 24 recommendations
- ✅ Users can log in with existing accounts
- ✅ New tools visible in app
- ✅ Recommendations include mindfulness tools
- ✅ No data loss (users/sessions preserved)

---

**Last Updated:** 2024-11-24  
**Version:** 1.0 - Production Ready with Safety Layer
