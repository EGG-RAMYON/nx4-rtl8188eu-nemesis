#!/usr/bin/env python3
"""Scan source trees and ZIP contents for accidental private data."""
from __future__ import annotations

import io
import re
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FORBIDDEN_NAMES = {".config", "Module.symvers", "modules.order", "known_hosts"}
FORBIDDEN_SUFFIXES = {".pcap", ".pcapng", ".pem", ".key"}
FORBIDDEN_PARTS = {"vehicle-data", "private", "diagnostics", "raw-logs"}
PATTERNS = {
    "IPv4 address": re.compile(rb"(?<![\w.])(?:25[0-5]|2[0-4]\d|1?\d?\d)(?:\.(?:25[0-5]|2[0-4]\d|1?\d?\d)){3}(?![\w.])"),
    "MAC address": re.compile(rb"(?i)(?<![0-9a-f])(?:[0-9a-f]{2}[:-]){5}[0-9a-f]{2}(?![0-9a-f])"),
    # VINs are standalone 17-character tokens with several digits; underscores are word characters.
    "VIN-like identifier": re.compile(rb"(?<![A-Z0-9_])[A-HJ-NPR-Z0-9]{17}(?![A-Z0-9_])"),
    "credential assignment": re.compile(rb"(?i)\b(?:password|passwd|ssid|secret)[ \t]*=[ \t]*(?!%[a-z]\b|<|\$)[^\s,;]{8,}"),
    "Windows user path": re.compile(rb"(?i)[A-Z]:\\Users\\[^\\\s]+"),
    "Unix home path": re.compile(rb"(?<![\w])/(?:home|Users)/[^/\s]+"),
}

errors: list[str] = []

def printable_strings(data: bytes) -> bytes:
    return b"\n".join(re.findall(rb"[ -~]{4,}", data))

def inspect(name: str, data: bytes, *, archive_member: bool = False) -> None:
    path = Path(name)
    forbidden_suffixes = FORBIDDEN_SUFFIXES | (set() if archive_member else {".ko"})
    if path.name in FORBIDDEN_NAMES or path.suffix.lower() in forbidden_suffixes:
        errors.append(f"forbidden file type/name: {name}")
    if any(part.lower() in FORBIDDEN_PARTS for part in path.parts):
        errors.append(f"forbidden path component: {name}")
    scan_data = data
    try:
        data.decode("utf-8")
    except UnicodeDecodeError:
        scan_data = printable_strings(data)
    for label, pattern in PATTERNS.items():
        match = pattern.search(scan_data)
        if not match:
            continue
        if label == "VIN-like identifier" and sum(byte in b"0123456789" for byte in match.group()) < 4:
            continue
        errors.append(f"possible {label} in {name}")
    try:
        with zipfile.ZipFile(io.BytesIO(data)) as archive:
            for member in archive.infolist():
                if member.is_dir():
                    continue
                inspect(f"{name}::{member.filename}", archive.read(member), archive_member=True)
    except zipfile.BadZipFile:
        pass

def scan_path(path: Path) -> None:
    if path.is_dir():
        for child in path.rglob("*"):
            if child.is_file() and ".git" not in child.parts:
                inspect(child.relative_to(path).as_posix(), child.read_bytes())
    elif path.is_file():
        inspect(path.name, path.read_bytes())
    else:
        errors.append(f"path does not exist: {path}")

paths = [Path(arg) for arg in sys.argv[1:]] or [ROOT]
for item in paths:
    scan_path(item.resolve())
if errors:
    for error in errors:
        print(error, file=sys.stderr)
    sys.exit(1)
print("Privacy scan passed.")
