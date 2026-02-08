import QtQuick
import Quickshell.Networking

BarButton {
    property WifiDevice nic: Networking.devices.values.find(device => device.type === DeviceType.Wifi)
    property WifiNetwork currentNet: nic.networks.values.find(network => network.connected == true) ?? null
    iconSize: 24
    //text: `sig ${currentNet.signalStrength}`
    iconName: {
        if (!currentNet) { return `` } // Todo: find a fallback
        const signal = Math.floor(currentNet.signalStrength * 100)
        if (signal < 20) { return `network-wireless-connected-0` } else
        if (signal < 40) { return `network-wireless-connected-25` } else
        if (signal < 60) { return `network-wireless-connected-50` } else
        if (signal < 80) { return `network-wireless-connected-75` } else
        if (signal < 100) { return `network-wireless-connected-100` }
    }
}
