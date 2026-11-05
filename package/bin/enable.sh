#!/system/bin/sh
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
AA=com.google.android.projection.sink
STATE=/data/nemesis/backup/nx4.rtl8188eu.manual
ACTIVE=$STATE/active
LOG=$STATE/control.log
log() { echo "$(date) $*" >> "$LOG"; echo "$*"; }
disabled() { pm list packages -d 2>/dev/null | grep -q "^package:$AA$"; }
check_device() { [ "$(getprop ro.product.device)" = wp_daudioplus_nx4hev_kr ] && [ "$(cat /proc/sys/kernel/osrelease 2>/dev/null)" = 3.18.24-tcc ]; }

if ! check_device; then echo WRONG_DEVICE; exit 2; fi
mkdir -p "$STATE" || exit 3
if [ ! -f "$STATE/original" ]; then
  if disabled; then echo disabled > "$STATE/original"; else
    pm path "$AA" 2>/dev/null | grep -q '^package:' || { log AA_PACKAGE_NOT_FOUND; exit 4; }
    echo enabled > "$STATE/original"
  fi
fi
if ! disabled; then
  log AA_DISABLE_REQUEST
  pm disable "$AA" >> "$LOG" 2>&1 || { log AA_DISABLE_COMMAND_FAILED; exit 5; }
fi
if ! disabled; then log AA_DISABLE_NOT_CONFIRMED; exit 6; fi
echo 1 > "$ACTIVE" || exit 7
log MANUAL_WIFI_ENABLED
exit 0
