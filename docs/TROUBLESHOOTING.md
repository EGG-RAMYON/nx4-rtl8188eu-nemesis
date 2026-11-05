# Troubleshooting

- **Install is not detected:** Check that the USB root has `NEMESIS.data`, that its relative `path` points to the intact nested package ZIP, and that the USB drive is mounted. The root descriptor and inner package descriptor serve different purposes.
- **Wrong target or kernel:** Stop. Do not bypass the target checks or replace the driver with a module from another kernel.
- **Module does not load:** Check the module SHA-256, target kernel release and module vermagic. A checksum match only identifies the file; it does not prove it was the binary used in the live test.
- **No `wlan0`:** Confirm the adapter is connected and recognized and that the module loaded. Module insertion alone is not evidence of network success.\n- **Wi-Fi does not recover after adapter reconnect:** A user reported that operation returned only after restarting the head unit. The cause and repeatability are unknown; safe automatic hotplug recovery remains a follow-up item.
- **Android Auto remains disabled:** Use `bin/restore.sh` only with the package's saved original state. If `original` is absent or invalid, do not guess.
- **Restoration after interruption:** Shell traps cannot run after SIGKILL, power loss or a system crash. Follow the manual recovery procedure in [SAFETY.md](SAFETY.md).
- **Repeated interface-up attempts:** The inspected v1.0.3 script uses sysfs `operstate` and `carrier`, not the older `ifconfig ... | grep 'UP '` test. It can still retry when the interface remains down; behavior on other systems is untested.
