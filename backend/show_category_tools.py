"""
Show tools from a specific category in readable format
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import sys

load_dotenv()

async def show_category_tools(category_name):
    client = AsyncIOMotorClient(os.environ['MONGO_URL'])
    db = client[os.environ['DB_NAME']]
    
    # Get all tools and filter by category
    all_tools = await db.mental_strategies.find().to_list(None)
    tools = [t for t in all_tools if category_name.lower() in t.get('category', '').lower()]
    
    print(f'\n📚 {category_name} Tools ({len(tools)} total)\n')
    print('='*80)
    
    for i, tool in enumerate(tools, 1):
        print(f'\n🔹 TOOL #{i}: {tool.get("name")}')
        print(f'   Duration: {tool.get("duration_minutes")} minutes')
        print(f'\n   What Riders See:')
        print(f'   ───────────────────────────────────')
        instr = tool.get('instructions', '')
        if instr and len(instr.strip()) > 0:
            # Show instructions with indentation
            for line in instr.split('\n'):
                print(f'   {line}')
        else:
            print('   [EMPTY - NEEDS CONTENT]')
        print('='*80)
    
    client.close()

if __name__ == "__main__":
    category = sys.argv[1] if len(sys.argv) > 1 else "Mindfulness"
    asyncio.run(show_category_tools(category))
