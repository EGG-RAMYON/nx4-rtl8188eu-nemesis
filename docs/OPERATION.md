# Service operation

The package registers `nx4.rtl8188eu.manual/wifi-loader` in restart mode.

```sh
/system/xbin/nemesis service start nx4.rtl8188eu.manual/wifi-loader
/system/xbin/nemesis service status nx4.rtl8188eu.manual/wifi-loader
/system/xbin/nemesis service stop nx4.rtl8188eu.manual/wifi-loader
/system/xbin/nemesis uninstall nx4.rtl8188eu.manual
```

On START, `bin/enable.sh` stores the original projection-package state and requests disablement. The service then checks the running target, loads the module if not already present, checks the diagnostic marker, waits for `wlan0`, confirms the configured USB VID:PID through sysfs, and tries `ifconfig wlan0 up` if sysfs does not report the interface up.

On STOP, the EXIT trap calls `bin/restore.sh`. The helper restores the saved enabled/disabled value and clears `active` after successful confirmation. `original` and `control.log` remain under `/data/nemesis/backup/nx4.rtl8188eu.manual/` for future lifecycle tracking.

Do not manually enable or disable Android Auto while this service is active. The original state file is written directly rather than atomically; abrupt power loss during that write could leave a partial file. If its contents are missing or invalid, do not guess the desired state.
