# NX4 RTL8188EU Manual WiFi NEMESIS v1.0.3

## Assets

- `nx4.rtl8188eu.manual_v1.0.3.zip` — NEMESIS package archive.
- `NX4_RTL8188EU_NEMESIS_v1.0.3_USB.zip` — USB root bundle with install descriptor and the package ZIP under `packages/`.
- `SHA256SUMS` — checksums for both ZIP files.

## Install

Extract the USB bundle to the root of a FAT32 or exFAT USB drive. Do not extract the nested package ZIP. Install through the NEMESIS prompt. Remove the installation USB drive before connecting the Wi-Fi adapter; the head unit has one USB port.

## Validation

Separate driver testing reported module load, adapter recognition, `wlan0` activation, AP connection, DHCP, external IP traffic, DNS lookup, and wireless ADB success. For NEMESIS v1.0.3, STOP restoring the original Android Auto projection state was reported successful.

The package's complete START path, repeat START/STOP, unplug/reconnect, reboot recovery, forced termination recovery, and Android Auto/Wi-Fi simultaneous use have not been confirmed. Disabling Android Auto preceded successful Wi-Fi connection; the internal cause of the interaction is unknown.

The module SHA-256 is pinned to `0365d9267aa5c1d4c587646bbc354e047f51e9f78424dd4e54e2bbb78e342c02`, matching the module asset in driver Release `v0.1.0-nx4d1-candidate`. This does not prove it is byte-identical to the module used in the successful live test.

## Source and licensing

Service source and package metadata are in the repository and licensed GPL-2.0-only. The RTL8188EU module's source and build documentation are maintained in [nx4-rtl8188eu-kmod](https://github.com/EGG-RAMYON/nx4-rtl8188eu-kmod). The module is a candidate binary; do not describe it as a reproducible build or the confirmed live-test binary.
