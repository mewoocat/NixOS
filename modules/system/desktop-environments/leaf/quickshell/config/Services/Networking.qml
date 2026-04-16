pragma Singleton

import Quickshell
import Quickshell.Networking

Singleton {
    property bool isWifiEnabled: Networking.wifiEnabled
    function setWifiEnabled(value: bool) { Networking.wifiEnabled = value }
    property ObjectModel networkInterfaces: Networking.devices
    property WifiDevice wifiInterface: Networking.devices.values.find(d => d.type == DeviceType.Wifi) ?? null
    property WifiNetwork currentWifiNetwork: wifiInterface?.networks.values
        .find(d => d.state != ConnectionState.Disconnected) ?? null

    property string currentWifiIconName: {
        if (!currentWifiNetwork) { return "network-wireless-disconnected-symbolic" }

        let connStr = "limited"
        switch(currentWifiNetwork.state){
            case ConnectionState.Disconnected:
                return "network-wireless-disconnected-symbolic"
            case ConnectionState.Connected:
                connStr = "connected"
                break
            case ConnectionState.Connecting:
            case ConnectionState.Disconnecting:
                connStr = "limited"
                break
            default:
                console.error("Invalid connection state reached for network icon, assuming limited")
        }

        const signal = Math.floor(currentWifiNetwork.signalStrength * 100)
        switch(signal) {
            case signal < 20: 
                return `network-wireless-20-${connStr}`
            case signal < 40:
                return `network-wireless-40-${connStr}`
            case signal < 60:
                return `network-wireless-60-${connStr}`
            case signal < 80:
                return `network-wireless-80-${connStr}`
            default:
                return `network-wireless-100-${connStr}`
        }
    }
}
