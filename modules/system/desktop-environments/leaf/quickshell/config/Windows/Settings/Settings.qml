
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

        // Modifiable monitor properties
        property int actualX: x - area.offsetX
        property int actualY: y - area.offsetY
        property real actualScale: monitor.scale


        x: monitor.x + area.offset
        y: monitor.y + area.offset
        width: monitor.width / monitor.scale
        height: monitor.height / monitor.scale

        drag.target: mouseArea
        // restrict drag region to area
        drag.minimumX: 0
        drag.maximumX: area.width - width
        drag.minimumY: 0
        drag.maximumY: area.height - height

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
        property int areaSize: 6000
        // Set to large enough size to accommodate the native size of multiple monitors
        implicitWidth: areaSize 
        implicitHeight: areaSize * 0.6
        property int offsetX: areaSize / 2 
        property int offsetY: areaSize * 0.6 / 2 
        // Scale down the size to actually be usable
        scale: 0.1
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

                // resolution
                Text {
                    text: `Resolution: ${box.selectedMonitor !== undefined ? `${box.selectedMonitor.monitor.width}x${box.selectedMonitor.monitor.height}` : "?"}`
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
                            console.log(`value: ${value}`)
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
                        value: box.selectedMonitor !== undefined ? box.selectedMonitor.actualScale : 1
                        from: 1
                        to: 5 
                        stepSize: 1
                        onValueModified: () => {
                            console.log(`scale changed`)
                            box.selectedMonitor.actualScale = value
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
