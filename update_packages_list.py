import os
import json

PACKAGES_DIR = "packages"
OUTPUT_FILE = os.path.join(PACKAGES_DIR, "list.json")


def parse_version(v):
    """Parse '1.2.3' -> (1, 2, 3). Non-numeric gets ignored."""
    try:
        parts = v.split(".")
        return tuple(int(p) for p in parts)
    except ValueError:
        return None


def get_versions(package_path):
    """Return list of version strings from subfolders of a package."""
    versions = []
    for name in os.listdir(package_path):
        path = os.path.join(package_path, name)
        if os.path.isdir(path):
            if parse_version(name) is not None:
                versions.append(name)
    return versions


def build_latest_map(versions):
    """Return newest version per major."""
    majors = {}
    for v in versions:
        parsed = parse_version(v)
        if not parsed:
            continue
        major = parsed[0]
        # keep only the newest for this major
        if major not in majors or parsed > parse_version(majors[major]):
            majors[major] = v
    # return sorted by major
    return dict(sorted(majors.items()))


def main():
    packages_list = {}

    for pkg in os.listdir(PACKAGES_DIR):
        package_path = os.path.join(PACKAGES_DIR, pkg)
        if not os.path.isdir(package_path) or pkg == "node_modules":
            continue

        versions = get_versions(package_path)
        if not versions:
            continue

        latest_map = build_latest_map(versions)
        packages_list[pkg] = list(latest_map.values())

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(packages_list, f, indent=4)

    print(f"✅ Wrote package list to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()

