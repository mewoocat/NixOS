import QtQuick
import qs.Services as Services

BarButton {
    visible: Services.Networking.networkInterfaces
    icon.name: Services.Networking.getWifiActiveIconName(Services.Networking.currentWifiNetwork)
}
