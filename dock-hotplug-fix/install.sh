#!/bin/bash
# Installs the USB-C dock / external monitor hotplug workaround.
# Run as root (or via sudo) from within this directory.
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Run this with sudo." >&2
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_USER="${SUDO_USER:-n0m4d}"

install -m 755 "$DIR/bin/dock-hotplug.sh"    /usr/local/bin/dock-hotplug.sh
install -m 755 "$DIR/bin/dock-disconnect.sh" /usr/local/bin/dock-disconnect.sh
install -m 755 "$DIR/bin/monitor-recover.sh" /usr/local/bin/monitor-recover.sh
echo "[✓] Installed scripts to /usr/local/bin"

install -m 644 "$DIR/udev/99-dock-hotplug.rules" /etc/udev/rules.d/99-dock-hotplug.rules
udevadm control --reload-rules
echo "[✓] Installed udev rule and reloaded udev"

install -m 440 "$DIR/sudoers.d/monitor-recover" /etc/sudoers.d/monitor-recover
visudo -cf /etc/sudoers.d/monitor-recover
echo "[✓] Installed sudoers rule for $TARGET_USER"

echo ""
echo "Manual steps still required:"
echo "  1. Add the keybindings in niri/binds-snippet.kdl to your niri config."
echo "  2. Copy systemd/swayidle.service to ~/.config/systemd/user/ if you want"
echo "     the suspend/resume mitigation (gates auto-suspend on DP-1 being"
echo "     disconnected), then: systemctl --user daemon-reload && systemctl --user restart swayidle"
echo "  3. See README.md for the full explanation and usage."
