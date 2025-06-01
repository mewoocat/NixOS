import Quickshell
import Quickshell.Widgets
import QtQuick
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
                //text: monitor.name
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
        anchors.bottom: parent.bottom
        color: palette.base
        RowLayout {
            ColumnLayout {
                id: box
                // can be undefined
                property var selectedMonitor: Services.Monitors.visualMonitors[selectedMonitorId]
                Text {
                    text: `Name: ${box.selectedMonitor !== undefined ? box.selectedMonitor.monitor.name : "?"}`
                    color: palette.text
                }
                Text {
                    text: `x: ${box.selectedMonitor !== undefined ? box.selectedMonitor.actualX : "?"}`
                    color: palette.text
                }
                Text {
                    text: `y: ${box.selectedMonitor !== undefined ? box.selectedMonitor.actualY : "?"}`
                    color: palette.text
                }
            }
            Common.NormalButton {
                text: "Apply"
                leftClick: () => {
                    console.log(Services.Monitors.visualMonitors[0].x)
                }
            }
        }
    }


}
