import asyncio
import json
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv
from pathlib import Path

ROOT_DIR = Path(__file__).parent
load_dotenv(ROOT_DIR / '.env')

async def migrate_strategies():
    # Connect to MongoDB
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    # Load strategies from deployed API
    import requests
    import os
    
    # Use environment variable or fallback to production URL
    source_api_url = os.environ.get('STRATEGIES_SOURCE_URL', 'https://equimind-app.emergent.host/api/mental-strategies')
    response = requests.get(source_api_url)
    strategies = response.json()
    
    print(f"Loaded {len(strategies)} strategies")
    
    # Clear existing strategies
    await db.mental_strategies.delete_many({})
    print("Cleared existing strategies")
    
    # Insert strategies
    if strategies:
        await db.mental_strategies.insert_many(strategies)
        print(f"Inserted {len(strategies)} strategies")
    
    client.close()
    print("Migration complete!")

if __name__ == '__main__':
    asyncio.run(migrate_strategies())
