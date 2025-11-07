import asyncio
import csv
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv
from pathlib import Path

ROOT_DIR = Path(__file__).parent
load_dotenv(ROOT_DIR / '.env')

async def export_tools():
    # Connect to MongoDB
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    # Fetch all strategies
    strategies = await db.mental_strategies.find({}).to_list(1000)
    
    print(f"Found {len(strategies)} tools")
    
    # Define CSV file path
    csv_file = '/app/rider_tools_export.csv'
    
    # Write to CSV
    with open(csv_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        
        # Write header
        writer.writerow([
            'Tool Name',
            'Category',
            'Duration (minutes)',
            'Effectiveness Rating',
            'Anxiety Level Range',
            'Confidence Level Range',
            'Instructions',
            'Description'
        ])
        
        # Write data
        for strategy in strategies:
            # Clean instructions
            instructions = strategy.get('instructions', '')
            instructions = instructions.replace('Micro Script:', '').replace('Audio Script:', '').replace('Coach:', '').strip()
            
            # Get the actual intervention (skip first paragraph)
            paragraphs = instructions.split('\n\n')
            if len(paragraphs) > 1:
                instructions = '\n\n'.join(paragraphs[1:]).strip()
            
            anxiety_range = f"{min(strategy.get('anxiety_level', [0]))}-{max(strategy.get('anxiety_level', [0]))}"
            confidence_range = f"{min(strategy.get('confidence_level', [0]))}-{max(strategy.get('confidence_level', [0]))}"
            
            writer.writerow([
                strategy.get('name', ''),
                strategy.get('category', ''),
                strategy.get('duration_minutes', ''),
                strategy.get('effectiveness_rating', ''),
                anxiety_range,
                confidence_range,
                instructions,
                strategy.get('description', '')
            ])
    
    client.close()
    print(f"Export complete! File saved to: {csv_file}")
    print(f"Total tools exported: {len(strategies)}")

if __name__ == '__main__':
    asyncio.run(export_tools())
