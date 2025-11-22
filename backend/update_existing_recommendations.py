import asyncio
from motor.motor_asyncio import AsyncIOMotorClient

# MongoDB connection
mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind_production"

# Mapping of conceptual categories to real database categories
trigger_to_categories = {
    "high_anxiety": ["Breathing / HRV", "Tapping / EFT"],
    "anxiety_increased": ["Mindfulness / Grounding", "Mindfulness & Flow"],
    "low_confidence": ["Mindfulness & Flow", "Values & Motivation Reflection", "Skill Development / Exploration"],
    "confidence_decreased": ["Mindfulness & Flow", "Mindfulness / Grounding"],
    "high_anxiety_low_confidence": ["BODY RESET", "Mindfulness / Grounding"],
    "high_horse_energy_low_confidence": ["BODY RESET", "Somatic Reset / Gentle Movement", "Horse Connection & Focus"],
    "low_horse_focus": ["Somatic Reset / Gentle Movement", "Horse Connection & Focus"],
    "optimal_performance": ["Mindfulness & Flow", "Visualization / Imagery", "Skill Development / Exploration"],
    "good_improvement": ["Mindfulness & Flow", "Values & Motivation Reflection"],
    "optimal_horse_metrics": ["Horse Connection & Focus", "Mindfulness & Flow"],
    "default": ["Mindfulness & Flow", "Activation / Grounding", "Mindfulness / Grounding"]
}

async def update_recommendations():
    client = AsyncIOMotorClient(mongo_url)
    db = client[db_name]
    
    print(f"🔄 Updating existing recommendations with tool mappings...\n")
    
    updated_count = 0
    skipped_count = 0
    
    for trigger_id, categories in trigger_to_categories.items():
        # Find recommendation for this trigger
        rec = await db.recommendations.find_one({"trigger_condition": trigger_id})
        
        if not rec:
            print(f"⚠️  Recommendation not found for trigger: {trigger_id}")
            skipped_count += 1
            continue
        
        # Get tools from these categories (3 tools per trigger)
        tools = []
        for category in categories:
            category_tools = await db.mental_strategies.find(
                {"category": category},
                {"name": 1, "_id": 0}
            ).limit(2).to_list(length=2)
            
            tools.extend([tool["name"] for tool in category_tools])
        
        # Limit to 3 tools
        tool_names = tools[:3]
        
        if len(tool_names) < 3:
            print(f"⚠️  Only found {len(tool_names)} tools for {trigger_id}")
        
        # Update recommendation with tool names
        result = await db.recommendations.update_one(
            {"trigger_condition": trigger_id},
            {"$set": {"suggested_tool_names": tool_names}}
        )
        
        if result.modified_count > 0:
            updated_count += 1
            print(f"✅ Updated {trigger_id}:")
            for i, tool in enumerate(tool_names, 1):
                print(f"   {i}. {tool}")
        else:
            print(f"⚠️  No changes for {trigger_id} (may already have tools)")
            skipped_count += 1
    
    print(f"\n📊 Summary:")
    print(f"   Updated: {updated_count}")
    print(f"   Skipped: {skipped_count}")
    print(f"   Total: {updated_count + skipped_count}")
    
    # Show final count
    total_recs = await db.recommendations.count_documents({})
    recs_with_tools = await db.recommendations.count_documents({"suggested_tool_names": {"$exists": True, "$ne": []}})
    
    print(f"\n✅ Recommendations with tool mappings: {recs_with_tools}/{total_recs}")
    
    client.close()

if __name__ == '__main__':
    asyncio.run(update_recommendations())
