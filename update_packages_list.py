# made by gpt, for quick. Possible change in future
import os
import json
from packaging import version  # better version parsing

PACKAGES_DIR = "packages"
OUTPUT_FILE = os.path.join(PACKAGES_DIR, "list.json")


def get_versions(package_path):
    """Return list of version strings from subfolders of a package."""
    versions = []
    for name in os.listdir(package_path):
        path = os.path.join(package_path, name)
        if os.path.isdir(path):
            try:
                _ = version.parse(name)
                versions.append(name)
            except Exception:
                pass  # skip folders not matching semver
    return versions


def build_latest_map(versions):
    """Return dict of newest version per major."""
    majors = {}
    for v in versions:
        parsed = version.parse(v)
        if not isinstance(parsed, version.Version):
            continue
        major = parsed.major
        # keep only the newest for this major
        if major not in majors or parsed > version.parse(majors[major]):
            majors[major] = v
    # sort majors ascending
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

        # keep only version strings, drop keys (majors)
        packages_list[pkg] = list(latest_map.values())

    # save JSON
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(packages_list, f, indent=4)

    print(f"✅ Wrote package list to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
