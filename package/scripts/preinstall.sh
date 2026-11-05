#!/system/bin/sh
[ "$(getprop ro.product.device)" = wp_daudioplus_nx4hev_kr ] || exit 2
[ "$(cat /proc/sys/kernel/osrelease 2>/dev/null)" = 3.18.24-tcc ] || exit 2
[ -s modules/r8188eu.ko ] || exit 3
grep -a -q NX4D1_20261104 modules/r8188eu.ko || exit 4
exit 0
