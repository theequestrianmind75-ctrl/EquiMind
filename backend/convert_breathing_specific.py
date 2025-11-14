import json
from pathlib import Path

BASE = Path("/app/backend/legacy_tools_export")

IN_FILE = BASE / "breathing_hrv.json"
OUT_FILE = BASE / "breathing_hrv_equimind.json"

CATEGORY = "breathing_hrv"

EVIDENCE = (
    "Heart-rate variability (HRV) biofeedback, breathwork research, "
    "and sports performance breathing protocols."
)

SUITABLE_DEFAULT = ["anxiety", "panic", "high_arousal", "focus"]

def to_trigger_range(levels, default_min=1, default_max=10):
    if isinstance(levels, list) and levels:
        return min(levels), max(levels)
    return default_min, default_max

def convert_tool(legacy):
    desc = legacy.get("description")
    if not desc or not str(desc).strip():
        desc = (
            "Breathing and HRV regulation exercise to calm the rider's nervous system "
            "and support steady focus."
        )

    anx_min, anx_max = to_trigger_range(legacy.get("anxiety_level"))
    conf_min, conf_max = to_trigger_range(legacy.get("confidence_level"))

    instr_raw = (legacy.get("instructions") or "").strip()
    if instr_raw:
        instructions = [
            "Place your horse and yourself in a safe, low-demand context (halt or easy walk) before starting this tool.",
            f"Follow this breathing focus: {instr_raw}",
            "Continue for the suggested duration or several breath cycles, then return to normal riding and notice any shift in your body and your horse."
        ]
    else:
        instructions = [
            "Place your horse and yourself in a safe, low-demand context (halt or easy walk) before starting this tool.",
            "Follow the breathing pattern described in the EquiMind app.",
            "Continue for the suggested duration or several breath cycles, then return to normal riding and notice any shift in your body and your horse."
        ]

    evidence = (legacy.get("evidence_base") or "").strip() or EVIDENCE
    suitable = legacy.get("suitable_for") or SUITABLE_DEFAULT
    duration = legacy.get("duration_minutes") or 3

    return {
        "name": legacy.get("name") or "EquiMind Breathing / HRV Tool",
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
    print(f"Converted {len(converted)} breathing/HRV tools → {OUT_FILE}")

if __name__ == "__main__":
    main()
