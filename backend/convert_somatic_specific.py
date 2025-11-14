import json
from pathlib import Path

BASE = Path("/app/backend/legacy_tools_export")

IN_FILE = BASE / "somatic_reset.json"
OUT_FILE = BASE / "somatic_reset_equimind.json"

CATEGORY = "somatic_reset"

EVIDENCE = (
    "Somatic experiencing, polyvagal theory, and body-based emotion regulation strategies."
)

SUITABLE_DEFAULT = ["tension", "freeze_response", "body_awareness"]

def to_trigger_range(levels, default_min=1, default_max=10):
    if isinstance(levels, list) and levels:
        return min(levels), max(levels)
    return default_min, default_max

def convert_tool(legacy):
    desc = legacy.get("description")
    if not desc or not str(desc).strip():
        desc = (
            "Somatic nervous-system reset to release tension in the rider's body "
            "and improve horse–rider harmony."
        )

    anx_min, anx_max = to_trigger_range(legacy.get("anxiety_level"))
    conf_min, conf_max = to_trigger_range(legacy.get("confidence_level"))

    instr_raw = (legacy.get("instructions") or "").strip()
    if instr_raw:
        instructions = [
            "Ensure your horse is in a calm, low-demand context (halt or easy walk).",
            f"Follow this somatic focus: {instr_raw}",
            "Continue for the suggested duration, watching for softening or release in both your body and your horse."
        ]
    else:
        instructions = [
            "Ensure your horse is in a calm, low-demand context (halt or easy walk).",
            "Follow the somatic reset instructions as described in the EquiMind app.",
            "Continue for the suggested duration, watching for softening or release in both your body and your horse."
        ]

    evidence = (legacy.get("evidence_base") or "").strip() or EVIDENCE
    suitable = legacy.get("suitable_for") or SUITABLE_DEFAULT
    duration = legacy.get("duration_minutes") or 4

    return {
        "name": legacy.get("name") or "EquiMind Somatic Reset Tool",
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
    print(f"Converted {len(converted)} somatic reset tools → {OUT_FILE}")

if __name__ == "__main__":
    main()
