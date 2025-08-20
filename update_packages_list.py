import os
import json

PACKAGES_DIR = "packages"
OUTPUT_FILE = os.path.join(PACKAGES_DIR, "list.json")

# If you're in a single-package repo and want a mapping {name: [versions]},
# set this. If left as None, list.json will be a plain list ["1.0.0", ...]
SINGLE_PACKAGE_NAME = None  # e.g. "collection"

def parse_version(v):
    """Parse '1.2.3' -> (1,2,3). Non-numeric or wrong shape -> None."""
    parts = v.split(".")
    try:
        return tuple(int(p) for p in parts)
    except ValueError:
        return None

def is_version_name(name):
    return parse_version(name) is not None

def find_versions_in_package_dir(package_path):
    """
    Accepts any of:
      - subdir '1.2.3' containing 'index.luau' or '1.2.3.luau'
      - file  '1.2.3.luau' directly under package_path
    Returns list of version strings.
    """
    versions = set()

    # version as file: packages/<pkg>/<version>.luau
    for entry in os.listdir(package_path):
        base, ext = os.path.splitext(entry)
        if ext.lower() == ".luau" and is_version_name(base):
            versions.add(base)

    # version as dir: packages/<pkg>/<version>/(index.luau | <version>.luau)
    for entry in os.listdir(package_path):
        ver_dir = os.path.join(package_path, entry)
        if os.path.isdir(ver_dir) and is_version_name(entry):
            v = entry
            has_index = os.path.isfile(os.path.join(ver_dir, "index.luau"))
            has_named = os.path.isfile(os.path.join(ver_dir, f"{v}.luau"))
            if has_index or has_named:
                versions.add(v)

    return sorted(versions, key=parse_version)

def find_versions_single_package(packages_dir):
    """
    Single-package layout:
      - packages/<version>.luau
      - OR packages/<version>/<version>.luau
    """
    versions = set()

    # files directly under packages: <version>.luau
    for entry in os.listdir(packages_dir):
        base, ext = os.path.splitext(entry)
        if ext.lower() == ".luau" and is_version_name(base):
            versions.add(base)

    # subdirs under packages: <version>/<version>.luau
    for entry in os.listdir(packages_dir):
        ver_dir = os.path.join(packages_dir, entry)
        if os.path.isdir(ver_dir) and is_version_name(entry):
            v = entry
            if os.path.isfile(os.path.join(ver_dir, f"{v}.luau")):
                versions.add(v)

    return sorted(versions, key=parse_version)

def build_latest_per_major(versions):
    """Return newest version per major as an ordered list (by major)."""
    latest = {}
    for v in versions:
        parsed = parse_version(v)
        if not parsed:
            continue
        major = parsed[0]
        if major not in latest or parsed > parse_version(latest[major]):
            latest[major] = v
    return [latest[m] for m in sorted(latest.keys())]

def main():
    items = [d for d in os.listdir(PACKAGES_DIR) if d != "node_modules"]
    # Heuristic: if any non-version-named subdirectory exists, assume multi-package
    multi_package = any(
        os.path.isdir(os.path.join(PACKAGES_DIR, d)) and not is_version_name(d)
        for d in items
    )

    if multi_package:
        # packages/<pkg>/...
        packages_list = {}
        for pkg in items:
            pkg_path = os.path.join(PACKAGES_DIR, pkg)
            if not os.path.isdir(pkg_path) or pkg == "node_modules":
                continue
            versions = find_versions_in_package_dir(pkg_path)
            if not versions:
                continue
            packages_list[pkg] = build_latest_per_major(versions)
        to_write = packages_list
    else:
        # single-package layout under packages/
        versions = find_versions_single_package(PACKAGES_DIR)
        latest = build_latest_per_major(versions)
        if SINGLE_PACKAGE_NAME:
            to_write = {SINGLE_PACKAGE_NAME: latest}
        else:
            to_write = latest  # plain list

    os.makedirs(PACKAGES_DIR, exist_ok=True)
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(to_write, f, indent=4)
    print(f"✅ Wrote package list to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()

