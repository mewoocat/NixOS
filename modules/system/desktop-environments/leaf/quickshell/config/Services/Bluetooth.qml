pragma Singleton

import Quickshell
import Quickshell.Bluetooth
import qs as Root

Singleton {

    property ScriptModel pairedDevices: ScriptModel {
        values: Bluetooth.devices.values
            .filter(device => device.paired)
            .sort((a, b) => { // Sort connected devices first
                if (a.connected && b.connected) return 0
                if (!a.connected && !b.connected) return 0
                if (a.connected && !b.connected) return -1
                if (!a.connected && b.connected) return 1
            })
    }

    property ScriptModel unpariredDevices: ScriptModel {
        values: Bluetooth.devices.values.
            filter(device => !device.paired)
    }

}
