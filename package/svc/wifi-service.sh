#!/system/bin/sh
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
AA=com.google.android.projection.sink
STATE=/data/nemesis/backup/nx4.rtl8188eu.manual
ACTIVE=$STATE/active
LOG=$STATE/control.log
log() { echo "$(date) $*" >> "$LOG"; echo "$*"; }
disabled() { pm list packages -d 2>/dev/null | grep -q "^package:$AA$"; }
check_device() { [ "$(getprop ro.product.device)" = wp_daudioplus_nx4hev_kr ] && [ "$(cat /proc/sys/kernel/osrelease 2>/dev/null)" = 3.18.24-tcc ]; }

APP=/data/nemesis/apps/nx4.rtl8188eu.manual
MOD=$APP/modules/r8188eu.ko
mkdir -p "$STATE" || exit 3
log SERVICE_STARTED
# Best effort only: SIGKILL or abrupt power loss cannot run traps.
cleanup() {
  trap - 0 1 2 15
  log SERVICE_STOP_CLEANUP
  /system/bin/sh "$APP/bin/restore.sh"
}
trap 'exit 0' 1 2 15
trap 'cleanup' 0
check_device || { log WRONG_DEVICE; exit 2; }
[ -s "$MOD" ] || { log MODULE_MISSING; exit 2; }
# START owns AA disable + activation, no separate USB/ADB command.
/system/bin/sh "$APP/bin/enable.sh" || { log AA_ENABLE_WIFI_FAILED; exit 3; }
while :; do
  if [ ! -f "$ACTIVE" ] || ! disabled; then
    sleep 10
    continue
  fi
  if ! grep -q '^r8188eu ' /proc/modules; then
    log INSMOD_START
    insmod "$MOD" nx4_diag=1 >> "$LOG" 2>&1
    RC=$?
    log "INSMOD_RC=$RC"
    if [ "$RC" -ne 0 ]; then sleep 20; continue; fi
  fi
  MARKER=$(cat /sys/module/r8188eu/parameters/nx4_diag_id 2>/dev/null)
  if [ "$MARKER" != NX4D1_20261104 ]; then
    log WRONG_LOADED_MODULE_MARKER
    sleep 20
    continue
  fi
  if [ ! -d /sys/class/net/wlan0 ]; then sleep 5; continue; fi
  # Check device identity without assuming the interface symlink depth.
  P=$(cd -P /sys/class/net/wlan0/device 2>/dev/null && pwd)
  MATCH=0
  while [ -n "$P" ] && [ "$P" != / ]; do
    if [ -f "$P/idVendor" ] && [ -f "$P/idProduct" ]; then
      VID=$(cat "$P/idVendor" 2>/dev/null)
      PID=$(cat "$P/idProduct" 2>/dev/null)
      [ "$VID:$PID" = 0bda:8179 ] && MATCH=1
      break
    fi
    P=${P%/*}
  done
  if [ "$MATCH" -ne 1 ]; then log WLAN0_USB_ID_NOT_VERIFIED; sleep 15; continue; fi
  # Reattempt if the interface remains DOWN; no AP or DHCP configuration.
  if [ "$(cat /sys/class/net/wlan0/operstate 2>/dev/null)" = up ] || [ "$(cat /sys/class/net/wlan0/carrier 2>/dev/null)" = 1 ]; then
    sleep 10
    continue
  fi
  log WLAN_UP_ATTEMPT
  ifconfig wlan0 up >> "$LOG" 2>&1
  RC=$?
  log "WLAN_UP_RC=$RC"
  sleep 10
done
