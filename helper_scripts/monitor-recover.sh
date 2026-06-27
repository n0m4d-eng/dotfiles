#!/bin/bash
NIRI_SOCKET=$(ls /run/user/1000/niri.*.sock 2>/dev/null | head -1)
if [ -z "$NIRI_SOCKET" ]; then
    logger -t monitor-recover "no niri socket found"
    exit 1
fi

niri_msg() { env NIRI_SOCKET="$NIRI_SOCKET" runuser -u n0m4d -- niri msg "$@"; }

logger -t monitor-recover "disabling DP-1"
niri_msg output DP-1 off

sleep 1

logger -t monitor-recover "re-detecting DP connectors"
for connector in /sys/class/drm/card1-DP-*/status; do
    echo detect > "$connector" 2>/dev/null
done
udevadm trigger --action=change /sys/class/drm/card1

sleep 2

logger -t monitor-recover "enabling DP-1"
niri_msg output DP-1 on
logger -t monitor-recover "done"
