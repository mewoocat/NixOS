import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "root:/Services" as Services
import "root:/Modules/Common" as Common

ColumnLayout {
    anchors.margins: 8
    anchors.fill: parent

    // CPU
    Common.ToolTipArea {
        //text: Services.SystemStats.cpuUsageText // Text for tooltip
        text: "Cpu usage"
        Layout.fillWidth: true
        RowLayout {
            IconImage {
                implicitSize: 20
                source: Quickshell.iconPath("cpu")
            }
            Text {
                text: {
                    Math.round(Services.SystemStats.cpuUsage) + '%'
                }
                color: palette.text
            }
            ProgressBar {
                Layout.fillWidth: true
                from: 0
                value: Services.SystemStats.cpuUsage
                to: 100
            }
        }
    }

    // Memory
    Common.ToolTipArea {
        text: Services.SystemStats.memUsageText // Text for tooltip
        Layout.fillWidth: true // For some reason the width of the progress bar expands when using a Wrapper here.  
                               // Setting the fillWidth here restricts the size to the parent ig
        RowLayout {
            IconImage {
                implicitSize: 20
                source: Quickshell.iconPath("memory")
            }
            Text {
                text: {
                    Math.round(Services.SystemStats.memUsage) + '%'
                }
                color: palette.text
            }
            ProgressBar {
                Layout.fillWidth: true
                from: 0
                value: Services.SystemStats.memUsage
                to: 100
            }
        }
    }

    // Temp
    Common.ToolTipArea {
        text: "CPU Temperature"
        Layout.fillWidth: true
        RowLayout {
            IconImage {
                implicitSize: 20
                source: Quickshell.iconPath("temp-symbolic")
            }
            Text {
                text: {
                    Math.round(Services.SystemStats.cpuTemp) + '°C'
                }
                color: palette.text
            }
            ProgressBar {
                Layout.fillWidth: true
                from: 0
                value: Services.SystemStats.cpuTemp
                to: 100
            }
        }
    }

    // Disk usage
    Common.ToolTipArea {
        text: Services.SystemStats.storageUsageText
        Layout.fillWidth: true
        RowLayout {
            IconImage {
                implicitSize: 20
                source: Quickshell.iconPath("drive-harddisk")
            }
            Text {
                text: Math.round(Services.SystemStats.storageUsage) + '%'
                color: palette.text
            }
            ProgressBar {
                Layout.fillWidth: true
                from: 0
                value: Services.SystemStats.storageUsage
                to: 100
            }
        }
    }
}
