# Safety and privacy

This package changes Android Auto projection package state and loads a kernel module as root. Use only with the documented target configuration and a recovery method available.

The service stores the initial enabled/disabled projection state. Restore only from that saved value. If it is absent or invalid, do not automatically enable or disable the package.

A shell EXIT or handled-signal trap can attempt restoration. SIGKILL, sudden power loss and system crashes bypass it. If service shutdown is abnormal, inspect the saved state and run the package restore helper before uninstalling. The existing helper is not a substitute for a backup of important head-unit data.

Do not publish VIN, per-unit serial numbers, MAC/IP addresses, SSIDs, passwords, ADB keys, certificates, raw vehicle logs, firmware files, kernel configurations, or vehicle system images. Platform-level model, kernel, and USB product identifiers in this repository identify the tested configuration, not an individual vehicle.

The head unit has one USB port. Remove the install drive before attaching the Wi-Fi adapter. Android Auto and Wi-Fi simultaneous operation is not validated.
