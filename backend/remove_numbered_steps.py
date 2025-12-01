"""
Remove numbered steps from all tool instructions
Removes patterns like "1.", "2.", "3." or "1)", "2)", "3)" from beginning of lines
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
    
    print('🔄 Removing numbered steps from all tools...')
    
    # Get all tools
    tools = await db.mental_strategies.find({}).to_list(1000)
    
    updated_count = 0
    
    for tool in tools:
        instructions = tool.get('instructions', '')
        if not instructions:
            continue
        
        original = instructions
        
        # Remove numbered steps patterns:
        # - "1. ", "2. ", "3. ", etc. at start of line
        # - "1) ", "2) ", "3) ", etc. at start of line
        # - "Step 1:", "Step 2:", etc.
        
        # Split into lines
        lines = instructions.split('\n')
        cleaned_lines = []
        
        for line in lines:
            # Remove "1. " or "1) " or "Step 1:" patterns at start
            cleaned = re.sub(r'^\s*(\d+[\.\)]\s+|Step\s+\d+:\s*)', '', line)
            cleaned_lines.append(cleaned)
        
        # Join back
        cleaned_instructions = '\n'.join(cleaned_lines)
        
        # Only update if something changed
        if cleaned_instructions != original:
            tool_id = tool.get('id')
            if tool_id:
                result = await db.mental_strategies.update_one(
                    {'id': tool_id},
                    {'$set': {'instructions': cleaned_instructions}}
                )
                if result.modified_count > 0:
                    updated_count += 1
                    print(f'  ✓ Updated: {tool.get("name", "Unknown")}')
                else:
                    print(f'  ⚠ Failed to update: {tool.get("name", "Unknown")}')
    
    print(f'\n✅ Finished!')
    print(f'   • Updated: {updated_count} tools')
    print(f'   • Unchanged: {len(tools) - updated_count} tools')
    
    client.close()

if __name__ == "__main__":
    asyncio.run(remove_numbered_steps())
