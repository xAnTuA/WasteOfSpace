import os

# paths (adjust if needed)
HEADER = "standards/MODULAR/code/1.0.0/header.luau"
FOOTER = "standards/MODULAR/code/1.0.0/footer.luau"
MODULES_DIR = "models/modules"

def build_modules():
    with open(HEADER, "r", encoding="utf-8") as f:
        header = f.read()
    with open(FOOTER, "r", encoding="utf-8") as f:
        footer = f.read()

    for module_name in os.listdir(MODULES_DIR):
        module_path = os.path.join(MODULES_DIR, module_name, "code")
        if not os.path.isdir(module_path):
            continue

        for file in os.listdir(module_path):
            if not file.endswith(".luau"):
                continue

            version = os.path.splitext(file)[0]  # e.g. "1.0.0"
            version_outdir = os.path.join("builds",MODULES_DIR, module_name)
            os.makedirs(version_outdir, exist_ok=True)

            with open(os.path.join(module_path, file), "r", encoding="utf-8") as f:
                code = f.read()

            combined = "\n".join([header, code, footer])
            out_file = os.path.join(version_outdir, f"{version}.luau")

            with open(out_file, "w", encoding="utf-8") as f:
                f.write(combined)

            print(f"Built {out_file}")

if __name__ == "__main__":
    build_modules()
