"""
Comprehensive validation script for mental strategies database
Checks all items from the validation checklist
"""
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio
from dotenv import load_dotenv
import os
from collections import defaultdict

load_dotenv()

# Valid categories mapping
VALID_CATEGORIES = {
    'Mindfulness & Flow': 'mindfulness',
    'Breathing / HRV': 'breathing_hrv',
    'Activation / Grounding': 'activation_grounding',
    'Somatic Reset': 'somatic_reset',
    'Tapping / EFT': 'tapping'
}

async def validate_strategies():
    mongo_url = os.environ['MONGO_URL']
    client = AsyncIOMotorClient(mongo_url)
    db = client[os.environ['DB_NAME']]
    
    print("=" * 80)
    print("🔍 COMPREHENSIVE STRATEGY VALIDATION")
    print("=" * 80)
    
    # Get all strategies
    strategies = await db.mental_strategies.find().to_list(None)
    total_count = len(strategies)
    
    print(f"\n📊 Total Strategies: {total_count}")
    print("=" * 80)
    
    # Validation trackers
    issues = []
    warnings = []
    duplicates = defaultdict(list)
    category_counts = defaultdict(int)
    
    # Track names for duplicates
    names_seen = {}
    
    for idx, strategy in enumerate(strategies, 1):
        strategy_id = strategy.get('id', 'NO_ID')
        name = strategy.get('name', 'NO_NAME')
        category = strategy.get('category', 'NO_CATEGORY')
        
        # 1. REQUIRED FIELDS CHECK
        # Check name
        if not name or name == 'NO_NAME' or len(name.strip()) < 3:
            issues.append(f"❌ [{idx}] Missing or invalid name: '{name}'")
        
        # Check category
        if category not in VALID_CATEGORIES:
            issues.append(f"❌ [{idx}] '{name}': Invalid category '{category}'. Must be one of: {list(VALID_CATEGORIES.keys())}")
        else:
            category_counts[category] += 1
        
        # Check description
        description = strategy.get('description', '')
        if not description or len(description.strip()) < 10:
            issues.append(f"❌ [{idx}] '{name}': Missing or too short description")
        
        # Check duration_minutes
        duration = strategy.get('duration_minutes')
        if duration is None:
            issues.append(f"❌ [{idx}] '{name}': Missing duration_minutes")
        elif not isinstance(duration, (int, float)):
            issues.append(f"❌ [{idx}] '{name}': duration_minutes must be a number, got {type(duration)}")
        elif duration < 1 or duration > 10:
            warnings.append(f"⚠️  [{idx}] '{name}': duration_minutes {duration} outside typical range (1-10)")
        
        # Check instructions
        instructions = strategy.get('instructions', '')
        if not instructions:
            issues.append(f"❌ [{idx}] '{name}': Missing instructions")
        elif isinstance(instructions, str):
            # Count steps (assuming newline-separated)
            steps = [s.strip() for s in instructions.split('\n') if s.strip()]
            if len(steps) < 3:
                warnings.append(f"⚠️  [{idx}] '{name}': Only {len(steps)} instruction steps (recommended: 3+)")
        elif isinstance(instructions, list):
            if len(instructions) < 3:
                warnings.append(f"⚠️  [{idx}] '{name}': Only {len(instructions)} instruction steps (recommended: 3+)")
        
        # Check evidence_base
        evidence = strategy.get('evidence_base', '')
        if not evidence or len(evidence.strip()) < 10:
            warnings.append(f"⚠️  [{idx}] '{name}': Missing or minimal evidence_base")
        
        # Check suitable_for
        suitable_for = strategy.get('suitable_for', [])
        if not suitable_for or len(suitable_for) == 0:
            warnings.append(f"⚠️  [{idx}] '{name}': Missing suitable_for tags")
        
        # 2. TRIGGER CONDITIONS CHECK
        # Check for old format (anxiety_level, confidence_level arrays)
        anxiety_level = strategy.get('anxiety_level', [])
        confidence_level = strategy.get('confidence_level', [])
        
        if anxiety_level and confidence_level:
            # Old format - derive min/max
            if anxiety_level:
                anxiety_min = min(anxiety_level)
                anxiety_max = max(anxiety_level)
            else:
                anxiety_min = anxiety_max = None
                
            if confidence_level:
                confidence_min = min(confidence_level)
                confidence_max = max(confidence_level)
            else:
                confidence_min = confidence_max = None
        else:
            # New format - check trigger_conditions object
            trigger = strategy.get('trigger_conditions', {})
            anxiety_min = trigger.get('anxiety_min')
            anxiety_max = trigger.get('anxiety_max')
            confidence_min = trigger.get('confidence_min')
            confidence_max = trigger.get('confidence_max')
        
        # Validate ranges
        if anxiety_min is None or anxiety_max is None:
            issues.append(f"❌ [{idx}] '{name}': Missing anxiety trigger conditions")
        elif anxiety_min > anxiety_max:
            issues.append(f"❌ [{idx}] '{name}': anxiety_min ({anxiety_min}) > anxiety_max ({anxiety_max})")
        elif anxiety_min < 1 or anxiety_max > 10:
            warnings.append(f"⚠️  [{idx}] '{name}': Anxiety range outside 1-10")
        
        if confidence_min is None or confidence_max is None:
            issues.append(f"❌ [{idx}] '{name}': Missing confidence trigger conditions")
        elif confidence_min > confidence_max:
            issues.append(f"❌ [{idx}] '{name}': confidence_min ({confidence_min}) > confidence_max ({confidence_max})")
        elif confidence_min < 1 or confidence_max > 10:
            warnings.append(f"⚠️  [{idx}] '{name}': Confidence range outside 1-10")
        
        # 3. DUPLICATE CHECK
        if name in names_seen:
            duplicates[name].append((names_seen[name], idx))
        else:
            names_seen[name] = idx
        
        # 4. SAFETY VALIDATION (basic checks in instructions text)
        instructions_text = str(instructions).lower()
        
        # Check for potentially unsafe instructions
        if 'drop reins' in instructions_text and ('trot' in instructions_text or 'canter' in instructions_text):
            warnings.append(f"⚠️  [{idx}] '{name}': Potentially unsafe - mentions dropping reins at faster gaits")
        
        if 'dismount' in instructions_text and category not in ['Activation / Grounding']:
            warnings.append(f"⚠️  [{idx}] '{name}': Contains dismount instruction - verify this is intentional")
    
    # PRINT RESULTS
    print(f"\n📂 CATEGORY DISTRIBUTION:")
    print("-" * 80)
    for cat in sorted(category_counts.keys()):
        print(f"   {cat}: {category_counts[cat]} tools")
    
    if duplicates:
        print(f"\n🔄 DUPLICATE NAMES FOUND: {len(duplicates)}")
        print("-" * 80)
        for name, indices in duplicates.items():
            print(f"   '{name}': appears at indices {indices}")
    else:
        print(f"\n✅ NO DUPLICATE NAMES FOUND")
    
    if issues:
        print(f"\n❌ CRITICAL ISSUES FOUND: {len(issues)}")
        print("-" * 80)
        for issue in issues[:20]:  # Show first 20
            print(f"   {issue}")
        if len(issues) > 20:
            print(f"   ... and {len(issues) - 20} more issues")
    else:
        print(f"\n✅ NO CRITICAL ISSUES FOUND")
    
    if warnings:
        print(f"\n⚠️  WARNINGS: {len(warnings)}")
        print("-" * 80)
        for warning in warnings[:20]:  # Show first 20
            print(f"   {warning}")
        if len(warnings) > 20:
            print(f"   ... and {len(warnings) - 20} more warnings")
    else:
        print(f"\n✅ NO WARNINGS")
    
    # SUMMARY
    print("\n" + "=" * 80)
    print("📋 VALIDATION SUMMARY")
    print("=" * 80)
    print(f"Total Strategies: {total_count}")
    print(f"Critical Issues: {len(issues)}")
    print(f"Warnings: {len(warnings)}")
    print(f"Duplicates: {len(duplicates)}")
    
    if len(issues) == 0 and len(duplicates) == 0:
        print("\n🎉 DATABASE PASSED ALL CRITICAL VALIDATION CHECKS!")
        if len(warnings) > 0:
            print(f"   Note: {len(warnings)} warnings found but these are non-blocking")
    else:
        print("\n⚠️  DATABASE HAS ISSUES THAT NEED ATTENTION")
    
    print("=" * 80)
    
    client.close()

if __name__ == "__main__":
    asyncio.run(validate_strategies())
