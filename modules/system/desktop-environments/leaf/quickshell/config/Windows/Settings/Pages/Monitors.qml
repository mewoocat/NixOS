pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs as Root
import qs.Services as Services
import qs.Modules.Common as Common
import "../Components"

PageBase {
    id: root
    pageName: "Display"
    property int maxWidth: 700
    property int minWidth: 400
    property var selectedMonitor: Services.Monitors.selectedMonitor // can be undefined
    property int monitorAreaWidth: 10000
    property int monitorAreaHeight: 10000
    property int monitorAreaOriginX: 0 //monitorAreaWidth / 2
    property int monitorAreaOriginY: 0 //monitorAreaHeight / 2
    property real areaScale: 0.1
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
                property int actualX: x - root.monitorAreaOriginX
                property int actualY: y - root.monitorAreaOriginY
                property real actualScale: monitor.scale

                // Set monitor element placement given the offset
                x: monitor.x + root.monitorAreaOriginX
                y: monitor.y + root.monitorAreaOriginY

                // Adjust size to match scale (hyprland sees scaled monitors as their scaled size)
                // Note: the areaScale is not applied to this element since it's a child of the areaBackground
                // which is scaled, the scaling propagates.
                implicitWidth: monitor.width * actualScale
                implicitHeight: monitor.height * actualScale

                // Dragging
                drag.target: mouseArea
                // restrict drag region to area
                drag.minimumX: 0
                drag.maximumX: root.monitorAreaWidth - width
                drag.minimumY: 0
                drag.maximumY: root.monitorAreaHeight - height

                onPressed: () => Services.Monitors.selectedMonitorId = monitor.id

                Rectangle {
                    anchors.fill: parent
                    color: palette.accent
                    Text { 
                        scale: 1 / root.areaScale // Scale the text back up to be readable
                        anchors.centerIn: parent
                        text: monitor.name
                        color: palette.dark
                    }
                }
            }

            // Monitor configuring area
            Flickable {
                id: area
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                implicitHeight: 400
                clip: true

                // Set the flickable area to the size of the scaled background area
                // Note: the areaBackground size does not have it's scale applied to it.  For example,
                // if the implicitWidth of the areaBackground is 10,000, then the width of it will still
                // be 10,000 after the scale is applied
                contentWidth: areaBackground.width * root.areaScale
                contentHeight: areaBackground.height * root.areaScale

                // No clue how these actually get set on the flickable, i just guessed
                ScrollBar.vertical: ScrollBar {}
                ScrollBar.horizontal: ScrollBar {}

            Rectangle {
                id: areaBackground
                // Set to large enough size to accommodate the native size of multiple monitors
                //property int areaSize: 10000 //parent.width * visualBox.scaleFactor
                color: "orange"
                implicitWidth: root.monitorAreaWidth //* root.areaScale
                implicitHeight: root.monitorAreaHeight //* root.areaScale //parent.height * visualBox.scaleFactor

                // Scale down the size to actually be usable
                // Note that using the scale element via the transform prop appears properly scale
                // from the top left corner.  Perhaps because it defaults to (0,0) as the origin.
                // Using the scale property seems to transform the position of the scaled element 
                // when the scale is applied.
                transform: Scale {
                    xScale: root.areaScale
                    yScale: root.areaScale
                }

                //property int offsetX: areaSize / 2 
                //property int offsetY: areaSize * 0.5 / 2 

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
            SpinBox {
                onValueChanged: () => {
                    root.areaScale = (value / 100) * (area.width / root.monitorAreaWidth)
                    console.log(`zoom: ${root.areaScale}`)
                }
                from: 1
                value: 100
                to: 400
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

                        //name
                        Text {
                            text: `Name: ${root.selectedMonitor !== undefined ? root.selectedMonitor.monitor.name : "?"}`
                            color: palette.text
                        }

                        // resolution
                        Text {
                            text: `Resolution: ${root.selectedMonitor !== undefined ? `${root.selectedMonitor.monitor.width}x${root.selectedMonitor.monitor.height}` : "?"}`
                            color: palette.text
                        }
                        // x position
                        RowLayout {
                            Text {
                                text: `X: `
                                color: palette.text
                            }
                            SpinBox {
                                value: root.selectedMonitor !== undefined ? root.selectedMonitor.actualX : 0
                                from: -10000
                                to: 10000
                                onValueModified: () => {
                                    root.selectedMonitor.x = value + area.offset
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
                                value: root.selectedMonitor !== undefined ? root.selectedMonitor.actualY : 0
                                from: -10000
                                to: 10000
                                onValueModified: () => {
                                    root.selectedMonitor.y = value + area.offset
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
                            TextField {
                                text: root.selectedMonitor.actualScale ?? 1
                                validator: DoubleValidator {bottom: 0.5; top: 4;}
                                onAccepted: () => {
                                    console.log(`scale changed`)
                                    root.selectedMonitor.actualScale = text
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
                Option {
                    title: "test option"
                    content: Switch {}
                }
            ]
        }
    }
}
