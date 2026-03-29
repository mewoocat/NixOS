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

    component Details: RowLayout {
        id: details
        // Idk why implicitWidth doesn't seem to apply here
        Layout.preferredWidth: icon.width + textMetrics.width
        required property string iconSource
        required property string text
        Shared.Icon {
            id: icon
            implicitSize: 20
            source: details.iconSource
        }
        Text {
            text: details.text
            color: Root.State.colors.on_surface
        }
        TextMetrics {
            id: textMetrics
            text: "aaaaa" // 5 char, example of max text characters
        }
    }

    // CPU
    Shared.ToolTipArea {
        text: Services.SystemStats.cpuToolTipText
        Layout.fillWidth: true
        RowLayout {
            Details {
                iconSource: Quickshell.iconPath("cpu")
                text: Math.round(Services.SystemStats.cpuUsage) + '%'
            }
            Ctrls.ProgressBar {
                Layout.fillWidth: true
                from: 0
                value: Services.SystemStats.cpuUsage
                to: 100
            }
        }
    }

    // Memory
    Shared.ToolTipArea {
        text: Services.SystemStats.memToolTipText
        Layout.fillWidth: true 
        RowLayout {
            Details {
                iconSource: Quickshell.iconPath("memory")
                text: Services.SystemStats.memText
            }
            Ctrls.ProgressBar {
                Layout.fillWidth: true
                from: 0
                value: Services.SystemStats.memUsage
                to: 100
            }
        }
    }

    // Temp
    Shared.ToolTipArea {
        text: Services.SystemStats.tempToolTipText
        Layout.fillWidth: true
        RowLayout {
            Details {
                iconSource: Quickshell.iconPath("temperature-warm-symbolic")
                text: Math.round(Services.SystemStats.cpuTemp) + '°C'
            }
            Ctrls.ProgressBar {
                Layout.fillWidth: true
                from: 0
                value: Services.SystemStats.cpuTemp
                to: 100
            }
        }
    }

    // Storage usage
    Shared.ToolTipArea {
        text: Services.SystemStats.storageToolTipText
        Layout.fillWidth: true
        RowLayout {
            Details {
                iconSource: Quickshell.iconPath("drive-harddisk")
                text: Services.SystemStats.storageText
            }
            Ctrls.ProgressBar {
                Layout.fillWidth: true
                from: 0
                value: Services.SystemStats.storageUsage
                to: 100
            }
        }
    }
}
