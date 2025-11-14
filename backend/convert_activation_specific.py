import json
from pathlib import Path

BASE = Path("/app/backend/legacy_tools_export")

IN_FILE = BASE / "activation_grounding.json"
OUT_FILE = BASE / "activation_grounding_equimind.json"

CATEGORY = "activation_grounding"

EVIDENCE = (
    "Cognitive behavioral therapy (CBT), grounding techniques, "
    "and sports psychology arousal management."
)

SUITABLE_DEFAULT = ["overwhelm", "panic", "grounding", "performance_stress"]

def to_trigger_range(levels, default_min=1, default_max=10):
    if isinstance(levels, list) and levels:
        return min(levels), max(levels)
    return default_min, default_max

def convert_tool(legacy):
    desc = legacy.get("description")
    if not desc or not str(desc).strip():
        desc = (
            "Grounding and activation tool to bring the rider back into their body "
            "and into the present moment while riding."
        )

    anx_min, anx_max = to_trigger_range(legacy.get("anxiety_level"))
    conf_min, conf_max = to_trigger_range(legacy.get("confidence_level"))

    instr_raw = (legacy.get("instructions") or "").strip()
    if instr_raw:
        instructions = [
            "Put your horse in a safe, simple context (halt or easy walk) if activation is high.",
            f"Use this grounding focus: {instr_raw}",
            "Continue for the suggested duration, then reassess your activation level and your horse's response."
        ]
    else:
        instructions = [
            "Put your horse in a safe, simple context (halt or easy walk) if activation is high.",
            "Follow the activation/grounding focus as described in the EquiMind app.",
            "Continue for the suggested duration, then reassess your activation level and your horse's response."
        ]

    evidence = (legacy.get("evidence_base") or "").strip() or EVIDENCE
    suitable = legacy.get("suitable_for") or SUITABLE_DEFAULT
    duration = legacy.get("duration_minutes") or 5

    return {
        "name": legacy.get("name") or "EquiMind Activation/Grounding Tool",
        "category": CATEGORY,
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

def main():
    data = json.loads(IN_FILE.read_text())
    tools = data.get("tools") if isinstance(data, dict) else data
    converted = [convert_tool(tool) for tool in tools]
    OUT_FILE.write_text(json.dumps(converted, indent=2))
    print(f"Converted {len(converted)} activation/grounding tools → {OUT_FILE}")

if __name__ == "__main__":
    main()
