"""
Export legacy tools by category as JSON for correction
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import json

load_dotenv()

async def export_legacy_tools():
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("🔄 Exporting legacy tools by category...")
    
    # Get all strategies
    strategies = await db.mental_strategies.find().to_list(None)
    
    # Identify legacy tools (missing evidence_base or suitable_for)
    legacy_tools = []
    for strategy in strategies:
        evidence = strategy.get('evidence_base', '')
        suitable = strategy.get('suitable_for', [])
        
        # Legacy tools are missing these fields or have them empty
        if not evidence or not suitable:
            legacy_tools.append(strategy)
    
    print(f"Found {len(legacy_tools)} legacy tools")
    
    # Group by category
    by_category = {}
    for tool in legacy_tools:
        category = tool.get('category', 'Unknown')
        if category not in by_category:
            by_category[category] = []
        
        # Clean up for export - remove MongoDB _id
        clean_tool = {
            'id': tool.get('id'),
            'name': tool.get('name'),
            'category': tool.get('category'),
            'description': tool.get('description', ''),
            'instructions': tool.get('instructions', ''),
            'duration_minutes': tool.get('duration_minutes'),
            'anxiety_level': tool.get('anxiety_level', []),
            'confidence_level': tool.get('confidence_level', []),
            'effectiveness_rating': tool.get('effectiveness_rating', 0.0),
            'evidence_base': tool.get('evidence_base', ''),
            'suitable_for': tool.get('suitable_for', [])
        }
        by_category[category].append(clean_tool)
    
    # Export each category to a separate JSON file
    output_dir = '/app/backend/legacy_tools_export'
    os.makedirs(output_dir, exist_ok=True)
    
    for category, tools in by_category.items():
        # Create filename from category
        filename = category.lower().replace(' / ', '_').replace(' ', '_').replace('&', 'and') + '.json'
        filepath = os.path.join(output_dir, filename)
        
        # Write JSON
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(tools, f, indent=2, ensure_ascii=False)
        
        print(f"✅ Exported {len(tools)} tools to: {filename}")
    
    # Also create a combined file
    combined_filepath = os.path.join(output_dir, 'all_legacy_tools.json')
    with open(combined_filepath, 'w', encoding='utf-8') as f:
        json.dump(legacy_tools, f, indent=2, ensure_ascii=False, default=str)
    
    print(f"\n✅ Combined export: all_legacy_tools.json ({len(legacy_tools)} tools)")
    
    # Create a summary file
    summary = {
        'total_legacy_tools': len(legacy_tools),
        'by_category': {cat: len(tools) for cat, tools in by_category.items()},
        'files_created': [
            f"{cat.lower().replace(' / ', '_').replace(' ', '_').replace('&', 'and')}.json"
            for cat in by_category.keys()
        ]
    }
    
    summary_filepath = os.path.join(output_dir, 'EXPORT_SUMMARY.json')
    with open(summary_filepath, 'w', encoding='utf-8') as f:
        json.dump(summary, f, indent=2)
    
    print(f"\n📋 Summary saved to: EXPORT_SUMMARY.json")
    print(f"\n📁 All files saved to: {output_dir}")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(export_legacy_tools())
