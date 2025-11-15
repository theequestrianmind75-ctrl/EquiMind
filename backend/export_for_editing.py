"""
Export all tools in a clean, editable JSON format
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import json

load_dotenv()

async def export_tools():
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("📤 Exporting tools for editing...")
    
    # Get all tools
    tools = await db.mental_strategies.find().to_list(None)
    
    # Clean format for editing
    clean_tools = []
    for tool in tools:
        clean_tool = {
            "id": tool.get("id"),
            "name": tool.get("name"),
            "category": tool.get("category"),
            "instructions": tool.get("instructions", ""),
            "duration_minutes": tool.get("duration_minutes"),
            "description": tool.get("description", ""),
            "evidence_base": tool.get("evidence_base", ""),
            "suitable_for": tool.get("suitable_for", []),
            "anxiety_level": tool.get("anxiety_level", []),
            "confidence_level": tool.get("confidence_level", []),
            "effectiveness_rating": tool.get("effectiveness_rating", 0.0)
        }
        clean_tools.append(clean_tool)
    
    # Sort by category then name
    clean_tools.sort(key=lambda x: (x.get("category", ""), x.get("name", "")))
    
    # Save to file
    output_file = '/app/equimind_tools_for_editing.json'
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(clean_tools, f, indent=2, ensure_ascii=False)
    
    print(f'✅ Exported {len(clean_tools)} tools to:')
    print(f'   {output_file}')
    print(f'\nFile size: {os.path.getsize(output_file) / 1024:.1f} KB')
    
    client.close()

if __name__ == "__main__":
    asyncio.run(export_tools())
