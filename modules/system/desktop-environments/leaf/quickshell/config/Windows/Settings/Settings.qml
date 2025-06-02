
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import "../../Services/" as Services
import "../../Modules/Common" as Common

FloatingWindow {
    // No work?
    //minimumSize: "200x300"
    id: root    
    color: contentItem.palette.window
    
    property var selectedMonitorId: 0 

    // Visual type to represent a monitor
    component Monitor: MouseArea {
        id: mouseArea
        required property HyprlandMonitor monitor
        property int actualX: x - area.offset
        property int actualY: y - area.offset

        x: monitor.x + area.offset
        y: monitor.y + area.offset
        width: monitor.width
        height: monitor.height
        drag.target: mouseArea
        onPressed: () => {
            selectedMonitorId = monitor.id
        }
        Rectangle {
            anchors.fill: parent
            color: palette.highlight
            Text { 
                // Scale up and back to it's original position
                /*
                x: (width / 2) * (1 / area.scale)
                y: (height / 2) * (1 / area.scale)
                */
                scale: 1 / area.scale

                anchors.centerIn: parent
                text: monitor.name
                color: palette.dark
            }
        }
    }
    Rectangle {
        anchors.centerIn: parent
        id: area
        property int areaSize: 10000
        property int offset: areaSize / 2
        // Set to large enough size to accommodate the native size of multiple monitors
        implicitWidth: areaSize 
        implicitHeight: areaSize * 0.6
        // Scale down the size to actually be usable
        scale: 0.05
        color: palette.base


        Repeater {
            model: Hyprland.monitors

            Monitor {
                id: visualMonitor
                required property HyprlandMonitor modelData
                monitor: modelData
                Component.onCompleted: {
                    Services.Monitors.visualMonitors[monitor.id] = visualMonitor
                }
            }
        }

    }

    WrapperRectangle {     
        margin: 16
        anchors.bottom: parent.bottom
        color: palette.base
        RowLayout {
            ColumnLayout {
                id: box
                // can be undefined
                property var selectedMonitor: Services.Monitors.visualMonitors[selectedMonitorId]

                //name
                Text {
                    text: `Name: ${box.selectedMonitor !== undefined ? box.selectedMonitor.monitor.name : "?"}`
                    color: palette.text
                }
                // x position
                RowLayout {
                    Text {
                        text: `X: `
                        color: palette.text
                    }
                    SpinBox {
                        value: box.selectedMonitor !== undefined ? box.selectedMonitor.actualX : 0
                        from: -10000
                        to: 10000
                        onValueModified: () => {
                            box.selectedMonitor.x = value + area.offset
                        }
                    }
                }
                // y position
                RowLayout {
                    Text {
                        text: `Y: `
                        color: palette.text
                    }
                    SpinBox {
                        value: box.selectedMonitor !== undefined ? box.selectedMonitor.actualY : 0
                        from: -10000
                        to: 10000
                        onValueModified: () => {
                            box.selectedMonitor.y = value + area.offset
                        }
                    }
                }
                // scale
                RowLayout {
                    Text {
                        text: `Scale: `
                        color: palette.text
                    }
                    SpinBox {
                        value: box.selectedMonitor !== undefined ? box.selectedMonitor.actualY : 0
                        from: 0
                        to: 5 
                        stepSize: 1
                        onValueModified: () => {
                            console.log(`scale changed`)
                        }
                    }
                }
            }

            // Apply button
            Common.NormalButton {
                text: "Apply"
                leftClick: () => {
                    Services.Monitors.applyConf()
                }
            }
        }
    }


}
