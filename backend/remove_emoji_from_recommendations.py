import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv
import re

load_dotenv()

# MongoDB connection from environment
mongo_url = os.getenv('MONGO_URL')
db_name = os.getenv('DB_NAME', 'equimind_production')

def remove_emoji(text):
    """Remove emoji from text"""
    # Remove common emojis at start of text
    emoji_pattern = re.compile(r'^[🧘💡🎯💭💪🔥⚡✨🌟🎪🏃‍♀️🧠🎨🛡️🎭🔮📊🎬🌊🎵🎼🎺🎸🎹🥁🎻🎤🎧🎮🕹️🎯🎲🎰🎳🎪🎠🎡🎢🎨🎭🎬🎤🎧🎮🕹️]+\s*')
    cleaned = emoji_pattern.sub('', text)
    return cleaned.strip()

async def clean_recommendations():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🧹 Removing emojis from recommendations in {db_name}...\n")
    
    # Get all recommendations
    recommendations = await db.recommendations.find({}).to_list(length=1000)
    
    updated_count = 0
    
    for rec in recommendations:
        original_text = rec.get('text', '')
        cleaned_text = remove_emoji(original_text)
        
        if cleaned_text != original_text:
            await db.recommendations.update_one(
                {"_id": rec["_id"]},
                {"$set": {"text": cleaned_text}}
            )
            print(f"✅ Updated: {original_text[:60]}... → {cleaned_text[:60]}...")
            updated_count += 1
    
    print(f"\n📊 Complete!")
    print(f"   Updated: {updated_count} recommendations")
    print(f"   Total: {len(recommendations)} recommendations")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(clean_recommendations())
