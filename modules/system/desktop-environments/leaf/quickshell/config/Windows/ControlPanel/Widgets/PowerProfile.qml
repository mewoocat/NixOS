
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Services as Services
import Quickshell.Services.UPower
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import qs.Components.Controls as Ctrls

AbsGrid.WidgetData { 
    id: widgetData
    name: "Power Profile Selector"
    xSize: 3
    ySize: 1
    showBackground: true
    component: Item {
        id: root
        //ButtonGroup { buttons: row.children } // Non visual item
        RowLayout {
            id: row
            spacing: 0
            anchors.fill: parent
            Ctrls.Button {
                onClicked: () => PowerProfiles.profile = PowerProfile.PowerSaver
                icon.name: "battery-profile-powersave-symbolic"
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: widgetData.radius
                checked: PowerProfiles.profile == PowerProfile.PowerSaver
            }
            Ctrls.Button {
                onClicked: () => PowerProfiles.profile = PowerProfile.Balanced
                icon.name: "battery-profile-balanced-symbolic"
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: widgetData.radius
                checked: PowerProfiles.profile == PowerProfile.Balanced
            }
            Ctrls.Button {
                //visible: PowerProfiles.hasPerformanceProfile
                onClicked: () => PowerProfiles.profile = PowerProfile.Performance
                icon.name: "battery-profile-performance-symbolic"
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: widgetData.radius
                checked: PowerProfiles.profile == PowerProfile.Performance
            }
        }
    }
}
