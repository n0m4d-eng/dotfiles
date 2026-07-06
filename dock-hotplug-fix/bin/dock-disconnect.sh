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
