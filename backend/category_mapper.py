"""
Category Mapper for EquiMind Tools
Unifies legacy and new tool formats with standardized categories
"""
import json
from pathlib import Path
from typing import Dict, List, Any

# ============================================================================
# CATEGORY MAPPING CONFIGURATION
# ============================================================================

# Define the unified category structure
# Format: "new_category": ["legacy_variant1", "legacy_variant2", ...]
CATEGORY_MAPPING = {
    "BODY RESET": ["body_reset", "body reset", "Somatic Reset", "somatic_reset", "somatic"],
    "Tapping / EFT": ["tapping", "eft", "tapping/eft", "tapping_eft"],
    "Breathing / HRV": ["breathing", "hrv", "breathing_hrv", "breath", "breathwork"],
    "Mindfulness & Flow": ["mindfulness", "mindfulness_flow", "flow", "mindfulness & flow"]
}

# Reverse mapping for quick lookup: variant -> standard category
REVERSE_MAPPING = {}
for standard, variants in CATEGORY_MAPPING.items():
    REVERSE_MAPPING[standard.lower()] = standard
    for variant in variants:
        REVERSE_MAPPING[variant.lower()] = standard


# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

def normalize_category(category: str) -> str:
    """
    Convert any category variant to the standardized form.
    
    Args:
        category: Category name in any format
        
    Returns:
        Standardized category name
    """
    if not category:
        return "Mindfulness & Flow"  # Default
    
    normalized = REVERSE_MAPPING.get(category.lower())
    if normalized:
        return normalized
    
    # If not found, return original with proper casing
    return category.strip()


def to_trigger_range(levels, default_min=1, default_max=10):
    """Convert anxiety/confidence levels to min/max range."""
    if isinstance(levels, list) and levels:
        return min(levels), max(levels)
    return default_min, default_max


def legacy_to_new_format(legacy_tool: Dict[str, Any]) -> Dict[str, Any]:
    """
    Convert legacy tool format to new standardized format.
    
    Legacy format (database):
        - name, category, description, instructions (string), 
        - anxiety_level (list), confidence_level (list),
        - duration_minutes, evidence_base, suitable_for
    
    New format (your script):
        - name, category, description, instructions (list),
        - trigger_conditions: {anxiety_min/max, confidence_min/max},
        - duration_minutes, evidence_base, suitable_for
    """
    # Normalize category
    category = normalize_category(legacy_tool.get("category", ""))
    
    # Handle instructions
    instructions = legacy_tool.get("instructions", "")
    if isinstance(instructions, str):
        # Split by newlines and create structured steps
        raw_steps = [s.strip() for s in instructions.split('\n') if s.strip()]
        if raw_steps:
            instructions = [
                "Place your horse and yourself in a safe, low-demand context before starting this tool.",
                *raw_steps,
                "Continue for the suggested duration, then return to normal riding and notice what feels different."
            ]
        else:
            instructions = [
                "Place your horse and yourself in a safe, low-demand context before starting this tool.",
                "Follow the guidance provided in the EquiMind app.",
                "Continue for the suggested duration and notice any changes."
            ]
    elif not isinstance(instructions, list):
        instructions = [str(instructions)]
    
    # Convert anxiety/confidence levels to trigger conditions
    anx_min, anx_max = to_trigger_range(legacy_tool.get("anxiety_level"))
    conf_min, conf_max = to_trigger_range(legacy_tool.get("confidence_level"))
    
    # Build new format
    new_tool = {
        "id": legacy_tool.get("id"),  # Preserve ID if exists
        "name": legacy_tool.get("name", "EquiMind Tool"),
        "category": category,
        "description": legacy_tool.get("description", "Mental performance tool for equestrians."),
        "duration_minutes": legacy_tool.get("duration_minutes", 5),
        "trigger_conditions": {
            "anxiety_min": anx_min,
            "anxiety_max": anx_max,
            "confidence_min": conf_min,
            "confidence_max": conf_max
        },
        "instructions": instructions,
        "evidence_base": legacy_tool.get("evidence_base", "Evidence-based mental performance techniques."),
        "suitable_for": legacy_tool.get("suitable_for", ["general_use"])
    }
    
    # Preserve optional fields
    if "effectiveness_rating" in legacy_tool:
        new_tool["effectiveness_rating"] = legacy_tool["effectiveness_rating"]
    
    return new_tool


