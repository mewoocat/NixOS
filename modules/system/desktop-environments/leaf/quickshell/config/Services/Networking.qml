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

    // Helper function for getting the xdg icon for the active wifi network
    function getWifiActiveIconName(wifiNet: WifiNetwork): string {
        if (!wifiNet) { return "network-wireless-disconnected-symbolic" }
        
        let signalStrength = Math.floor(currentWifiNetwork.signalStrength * 100)
        switch(true) {
            case signalStrength < 20: 
                signalStrength = "20"; break
            case signalStrength < 40:
                signalStrength = "40"; break
            case signalStrength < 60:
                signalStrength = "60"; break
            case signalStrength < 80:
                signalStrength = "80"; break
            default:
                signalStrength = "100"
        }
    
        let state
        switch(currentWifiNetwork.state){
            case ConnectionState.Disconnected:
                state = "disconnected"
                break;
            case ConnectionState.Connected:
                state = "connected"
                break
            case ConnectionState.Connecting:
            case ConnectionState.Disconnecting:
                state = "limited"
                break
            default:
                console.error("Invalid connection state reached for network icon, assuming limited")
        }

        const iconName = `network-wireless-${signalStrength}-${state}-symbolic`
        return iconName
    }


    // Helper function for getting the xdg icon name for a wifi access point (that's not currently activated)
    function getWifiAPIconName(wifiNet: WifiNetwork): string {
        if (!wifiNet) {
            console.warn(`WifiNetwork not provided`)
            return "network-wireless-disconnected-symbolic"
        }

        let signalStrength = Math.floor(currentWifiNetwork.signalStrength * 100)
        switch(true) {
            case signalStrength < 20: 
                signalStrength = "20"; break
            case signalStrength < 40:
                signalStrength = "40"; break
            case signalStrength < 60:
                signalStrength = "60"; break
            case signalStrength < 80:
                signalStrength = "80"; break
            default:
                signalStrength = "100"
        }

        let security = wifiNet.security
        switch(security) {
            case WifiSecurityType.Open:
                security = ""; break
            default: 
                security = "-locked";
        }

        const iconName = `network-wireless-${signalStrength}${security}`
        console.log(`getting icon ${iconName}`)
        return iconName
    }
}
