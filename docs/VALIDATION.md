# Validation status

This document separates reported vehicle results from local static checks. A static check is not a vehicle test.

## Reported vehicle results

| Check | Result | Scope |
|---|---|---|
| Module load | Successful | Separate test using `r8188eu.ko` |
| USB adapter recognition | Successful | RTL8188EU, USB ID `0bda:8179` |
| `wlan0` creation and activation | Successful | Separate driver test |
| AP association and DHCP | Successful | Separate driver test |
| External IP traffic and DNS lookup | Successful | Separate driver test |
| Wireless ADB | Successful | Separate driver test |
| Android Auto interaction | Wi-Fi connection succeeded after disabling projection package | Association observed; internal cause and coexistence are unknown |
| NEMESIS v1.0.3 STOP | Original Android Auto state restored | Reported vehicle result |
| NEMESIS v1.0.3 full START | Not confirmed | Requires a dedicated vehicle trial |
| Repeated START/STOP | Not confirmed | Vehicle test required |
| USB adapter unplug/reconnect | Wi-Fi reportedly does not recover until the head unit is restarted | Observed use; cause and package/driver responsibility are not isolated |
| Service/state recovery after reboot | Not confirmed | Separate from the reported Wi-Fi recovery after restarting the head unit |
| Forced termination/power-loss recovery | Not confirmed | Traps cannot handle SIGKILL or power loss |
| Android Auto and Wi-Fi at the same time | Not confirmed | Do not assume coexistence |

## Package provenance

The provided package archive SHA-256 is `0b3d46d7374377075417f8ce9eb22e48645b48559497ca05b47e59d19ef47f08`. Its `modules/r8188eu.ko` SHA-256 is `0365d9267aa5c1d4c587646bbc354e047f51e9f78424dd4e54e2bbb78e342c02`, matching the module asset digest published in driver Release `v0.1.0-nx4d1-candidate`. This establishes byte identity between these two copies. It does not establish byte identity with the module used in the successful live test; no hash recorded at that test is available.

The Release calls this a candidate module, not a verified reproducible build or confirmed live-test binary. Keep that distinction in package and release notes.

## Local checks

CI checks shell syntax, package metadata and archive layout, required files, and SHA-256 consistency. CI does not emulate Android 4.4.2, NEMESIS service management, `pm`, USB sysfs, or the vehicle kernel. It cannot validate module loading, restoration behavior, or network connectivity on the head unit.
