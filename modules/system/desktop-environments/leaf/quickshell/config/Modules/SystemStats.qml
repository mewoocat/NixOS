import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "root:/Services" as Services

ColumnLayout {
    anchors.margins: 8
    anchors.fill: parent

    // CPU
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
            id: cpuProg
            Layout.fillWidth: true
            from: 0
            value: Services.SystemStats.cpuUsage
            to: 100
            ToolTip {
                delay: 300
                text: "Cpu usage"
                visible: cpuProg.hovered
                background: Rectangle {
                    radius: 20
                    color: palette.window
                }
            }
        }
    }

    // Memory
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
            id: memProg
            Layout.fillWidth: true
            from: 0
            value: Services.SystemStats.memUsage
            to: 100
            ToolTip {
                delay: 300
                text: Services.SystemStats.memUsageText
                visible: memProg.hovered
                background: Rectangle {
                    radius: 20
                    color: palette.window
                }
            }
        }
    }

    // Temp
    RowLayout {
        IconImage {
            implicitSize: 20
            source: Quickshell.iconPath("temp-symbolic")
        }
        Text {
            text: {
                Math.round(Services.SystemStats.cpuUsage) + '°C'
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

    // Disk usage
    RowLayout {
        IconImage {
            implicitSize: 20
            source: Quickshell.iconPath("drive-harddisk")
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
