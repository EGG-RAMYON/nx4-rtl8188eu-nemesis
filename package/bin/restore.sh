#!/system/bin/sh
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
AA=com.google.android.projection.sink
STATE=/data/nemesis/backup/nx4.rtl8188eu.manual
ACTIVE=$STATE/active
LOG=$STATE/control.log
log() { echo "$(date) $*" >> "$LOG"; echo "$*"; }
disabled() { pm list packages -d 2>/dev/null | grep -q "^package:$AA$"; }
check_device() { [ "$(getprop ro.product.device)" = wp_daudioplus_nx4hev_kr ] && [ "$(cat /proc/sys/kernel/osrelease 2>/dev/null)" = 3.18.24-tcc ]; }

if [ ! -d "$STATE" ]; then echo NO_STATE_NO_CHANGE; exit 0; fi
if [ ! -f "$STATE/original" ]; then
  if [ -f "$ACTIVE" ]; then log MISSING_ORIGINAL_STATE; exit 8; fi
  echo NO_ORIGINAL_STATE_NO_CHANGE; exit 0
fi
ORIG=$(cat "$STATE/original" 2>/dev/null)
case "$ORIG" in
  enabled)
    log AA_RESTORE_ENABLE_REQUEST
    pm enable "$AA" >> "$LOG" 2>&1 || { log AA_ENABLE_COMMAND_FAILED; exit 5; }
    if disabled; then log AA_ENABLE_NOT_CONFIRMED; exit 6; fi
    ;;
  disabled)
    if ! disabled; then
      log AA_RESTORE_DISABLE_REQUEST
      pm disable "$AA" >> "$LOG" 2>&1 || { log AA_DISABLE_COMMAND_FAILED; exit 5; }
      disabled || { log AA_DISABLE_NOT_CONFIRMED; exit 6; }
    fi
    ;;
  *) log INVALID_ORIGINAL_STATE; exit 7;;
esac
rm -f "$ACTIVE"
log AA_RESTORED_ORIGINAL_STATE
exit 0
