> **Language:** [한국어 (기본)](README.md) · English

# NX4 RTL8188EU Manual WiFi for NEMESIS

An experimental NEMESIS service package for Hyundai Tucson NX4 HEV Gen5W head units using a Realtek RTL8188EU USB Wi-Fi adapter. It coordinates Wi-Fi module startup with the Android Auto projection package state.

**Project background:** Many Korean-market 5W head units do not include a built-in WLAN module. This project began to add wireless networking through a USB WLAN adapter.

This repository contains the NEMESIS package scripts and packaging tools. It is **not** the kernel driver source repository. Driver source and build notes are maintained in [`nx4-rtl8188eu-kmod`](https://github.com/EGG-RAMYON/nx4-rtl8188eu-kmod). The upstream NEMESIS project is [`xwtk/hmg_nemesis`](https://github.com/xwtk/hmg_nemesis).

## Compatibility target

- Vehicle family: Hyundai Tucson NX4 HEV, Gen5W
- Head unit: Hyundai Mobis AVNT STD G50 WIDE R6
- Android: 4.4.2; kernel: `3.18.24-tcc`; ARMv7
- Device property checked by the package: `wp_daudioplus_nx4hev_kr`
- NEMESIS: 1.16.7
- Adapter tested: ipTIME N150L, RTL8188EU, USB ID `0bda:8179`
- Driver module: `r8188eu.ko`; diagnostic marker: `NX4D1_20261104`

These values identify the target platform/build and adapter model; they are not identifiers for an individual vehicle. Compatibility outside the tested configuration is not claimed.

## Package behavior

The service checks the product device property and kernel release, stores the initial enabled/disabled state of `com.google.android.projection.sink`, requests that package be disabled while the Wi-Fi service is active, loads `r8188eu.ko` with its diagnostic parameter, verifies the module marker and USB ID, waits for `wlan0`, and attempts to bring the interface up. The service does not configure an AP, credentials, DHCP, DNS, or routing.

On normal stop or handled termination signals, the service's EXIT trap calls `bin/restore.sh`. The helper restores only the saved original Android Auto state and clears the active marker after a confirmed restore. Missing or invalid original-state data causes no guessed enable/disable action.

## Validation status

Reported separate vehicle testing succeeded for module load, adapter recognition, `wlan0` creation/activation, AP association, DHCP, external IP traffic, DNS lookup, and wireless ADB. Wi-Fi success was observed after disabling Android Auto projection; the internal cause of the interaction is not established.

For package v1.0.3, STOP restoring the original Android Auto state was confirmed. A user also reported that Wi-Fi does not recover after unplugging and reconnecting the adapter, but works again after restarting the head unit. The cause and whether this is in the service or driver have not been isolated. Full service START, repeated START/STOP, service-state recovery after reboot, forced termination recovery, and simultaneous Android Auto/Wi-Fi remain unconfirmed. See [VALIDATION.md](docs/VALIDATION.md).

## Follow-up: Android Auto and USB WLAN coexistence

At START, the current service disables the Android Auto projection package (`com.google.android.projection.sink`) so it can use the USB Wi-Fi adapter. Android Auto therefore cannot be used through this package while the service is running. Vehicle testing reported that Wi-Fi connected after the projection package was disabled, but the internal cause of the conflict has not been established, and simultaneous operation has not been validated.

To meet the project's goal of adding WLAN capability to Korean-market 5W head units, a follow-up maintainer task is to investigate and revise the service's conflict handling and resource coordination so Android Auto and the USB WLAN adapter can work together.

### USB adapter reconnection recovery

A user also reported that operation does not resume after unplugging and reconnecting the adapter, but returns after restarting the head unit. The cause and reproduction conditions have not been isolated or validated. Investigate and update the service or driver to detect USB reconnection and recover safely.

## Install

Download the USB installer bundle from the GitHub Release, extract its contents to the **root** of a FAT32 or exFAT USB drive, and keep the nested package ZIP intact. The USB root descriptor points to `packages/nx4.rtl8188eu.manual_v1.0.3.zip`; that package ZIP has its own root `NEMESIS.data` and package files. NEMESIS uses the descriptor's `type=install` and relative `path` to install the package.

The head unit has one USB port. Remove the installation drive before connecting the Wi-Fi adapter. See [INSTALL.md](docs/INSTALL.md). Maintainer packaging steps are in [BUILD.md](docs/BUILD.md).

## Start, stop, uninstall

Use NEMESIS Manager or its CLI:

```sh
/system/xbin/nemesis service start nx4.rtl8188eu.manual/wifi-loader
/system/xbin/nemesis service stop nx4.rtl8188eu.manual/wifi-loader
/system/xbin/nemesis uninstall nx4.rtl8188eu.manual
```

Verify commands against the NEMESIS version installed on the head unit. Do not manually change Android Auto's enabled state while the service is active. See [OPERATION.md](docs/OPERATION.md).

## Recovery and known limits

A shell trap cannot run after SIGKILL, power loss, or a system crash. If the head unit stops unexpectedly while the service is active, use the reviewed restore helper with its saved state before uninstalling. Do not infer the original Android Auto state from current state alone. Android Auto and Wi-Fi simultaneous use is not validated. See [SAFETY.md](docs/SAFETY.md) and [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## Source and license

The service scripts and package metadata in this repository are licensed under GPL-2.0-only; see [LICENSE](LICENSE) and [NOTICE.md](NOTICE.md). The RTL8188EU module is distributed as a Release asset and is separately licensed; its source and build records are in the driver repository. NEMESIS is a separate upstream project under AGPL-3.0; no upstream implementation code is copied into this repository.

## 한국어 안내

한국어 설명은 [README.ko.md](README.ko.md)를 참조하세요.
