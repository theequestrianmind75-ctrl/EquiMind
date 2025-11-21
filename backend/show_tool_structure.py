from pymongo import MongoClient
import json

mongo_url = "mongodb+srv://equimind_admin:SecurePass2024!@cluster0.wzahss.mongodb.net/?appName=Cluster0"
db_name = "equimind"
client = MongoClient(mongo_url)
db = client[db_name]

# Get a sample tool to show the structure
sample_tool = db.mental_strategies.find_one({})

if sample_tool:
    # Remove _id for cleaner display
    if '_id' in sample_tool:
        del sample_tool['_id']
    
    print("📋 CURRENT TOOL STRUCTURE\n")
    print(json.dumps(sample_tool, indent=2))
    
    print("\n\n" + "="*60)
    print("📝 TEMPLATE FOR NEW TOOLS")
    print("="*60 + "\n")
    
    # Create a template
    template = {
        "id": "unique-id-here",
        "name": "Tool Name Here",
        "category": "BODY RESET or Breathing / HRV or Mindfulness & Flow or Tapping / EFT",
        "description": "Brief description (optional)",
        "instructions": "Detailed step-by-step instructions for the rider to follow...",
        "duration_minutes": 5,
        "anxiety_level": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        "confidence_level": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        "effectiveness_rating": 4.5,
        "metadata": {
            "phases": ["pre-ride", "during-ride", "post-ride"]
        }
    }
    
    print(json.dumps(template, indent=2))
    
    print("\n\n" + "="*60)
    print("📊 FIELD DESCRIPTIONS")
    print("="*60)
    print("""
Required Fields:
  - id: Unique identifier (string)
  - name: Tool name (string)
  - category: One of the 4 categories (string)
  - instructions: Full instructions for the rider (string)
  - duration_minutes: How long the exercise takes (number)
  
Optional Fields:
  - description: Brief summary (string)
  - anxiety_level: Array of numbers 1-10 indicating which anxiety levels this tool helps
  - confidence_level: Array of numbers 1-10 indicating which confidence levels this tool targets
  - effectiveness_rating: Rating out of 5 (number)
  - metadata: Additional info like phases, tags, etc. (object)
    """)
    
    print("\n" + "="*60)
    print("📂 VALID CATEGORIES (MUST MATCH EXACTLY)")
    print("="*60)
    categories = db.mental_strategies.distinct("category")
    for i, cat in enumerate(sorted(categories), 1):
        print(f"  {i}. {cat}")

client.close()
