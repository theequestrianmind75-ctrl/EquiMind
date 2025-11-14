"""
Script to simplify categories - keep only the primary (first) category for each tool
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os

load_dotenv()

async def simplify_categories():
    # Connect to MongoDB
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("🔄 Starting category simplification process...")
    
    # Get all tools
    tools = await db.mental_strategies.find().to_list(None)
    
    updated_count = 0
    category_stats = {}
    
    for tool in tools:
        current_category = tool.get('category', '')
        
        # Split by comma and take the first category
        if ',' in current_category:
            primary_category = current_category.split(',')[0].strip()
            
            # Update the tool with simplified category
            await db.mental_strategies.update_one(
                {'id': tool['id']},
                {'$set': {'category': primary_category}}
            )
            
            updated_count += 1
            
            # Track statistics
            if primary_category not in category_stats:
                category_stats[primary_category] = 0
            category_stats[primary_category] += 1
            
            print(f"✏️  Updated: {tool.get('name', 'Unnamed')} -> {primary_category}")
    
    print(f"\n✅ Updated {updated_count} tools")
    
    # Show final category distribution
    print("\n📊 Final category distribution:")
    for category, count in sorted(category_stats.items()):
        print(f"   {category}: {count} tools")
    
    # Verify final state
    final_categories = await db.mental_strategies.distinct('category')
    print(f"\n📂 Total unique categories after simplification: {len(final_categories)}")
    print("\nFinal categories:")
    for cat in sorted(final_categories):
        count = await db.mental_strategies.count_documents({'category': cat})
        print(f"   - {cat} ({count} tools)")
    
    client.close()
    print("\n✨ Category simplification complete!")

if __name__ == "__main__":
    asyncio.run(simplify_categories())
