#!/bin/bash
set -e

echo "Setting up USB-C dock display hotplug fix..."

# 1. Hotplug script (runs when dock is plugged in)
tee /usr/local/bin/dock-hotplug.sh > /dev/null << 'SCRIPT'
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
SCRIPT
chmod 755 /usr/local/bin/dock-hotplug.sh
echo "  [✓] Installed /usr/local/bin/dock-hotplug.sh"

# 2. Disconnect script (runs when dock is unplugged — resets TB controller firmware state)
tee /usr/local/bin/dock-disconnect.sh > /dev/null << 'SCRIPT'
#!/bin/bash
logger -t dock-hotplug "dock disconnected, resetting Thunderbolt controller"
sleep 2

# Unbind and rebind the TB controller so firmware reinitialises on next connect
TB_DEV="0000:00:0d.2"
TB_DRIVER="thunderbolt"
if [ -e "/sys/bus/pci/drivers/${TB_DRIVER}/${TB_DEV}" ]; then
    echo "$TB_DEV" > /sys/bus/pci/drivers/${TB_DRIVER}/unbind
    sleep 1
    echo "$TB_DEV" > /sys/bus/pci/drivers/${TB_DRIVER}/bind
    logger -t dock-hotplug "TB controller reset done"
else
    logger -t dock-hotplug "TB device not found at ${TB_DEV}, skipping reset"
fi
SCRIPT
chmod 755 /usr/local/bin/dock-disconnect.sh
echo "  [✓] Installed /usr/local/bin/dock-disconnect.sh"

# 3. udev rules
tee /etc/udev/rules.d/99-dock-hotplug.rules > /dev/null << 'RULE'
# Dock USB ethernet (Realtek RTL8153) connects → trigger display hotplug
ACTION=="add",    SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8153", RUN+="/usr/bin/systemd-run --no-block /usr/local/bin/dock-hotplug.sh"
# Dock USB ethernet disconnects → reset TB controller so next connect negotiates Alt Mode cleanly
ACTION=="remove", SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="0bda", ENV{ID_MODEL_ID}=="8153", RUN+="/usr/bin/systemd-run --no-block /usr/local/bin/dock-disconnect.sh"
RULE
echo "  [✓] Installed /etc/udev/rules.d/99-dock-hotplug.rules"

# 4. Manual recovery script (Mod+F10 keybinding)
tee /usr/local/bin/monitor-recover.sh > /dev/null << 'SCRIPT'
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
SCRIPT
chmod 755 /usr/local/bin/monitor-recover.sh
echo "  [✓] Installed /usr/local/bin/monitor-recover.sh"

printf 'n0m4d ALL=(root) NOPASSWD: /usr/local/bin/monitor-recover.sh\n' > /etc/sudoers.d/monitor-recover
chmod 440 /etc/sudoers.d/monitor-recover
echo "  [✓] Installed /etc/sudoers.d/monitor-recover"

# 5. Reload udev
udevadm control --reload-rules
echo "  [✓] Reloaded udev rules"

echo ""
echo "Done."
echo "Unplug the dock → wait 5 seconds → replug."
echo "Monitor should come up at 4K@30 after ~11 seconds."
echo "Watch progress with: journalctl -f -t dock-hotplug"
