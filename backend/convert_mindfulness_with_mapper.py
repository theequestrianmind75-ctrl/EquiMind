"""
Modified mindfulness converter that uses the category mapper
"""
import json
from pathlib import Path
from category_mapper import normalize_category, new_to_legacy_format

BASE = Path("/app/backend/legacy_tools_export")

IN_FILE = BASE / "mindfulness_and_flow.json"
OUT_FILE = BASE / "mindfulness_and_flow_equimind.json"

# Use the standard category name
CATEGORY = "Mindfulness & Flow"  # Will be normalized automatically

EVIDENCE = (
    "Mindfulness-based stress reduction (MBSR), attentional control training, "
    "and equine-assisted mental skills work."
)

SUITABLE_DEFAULT = ["anxiety", "focus", "emotional_awareness"]

def to_trigger_range(levels, default_min=1, default_max=10):
    if isinstance(levels, list) and levels:
        return min(levels), max(levels)
    return default_min, default_max

def convert_tool(legacy):
    # Description
    desc = legacy.get("description")
    if not desc or not str(desc).strip():
        desc = (
            "On-horse mindfulness exercise to help rider and horse stay present "
            "and reduce mental noise."
        )

    # Trigger conditions
    anx_min, anx_max = to_trigger_range(legacy.get("anxiety_level"))
    conf_min, conf_max = to_trigger_range(legacy.get("confidence_level"))

    # Instructions
    instr_raw = (legacy.get("instructions") or "").strip()
    if instr_raw:
        instructions = [
            "Place your horse and yourself in a safe, low-demand context (halt or easy walk) before starting this tool.",
            f"Follow this focus: {instr_raw}",
            "Continue for the suggested duration or several breaths/strides, then return to normal riding and briefly notice what feels different."
        ]
    else:
        instructions = [
            "Place your horse and yourself in a safe, low-demand context (halt or easy walk) before starting this tool.",
            "Follow the focus of this mindfulness exercise as described in the EquiMind app.",
            "Continue for the suggested duration or several breaths/strides, then return to normal riding and briefly notice what feels different."
        ]

    # Evidence base
    evidence = (legacy.get("evidence_base") or "").strip() or EVIDENCE

    # Suitable_for
    suitable = legacy.get("suitable_for") or SUITABLE_DEFAULT

    # Duration
    duration = legacy.get("duration_minutes") or 5

    # Build tool in new format
    new_tool = {
        "name": legacy.get("name") or "EquiMind Mindfulness Tool",
        "category": CATEGORY,  # Use standard category
        "description": desc,
        "duration_minutes": duration,
        "trigger_conditions": {
            "anxiety_min": anx_min,
            "anxiety_max": anx_max,
            "confidence_min": conf_min,
            "confidence_max": conf_max
        },
        "instructions": instructions,
        "evidence_base": evidence,
        "suitable_for": suitable
    }
    
    # Convert to legacy format for database compatibility
    return new_to_legacy_format(new_tool)

def main():
    data = json.loads(IN_FILE.read_text())
    tools = data.get("tools") if isinstance(data, dict) else data
    converted = [convert_tool(tool) for tool in tools]
    
    OUT_FILE.write_text(json.dumps(converted, indent=2))
    print(f"✅ Converted {len(converted)} mindfulness tools → {OUT_FILE}")
    print(f"   Category: {normalize_category(CATEGORY)}")
    print(f"   Format: Legacy (ready for database import)")

if __name__ == "__main__":
    main()
