"""Build the OJS plugin archive from runtime files only."""

from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile


ROOT = Path(__file__).resolve().parents[1]
DESTINATION = ROOT / "dist" / "spupLightExplorerTheme-v1.0.0.zip"
SINGLE_FILES = (
    "index.php",
    "SpupLightExplorerThemePlugin.inc.php",
    "version.xml",
    "LICENSE",
    "README.md",
    "resources/app.min.css",
    "resources/app.min.js",
    "resources/ionicons.js",
    "resources/root-reset.css",
)
DIRECTORIES = ("fonts", "less", "locale", "templates")


def main() -> None:
    paths = [ROOT / name for name in SINGLE_FILES]
    for directory in DIRECTORIES:
        paths.extend(path for path in (ROOT / directory).rglob("*") if path.is_file())
    paths = sorted(paths, key=lambda path: path.relative_to(ROOT).as_posix())
    for path in paths:
        if not path.is_file() or path.is_symlink():
            raise RuntimeError(f"Missing or unsafe package member: {path}")

    DESTINATION.parent.mkdir(exist_ok=True)
    with ZipFile(DESTINATION, "w", compression=ZIP_DEFLATED, compresslevel=9) as archive:
        for path in paths:
            archive.write(path, "spupLightExplorerTheme/" + path.relative_to(ROOT).as_posix())

    with ZipFile(DESTINATION) as archive:
        failure = archive.testzip()
        if failure:
            raise RuntimeError(f"Corrupt archive member: {failure}")
        members = archive.namelist()
        if any(not member.startswith("spupLightExplorerTheme/") for member in members):
            raise RuntimeError("Archive has an unexpected top-level path")
        if any(member.startswith("spupLightExplorerTheme/spupLightExplorerTheme/") for member in members):
            raise RuntimeError("Archive has a duplicate plugin folder")
    print(f"{DESTINATION} | {len(paths)} files | {DESTINATION.stat().st_size} bytes")


if __name__ == "__main__":
    main()
