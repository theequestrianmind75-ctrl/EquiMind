"""
Remove numbered steps from all tool instructions - DIRECT VERSION
"""
import asyncio
import re
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv
import os

load_dotenv()

async def remove_numbered_steps():
    client = AsyncIOMotorClient(os.getenv('MONGO_URL'))
    db = client[os.getenv('DB_NAME', 'equimind_production')]
    
    print('🔄 Removing numbered steps from all tools...\n')
    
    # Get all tools
    tools = await db.mental_strategies.find({}).to_list(1000)
    
    updated_count = 0
    
    for tool in tools:
        instructions = tool.get('instructions', '')
        if not instructions:
            continue
        
        original = instructions
        
        # Split into lines and clean each line
        lines = instructions.split('\n')
        cleaned_lines = []
        
        for line in lines:
            # Remove "1. " or "2. " or "3. " etc. at start of line
            cleaned = re.sub(r'^\s*\d+\.\s+', '', line)
            cleaned_lines.append(cleaned)
        
        # Join back
        cleaned_instructions = '\n'.join(cleaned_lines)
        
        # Only update if something changed
        if cleaned_instructions != original:
            # Use MongoDB's _id to update
            await db.mental_strategies.update_one(
                {'_id': tool['_id']},
                {'$set': {'instructions': cleaned_instructions}}
            )
            updated_count += 1
            print(f'  ✓ Updated: {tool.get("name", "Unknown")}')
    
    print(f'\n✅ Finished!')
    print(f'   • Updated: {updated_count} tools')
    print(f'   • Unchanged: {len(tools) - updated_count} tools')
    
    client.close()

if __name__ == "__main__":
    asyncio.run(remove_numbered_steps())
