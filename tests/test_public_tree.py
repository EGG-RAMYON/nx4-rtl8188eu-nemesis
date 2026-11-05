#!/usr/bin/env python3
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_MODULE = "0365d9267aa5c1d4c587646bbc354e047f51e9f78424dd4e54e2bbb78e342c02"

# Shell syntax for all package scripts.
for path in sorted((ROOT / "package").rglob("*.sh")):
    subprocess.run(["sh", "-n", str(path)], check=True)
    assert path.stat().st_mode & 0o111, f"script lacks execute bit: {path}"

meta = (ROOT / "package/NEMESIS.data").read_text()
for required in ("version=1.1", "id=nx4.rtl8188eu.manual", "type=service", "package-version=1.0.3"):
    assert required in meta, f"missing metadata: {required}"

# Ensure no vehicle-collected diagnostic/network logs or private-key material is checked in.
for path in ROOT.rglob("*"):
    if not path.is_file() or ".git" in path.parts:
        continue
    assert path.suffix.lower() not in {".ko", ".pcap", ".pcapng", ".pem", ".key"}, f"unexpected binary/private file: {path}"
    assert path.name not in {".config", "Module.symvers", "modules.order"}, f"unexpected build file: {path}"

print("Public source tree and shell syntax: PASS")
print("Release module digest is pinned to:", EXPECTED_MODULE)
