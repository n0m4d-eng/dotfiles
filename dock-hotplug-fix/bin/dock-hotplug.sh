#!/bin/bash
logger -t dock-hotplug "dock connected, waiting for Alt Mode"
sleep 4

# Force i915 to re-detect DP connectors
for connector in /sys/class/drm/card1-DP-*/status; do
    echo detect > "$connector" 2>/dev/null
done
udevadm trigger --action=change /sys/class/drm/card1

sleep 4

NIRI_SOCKET=$(ls /run/user/1000/niri.*.sock 2>/dev/null | head -1)
if [ -z "$NIRI_SOCKET" ]; then
    logger -t dock-hotplug "no niri socket found"
    exit 0
fi

logger -t dock-hotplug "training DP link at 1080p"
NIRI_SOCKET="$NIRI_SOCKET" runuser -u n0m4d -- niri msg output DP-1 mode 1920x1080@60

sleep 3

logger -t dock-hotplug "stepping up to 4K@30"
NIRI_SOCKET="$NIRI_SOCKET" runuser -u n0m4d -- niri msg output DP-1 mode 3840x2160@30
logger -t dock-hotplug "done"
