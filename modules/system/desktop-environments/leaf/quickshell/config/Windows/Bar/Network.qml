import QtQuick
import qs.Services as Services

BarButton {
    visible: Networking.devices
    icon.name: Services.Networking.currentWifiIconName
}
