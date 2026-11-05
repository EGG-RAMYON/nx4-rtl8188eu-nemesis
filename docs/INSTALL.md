# Installation

## Prepare the USB drive

1. Download the USB installer bundle from the Release and extract the bundle to the root of a FAT32 or exFAT USB drive.
2. Confirm the root contains `NEMESIS.data` and the `packages/` directory. Keep `packages/nx4.rtl8188eu.manual_v1.0.3.zip` intact; do not extract it.
3. The root descriptor is:

```ini
[nemesis]
version=1.0
type=install
path=packages/nx4.rtl8188eu.manual_v1.0.3.zip
```

The package ZIP has a different root-level `NEMESIS.data` plus `modules/`, `svc/`, `scripts/`, and `bin/` paths. Do not confuse the USB descriptor with the package descriptor.

## Install

1. Insert the USB drive and use the NEMESIS installation prompt.
2. Wait for installation to complete.
3. Remove the installation USB drive before attaching the Wi-Fi adapter. The head unit has one USB port.
4. Start the registered service in NEMESIS Manager or with the CLI.

The USB `type=install` plus relative `path` format follows the NEMESIS v1.16 package and run-script documentation. Do not use a package built for a different driver or kernel.
