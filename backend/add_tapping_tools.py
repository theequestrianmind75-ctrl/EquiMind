"""
Script to add Tapping (EFT) tools to the database
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
import uuid

load_dotenv()

async def add_tapping_tools():
    # Connect to MongoDB
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("🔄 Adding Tapping (EFT) tools to database...")
    
    tapping_tools = [
        {
            'id': str(uuid.uuid4()),
            'name': 'Pre-Ride Anxiety Release',
            'category': 'Tapping / EFT',
            'description': 'Calm your nerves before getting in the saddle',
            'instructions': 'Start with the Karate Chop point on the side of your hand. Tap gently while saying: "Even though I feel nervous about this ride, I deeply and completely accept myself." Continue tapping through the sequence: Eyebrow, Side of Eye, Under Eye, Under Nose, Under Mouth, Collarbone, Under Arm, Top of Head. At each point, acknowledge your feelings: "This nervousness... This anxiety... I choose to feel calm and confident... I am safe... My horse and I are a team." Complete 2-3 rounds until you feel more centered.',
            'duration_minutes': 5,
            'anxiety_level': [5, 6, 7, 8, 9, 10],
            'confidence_level': [1, 2, 3, 4, 5],
            'effectiveness_rating': 4.0
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Fear of Falling Reset',
            'category': 'Tapping / EFT',
            'description': 'Release fear and build confidence after a fall or scary moment',
            'instructions': 'Begin at the Karate Chop point, tapping while saying: "Even though I have this fear of falling, I am safe right now." Move through the points: Eyebrow - "This fear in my body..." Side of Eye - "This worry about falling..." Under Eye - "Feeling unsafe..." Under Nose - "This fear..." Under Mouth - "I choose to feel grounded..." Collarbone - "I am learning and growing..." Under Arm - "My body knows how to balance..." Top of Head - "I trust myself and my horse." Repeat until fear diminishes.',
            'duration_minutes': 7,
            'anxiety_level': [7, 8, 9, 10],
            'confidence_level': [1, 2, 3],
            'effectiveness_rating': 4.5
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Competition Day Calm',
            'category': 'Tapping / EFT',
            'description': 'Reduce performance anxiety before showing',
            'instructions': 'Karate Chop setup: "Even though I feel pressure to perform, I choose to enjoy this moment with my horse." Tap through the sequence: Eyebrow - "This performance pressure..." Side of Eye - "This need to be perfect..." Under Eye - "Worrying about what others think..." Under Nose - "This anxiety about mistakes..." Under Mouth - "I release this pressure..." Collarbone - "I am prepared..." Under Arm - "My horse and I are partners..." Top of Head - "We ride with joy and confidence." 2-3 rounds.',
            'duration_minutes': 5,
            'anxiety_level': [6, 7, 8, 9],
            'confidence_level': [2, 3, 4, 5],
            'effectiveness_rating': 4.2
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Quick Confidence Boost',
            'category': 'Tapping / EFT',
            'description': 'Fast tapping sequence to build confidence before any challenge',
            'instructions': 'Rapid tapping sequence - spend just 10 seconds on each point. Karate Chop: "I am capable and strong." Eyebrow: "I trust myself." Side of Eye: "I am confident." Under Eye: "I feel safe." Under Nose: "I am prepared." Under Mouth: "I believe in myself." Collarbone: "My horse trusts me." Under Arm: "We work together." Top of Head: "I am ready." Repeat 2 times quickly.',
            'duration_minutes': 3,
            'anxiety_level': [4, 5, 6],
            'confidence_level': [4, 5, 6, 7],
            'effectiveness_rating': 3.8
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Post-Ride Processing',
            'category': 'Tapping / EFT',
            'description': 'Release stress and integrate lessons after a difficult ride',
            'instructions': 'Karate Chop: "Even though that ride was challenging, I honor my effort and my horse\'s effort." Gently tap through points: Eyebrow - "Whatever happened today..." Side of Eye - "Any disappointment I feel..." Under Eye - "Any frustration..." Under Nose - "I acknowledge these feelings..." Under Mouth - "I learned something today..." Collarbone - "I am growing as a rider..." Under Arm - "Tomorrow is a new day..." Top of Head - "I release this and move forward with grace." Take deep breaths between rounds.',
            'duration_minutes': 6,
            'anxiety_level': [5, 6, 7, 8],
            'confidence_level': [3, 4, 5, 6],
            'effectiveness_rating': 4.0
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Trauma Release for Horse & Rider',
            'category': 'Tapping / EFT',
            'description': 'Gentle tapping to process past scary experiences',
            'instructions': 'This is for processing past events, not current danger. Karate Chop: "Even though that scary thing happened, I am safe now." Very gently tap: Eyebrow - "That memory..." Side of Eye - "How it made me feel..." Under Eye - "The fear that stayed with me..." Under Nose - "It\'s in the past now..." Under Mouth - "I am safe in this moment..." Collarbone - "My body can release this..." Under Arm - "I choose peace..." Top of Head - "I am healing." Go slowly, breathe deeply. Repeat as needed over several sessions.',
            'duration_minutes': 8,
            'anxiety_level': [8, 9, 10],
            'confidence_level': [1, 2, 3],
            'effectiveness_rating': 4.5
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Morning Ride Preparation',
            'category': 'Tapping / EFT',
            'description': 'Start your riding day centered and positive',
            'instructions': 'Karate Chop: "Even though I don\'t know what today will bring, I welcome it with an open heart." Tap through: Eyebrow - "Today is a new beginning..." Side of Eye - "I am open to learning..." Under Eye - "I feel grateful for my horse..." Under Nose - "We communicate with trust..." Under Mouth - "I ride with intention..." Collarbone - "My mind is clear..." Under Arm - "My body is ready..." Top of Head - "This will be a good day." Set your positive intention.',
            'duration_minutes': 4,
            'anxiety_level': [3, 4, 5],
            'confidence_level': [5, 6, 7, 8],
            'effectiveness_rating': 3.5
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Connection with Horse',
            'category': 'Tapping / EFT',
            'description': 'Enhance your energetic bond with your horse through tapping',
            'instructions': 'Do this near your horse if possible. Karate Chop: "Even though we are separate beings, we connect as one." Tap gently: Eyebrow - "I feel my horse\'s energy..." Side of Eye - "Our hearts align..." Under Eye - "We breathe together..." Under Nose - "Trust flows between us..." Under Mouth - "We understand each other..." Collarbone - "We move as partners..." Under Arm - "Our connection deepens..." Top of Head - "We are one team." Notice how your horse responds to your calm energy.',
            'duration_minutes': 5,
            'anxiety_level': [2, 3, 4, 5],
            'confidence_level': [6, 7, 8, 9],
            'effectiveness_rating': 4.0
        },
    ]
    
    # Insert tapping tools
    if tapping_tools:
        result = await db.mental_strategies.insert_many(tapping_tools)
        print(f"✅ Successfully added {len(result.inserted_ids)} tapping tools")
    
    # Verify
    tapping_count = await db.mental_strategies.count_documents({'category': 'Tapping / EFT'})
    print(f"📊 Total tapping tools in database: {tapping_count}")
    
    # Show samples
    print(f"\n📋 Sample tapping tools:")
    cursor = db.mental_strategies.find({'category': 'Tapping / EFT'}).limit(3)
    async for tool in cursor:
        print(f"  • {tool['name']} ({tool['duration_minutes']} min)")
    
    client.close()
    print("\n✨ Tapping tools added successfully!")

if __name__ == "__main__":
    asyncio.run(add_tapping_tools())
