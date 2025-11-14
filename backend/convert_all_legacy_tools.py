"""
Convert all legacy tools to proper format
"""
import json
from pathlib import Path

BASE = Path("/app/backend/legacy_tools_export")

CATEGORIES_CONFIG = {
    "mindfulness_and_flow": {
        "category": "mindfulness",
        "evidence": "Mindfulness-based stress reduction (MBSR), attentional control training, and equine-assisted mental skills work.",
        "suitable": ["anxiety", "focus", "emotional_awareness"],
        "desc": "On-horse mindfulness exercise to help rider and horse stay present and reduce mental noise."
    },
    "breathing_hrv": {
        "category": "breathing_hrv",
        "evidence": "Heart rate variability (HRV) research, respiratory sinus arrhythmia, autonomic regulation studies, and breathwork for performance.",
        "suitable": ["anxiety", "tension", "hyperarousal"],
        "desc": "Breathing exercise to regulate the nervous system and improve rider-horse connection."
    },
    "somatic_reset": {
        "category": "somatic_reset",
        "evidence": "Somatic experiencing, body-based trauma therapy, polyvagal theory, and rider biomechanics research.",
        "suitable": ["tension", "body_awareness", "freeze_response"],
        "desc": "Body-based technique to release tension and improve physical awareness while mounted."
    },
    "activation_grounding": {
        "category": "activation_grounding",
        "evidence": "Grounding techniques from trauma-informed therapy, activation strategies, and equine-assisted somatic work.",
        "suitable": ["dissociation", "anxiety", "grounding"],
        "desc": "Grounding or activation exercise to help rider connect with present moment and physical sensations."
    },
    "tapping_eft": {
        "category": "tapping",
        "evidence": "Emotional Freedom Techniques (EFT) research, bilateral stimulation from EMDR, and acupressure-based interventions.",
        "suitable": ["anxiety", "panic", "performance_stress"],
        "desc": "EFT tapping technique to reduce emotional activation and support nervous system regulation."
    }
}

def to_trigger_range(levels, default_min=1, default_max=10):
    if isinstance(levels, list) and levels:
        return min(levels), max(levels)
    return default_min, default_max

def convert_tool(legacy, config):
    # Description
    desc = legacy.get("description")
    if not desc or not str(desc).strip():
        desc = config["desc"]

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
            "Follow the focus of this exercise as described in the EquiMind app.",
            "Continue for the suggested duration or several breaths/strides, then return to normal riding and briefly notice what feels different."
        ]

    # Evidence base
    evidence = (legacy.get("evidence_base") or "").strip() or config["evidence"]

    # Suitable_for
    suitable = legacy.get("suitable_for") or config["suitable"]

    # Duration
    duration = legacy.get("duration_minutes") or 5

    # Keep original ID for updating
    return {
        "id": legacy.get("id"),  # Keep original ID
        "name": legacy.get("name") or "EquiMind Tool",
        "category": config["category"],
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
    all_converted = []
    
    for file_key, config in CATEGORIES_CONFIG.items():
        in_file = BASE / f"{file_key}.json"
        out_file = BASE / f"{file_key}_equimind.json"
        
        if not in_file.exists():
            print(f"⚠️  Skipping {file_key} - file not found")
            continue
        
        data = json.loads(in_file.read_text())
        tools = data.get("tools") if isinstance(data, dict) else data
        
        converted = [convert_tool(tool, config) for tool in tools]
        
        # Save individual category file
        out_file.write_text(json.dumps(converted, indent=2))
        print(f"✅ Converted {len(converted)} {file_key} tools → {out_file.name}")
        
        # Add to combined list
        all_converted.extend(converted)
    
    # Save combined file
    combined_file = BASE / "all_legacy_tools_converted.json"
    combined_file.write_text(json.dumps(all_converted, indent=2))
    print(f"\n✅ Combined: {len(all_converted)} total tools → {combined_file.name}")
    
    print(f"\n📊 Summary:")
    print(f"   Total converted: {len(all_converted)} tools")
    print(f"   Ready for database import!")

if __name__ == "__main__":
    main()
