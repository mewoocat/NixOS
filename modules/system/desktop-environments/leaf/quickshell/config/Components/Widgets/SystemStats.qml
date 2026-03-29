pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Services as Services
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared
import qs as Root

// Todo: Somehow calculate the max detail width
ColumnLayout {
    id: root
    anchors.margins: 8
    anchors.fill: parent

    component StatusItem: RowLayout {
        id: status
        required property string iconSource
        required property string text
        required property int value
        RowLayout {
            // Idk why implicitWidth doesn't seem to apply here
            Layout.preferredWidth: icon.width + textMetrics.width
            Shared.Icon {
                id: icon
                recolorIcon: false
                implicitSize: 20
                source: status.iconSource
            }
            Text {
                text: status.text
                color: Root.State.colors.on_surface
            }
            TextMetrics {
                id: textMetrics
                text: " 100 %" // example of max text characters
            }
        }
        Ctrls.ProgressBar {
            Layout.fillWidth: true
            from: 0
            value: status.value
            to: 100
        }
    }

    // CPU
    Shared.ToolTipArea {
        text: Services.SystemStats.cpuToolTipText
        Layout.fillWidth: true
        StatusItem {
            iconSource: Quickshell.iconPath("cpu")
            text: Services.SystemStats.cpuText
            value: Services.SystemStats.cpuUsage
        }
    }

    // Memory
    Shared.ToolTipArea {
        text: Services.SystemStats.memToolTipText
        Layout.fillWidth: true 
        StatusItem {
            iconSource: Quickshell.iconPath("memory")
            text: Services.SystemStats.memText
            value: Services.SystemStats.memUsage
        }
    }

    // Temp
    Shared.ToolTipArea {
        text: Services.SystemStats.tempToolTipText
        Layout.fillWidth: true
        StatusItem {
            iconSource: Quickshell.iconPath("temperature-warm-symbolic")
            text: Services.SystemStats.tempText
            value: Services.SystemStats.cpuTemp
        }
    }

    // Storage usage
    Shared.ToolTipArea {
        text: Services.SystemStats.storageToolTipText
        Layout.fillWidth: true
        StatusItem {
            iconSource: Quickshell.iconPath("drive-harddisk")
            text: Services.SystemStats.storageText
            value: Services.SystemStats.storageUsage
        }
    }
}
