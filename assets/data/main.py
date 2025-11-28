import json

# Fields to remove
REMOVE_KEYS = [
    "ar1", "ar2", "ar3", "ar4", "ar5",
    "mdesc1", "mdesc2", "mdesc3", "mdesc4", "mdesc5",
    "pos1", "pos2", "pos3", "pos4", "pos5", "lemma", "verb_type", "root_ar"
]

def clean_json(input_file, output_file):
    # Load JSON file
    with open(input_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Remove unwanted fields from every object
    for item in data:
        for key in REMOVE_KEYS:
            if key in item:
                del item[key]

    # Save cleaned JSON
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

    print("✔ Done! Cleaned file saved as:", output_file)

# -----------------------------
# Example usage:
# -----------------------------
clean_json("verses_data.json", "output_cleaned.json")