def new_to_legacy_format(new_tool: Dict[str, Any]) -> Dict[str, Any]:
    """
    Convert new tool format to legacy database format.
    
    This ensures tools can be inserted into the existing database.
    """
    # Normalize category
    category = normalize_category(new_tool.get("category", ""))
    
    # Handle instructions
    instructions = new_tool.get("instructions", [])
    if isinstance(instructions, list):
        # Join list into string with newlines
        instructions = '\n'.join(instructions)
    
    # Convert trigger conditions to anxiety/confidence level lists
    trigger = new_tool.get("trigger_conditions", {})
    anx_min = trigger.get("anxiety_min", 1)
    anx_max = trigger.get("anxiety_max", 10)
    conf_min = trigger.get("confidence_min", 1)
    conf_max = trigger.get("confidence_max", 10)
    
    # Build legacy format
    legacy_tool = {
        "id": new_tool.get("id"),  # Preserve or generate ID
        "name": new_tool.get("name", "EquiMind Tool"),
        "category": category,
        "description": new_tool.get("description", "Mental performance tool for equestrians."),
        "instructions": instructions,
        "duration_minutes": new_tool.get("duration_minutes", 5),
        "anxiety_level": list(range(anx_min, anx_max + 1)),
        "confidence_level": list(range(conf_min, conf_max + 1)),
        "evidence_base": new_tool.get("evidence_base", "Evidence-based mental performance techniques."),
        "suitable_for": new_tool.get("suitable_for", ["general_use"])
    }
    
    # Preserve optional fields
    if "effectiveness_rating" in new_tool:
        legacy_tool["effectiveness_rating"] = new_tool["effectiveness_rating"]
    
    return legacy_tool


# ============================================================================
# MAIN CONVERSION FUNCTIONS
# ============================================================================

def convert_file(
    input_file: Path,
    output_file: Path,
    to_format: str = "new",
    force_category: str = None
):
    """
    Convert a JSON file of tools from one format to another.
    
    Args:
        input_file: Path to input JSON file
        output_file: Path to output JSON file
        to_format: "new" or "legacy"
        force_category: Override all categories with this value (optional)
    """
    # Read input file
    data = json.loads(input_file.read_text())
    
    # Handle both array and object with "tools" key
    tools = data.get("tools") if isinstance(data, dict) else data
    
    if not isinstance(tools, list):
        raise ValueError("Input file must contain a list of tools or an object with 'tools' key")
    
    # Convert tools
    converted = []
    for tool in tools:
        if to_format == "new":
            converted_tool = legacy_to_new_format(tool)
        else:
            converted_tool = new_to_legacy_format(tool)
        
        # Force category if specified
        if force_category:
            converted_tool["category"] = normalize_category(force_category)
        
        converted.append(converted_tool)
    
    # Write output file
    output_file.write_text(json.dumps(converted, indent=2))
    print(f"✅ Converted {len(converted)} tools → {output_file}")
    print(f"   Format: {to_format}")
    if force_category:
        print(f"   Category: {normalize_category(force_category)}")


def show_category_report(tools: List[Dict[str, Any]]):
    """Show a report of categories in the tools."""
    categories = {}
    for tool in tools:
        cat = tool.get("category", "Unknown")
        normalized = normalize_category(cat)
        if normalized not in categories:
            categories[normalized] = {"original": set(), "count": 0}
        categories[normalized]["original"].add(cat)
        categories[normalized]["count"] += 1
    
    print("\n" + "="*60)
    print("CATEGORY REPORT")
    print("="*60)
    for normalized, info in sorted(categories.items()):
        print(f"\n{normalized}: {info['count']} tools")
        if len(info['original']) > 1:
            print(f"  (from variants: {', '.join(info['original'])})")


# ============================================================================
# CLI INTERFACE
# ============================================================================

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("""
Usage:
  python category_mapper.py <command> [args]

Commands:
  normalize <input.json> <output.json> [category]
    - Normalizes all categories in the file
    - Optionally forces all tools to a specific category
  
  to-new <input.json> <output.json>
    - Converts legacy format to new format
  
  to-legacy <input.json> <output.json>
    - Converts new format to legacy format
  
  report <input.json>
    - Shows category distribution report

Examples:
  python category_mapper.py normalize mindfulness.json mindfulness_fixed.json
  python category_mapper.py normalize mindfulness.json mindfulness_fixed.json "Mindfulness & Flow"
  python category_mapper.py to-new legacy_tools.json new_tools.json
  python category_mapper.py report all_tools.json
        """)
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "report":
        input_file = Path(sys.argv[2])
        data = json.loads(input_file.read_text())
        tools = data.get("tools") if isinstance(data, dict) else data
        show_category_report(tools)
    
    elif command in ["normalize", "to-new", "to-legacy"]:
        input_file = Path(sys.argv[2])
        output_file = Path(sys.argv[3])
        force_category = sys.argv[4] if len(sys.argv) > 4 else None
        
        if command == "normalize":
            # Read, normalize categories, write
            data = json.loads(input_file.read_text())
            tools = data.get("tools") if isinstance(data, dict) else data
            
            for tool in tools:
                if force_category:
                    tool["category"] = normalize_category(force_category)
                else:
                    tool["category"] = normalize_category(tool.get("category", ""))
            
            output_file.write_text(json.dumps(tools, indent=2))
            print(f"✅ Normalized {len(tools)} tools → {output_file}")
            show_category_report(tools)
        
        elif command == "to-new":
            convert_file(input_file, output_file, "new", force_category)
        
        elif command == "to-legacy":
            convert_file(input_file, output_file, "legacy", force_category)
    
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)
