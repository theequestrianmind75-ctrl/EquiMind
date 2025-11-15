# EquiMind Tool Backup & Recovery System

## Problem
When the Emergent environment times out or restarts, your editing work may be lost. This backup system helps prevent data loss.

## Solution: 3-Step Protection

### 1. BEFORE YOU START EDITING (Create Backup)
```bash
cd /app/backend && python3 backup_tools.py
```
This creates:
- `backup_mental_strategies_LATEST.json` (always current)
- `backup_mental_strategies_YYYYMMDD_HHMMSS.json` (timestamped)

### 2. WHILE EDITING (Auto-Save in Text Editor)
The text editor's "Save All Changes" button saves to the database immediately. 
**Click Save frequently!**

### 3. AFTER TIMEOUT/RESTART (Restore from Backup)
If tools disappear after refresh:
```bash
cd /app/backend && python3 restore_from_backup.py
```

Then restart services:
```bash
sudo supervisorctl restart backend && sudo supervisorctl restart expo
```

Wait 10 seconds, then hard refresh your browser (Ctrl+Shift+R).

## Quick Recovery Command (All-in-One)
```bash
cd /app/backend && python3 restore_from_backup.py && sudo supervisorctl restart backend && sudo supervisorctl restart expo && sleep 10 && echo "✅ Ready - refresh your browser now"
```

## Backup Files Location
- `/app/backend/backup_mental_strategies_LATEST.json`
- `/app/backend/backup_mental_strategies_*.json` (timestamped backups)

## Best Practices
1. **Backup before starting**: Run backup_tools.py before each editing session
2. **Save frequently**: Use the "Save All Changes" button often (every few edits)
3. **Keep browser tab active**: Don't let it go idle for too long
4. **Copy-paste large edits**: For safety, copy your text before saving

## Emergency: Tools Disappeared
```bash
# Step 1: Restore from latest backup
cd /app/backend && python3 restore_from_backup.py

# Step 2: Restart services
sudo supervisorctl restart backend expo

# Step 3: Wait and refresh
sleep 10
# Now hard refresh browser (Ctrl+Shift+R)
```

## Check Current Database Status
```bash
cd /app/backend && python3 -c "
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os

load_dotenv()

async def check():
    client = AsyncIOMotorClient(os.environ['MONGO_URL'])
    db = client[os.environ['DB_NAME']]
    count = await db.mental_strategies.count_documents({})
    print(f'Tools in database: {count}')
    client.close()

asyncio.run(check())
"
```

Expected result: `Tools in database: 243`
