pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../../Services/" as Services
import "../../../Modules/Common" as Common
import "../../../" as Root
import "../Components"

PageBase {
    id: root
    pageName: "Display"
    property int maxWidth: 700
    property int minWidth: 400
    content: ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 16
        
        // Visual config
        WrapperRectangle {
            margin: 16
            color: "red"
            Layout.maximumWidth: root.maxWidth
            Layout.minimumWidth: root.minWidth
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

        Rectangle { 
            id: visualBox
            implicitHeight: area.height + settings.height
            property int scaleFactor: 1

            //color: palette.base
            color: "#ffff0000"
            radius: 16

            // Visual type to represent a monitor
            component Monitor: MouseArea {
                id: mouseArea
                required property HyprlandMonitor monitor

                // Modifiable monitor properties
                property int actualX: x - area.offsetX
                property int actualY: y - area.offsetY
                property real actualScale: monitor.scale

                // Set monitor element placement given the offset
                x: monitor.x + area.offsetX
                y: monitor.y + area.offsetY

                // Adjust size to match scale (required by hyprland)
                width: 100 //monitor.width / monitor.scale
                height: 100 //monitor.height / monitor.scale

                // Dragging
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
                    color: palette.accent
                    Text { 
                        scale: visualBox.scaleFactor // Scale the text back up to be readable
                        anchors.centerIn: parent
                        text: monitor.name
                        color: palette.dark
                    }
                }
            }

            // Monitor configuring area
            Rectangle {
                id: area
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                implicitHeight: 400

            Rectangle {
                // Set to large enough size to accommodate the native size of multiple monitors
                property int areaSize: parent.width * visualBox.scaleFactor
                implicitWidth: areaSize 
                implicitHeight: parent.height * visualBox.scaleFactor

                // Scale down the size to actually be usable
                // Note that using the scale element via the transform prop appears properly scale
                // from the top left corner.  Perhaps because it defaults to (0,0) as the origin.
                // Using the scale property seems to transform the position of the scaled element 
                // when the scale is applied.
                transform: Scale {
                    xScale: 1 / visualBox.scaleFactor
                    yScale: 1 / visualBox.scaleFactor
                }

                property int offsetX: areaSize / 2 
                property int offsetY: areaSize * 0.5 / 2 
                color: "orange"

                Repeater {
                    model: Hyprland.monitors

                    Monitor {
                        id: visualMonitor
                        required property HyprlandMonitor modelData
                        monitor: modelData
                        Component.onCompleted: {
                            //console.log(`monitor modeldata: ${modelData.x}x${modelData.y}`)
                            //console.log(`monitor ${monitor.name}: ${actualX}, ${actualY}`)
                            //console.log(`monitor ${monitor.name}: ${x}, ${y}`)
                            Services.Monitors.visualMonitors[monitor.id] = visualMonitor
                        }
                    }
                }
            }
            }

            // Monitor settings
            Rectangle {     
                id: settings
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: area.bottom
                implicitHeight: childrenRect.height
                color: palette.base
                RowLayout {
                    implicitWidth: parent.width
                    ColumnLayout {
                        id: box
                        Layout.fillWidth: true
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
        }

        // Options
        OptionSection {
            name: "General"
            options: [
                SwitchOption {},
                ComboOption {},
                SliderOption {},
                SpinOption {},
                TextOption {}
            ]
        }
    }
}
