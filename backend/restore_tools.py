"""
Script to restore Rider Tools from CSV backup to MongoDB
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import csv
import uuid

load_dotenv()

async def restore_tools():
    # Connect to MongoDB
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("🔄 Starting tool restoration process...")
    
    # First, backup current data (just in case)
    current_count = await db.mental_strategies.count_documents({})
    print(f"📊 Current database has {current_count} documents")
    
    # Clear existing tools
    delete_result = await db.mental_strategies.delete_many({})
    print(f"🗑️  Deleted {delete_result.deleted_count} documents")
    
    # Read CSV file
    csv_file = "/app/frontend/public/rider_tools.csv"
    tools_to_insert = []
    
    with open(csv_file, 'r', encoding='utf-8') as file:
        csv_reader = csv.DictReader(file)
        
        for row in csv_reader:
            # Parse anxiety and confidence level ranges
            def parse_range(range_str):
                if not range_str or range_str == '':
                    return []
                try:
                    if '-' in range_str:
                        start, end = range_str.split('-')
                        return list(range(int(start), int(end) + 1))
                    else:
                        return [int(range_str)]
                except:
                    return []
            
            anxiety_range = parse_range(row.get('Anxiety Level Range', ''))
            confidence_range = parse_range(row.get('Confidence Level Range', ''))
            
            # Parse duration
            try:
                duration = int(row.get('Duration (minutes)', 5))
            except:
                duration = 5
            
            # Parse effectiveness rating
            try:
                effectiveness = float(row.get('Effectiveness Rating', 3.5))
            except:
                effectiveness = 3.5
            
            tool = {
                'id': str(uuid.uuid4()),
                'name': row.get('Tool Name', '').strip(),
                'category': row.get('Category', '').strip(),
                'description': row.get('Description', '').strip() or None,
                'instructions': row.get('Instructions', '').strip(),
                'duration_minutes': duration,
                'anxiety_level': anxiety_range,
                'confidence_level': confidence_range,
                'effectiveness_rating': effectiveness
            }
            
            tools_to_insert.append(tool)
    
    # Insert all tools
    if tools_to_insert:
        result = await db.mental_strategies.insert_many(tools_to_insert)
        print(f"✅ Successfully restored {len(result.inserted_ids)} tools to database")
    else:
        print("⚠️  No tools found in CSV file")
    
    # Verify restoration
    final_count = await db.mental_strategies.count_documents({})
    print(f"📊 Final database count: {final_count} documents")
    
    # Show a sample
    sample = await db.mental_strategies.find_one()
    if sample:
        print(f"\n📄 Sample document:")
        print(f"   Name: {sample.get('name', 'N/A')}")
        print(f"   Category: {sample.get('category', 'N/A')}")
        print(f"   Instructions (first 100 chars): {sample.get('instructions', 'N/A')[:100]}...")
    
    client.close()
    print("\n✨ Tool restoration complete!")

if __name__ == "__main__":
    asyncio.run(restore_tools())
