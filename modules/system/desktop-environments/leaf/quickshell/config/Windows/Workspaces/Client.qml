import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import qs as Root


MouseArea {
    id: window
    required property HyprlandToplevel toplevel
    required property var clientObj
    required property real widgetScale
    required property real monitorScale
    required property real monitorX
    required property real monitorY
    property real scaleFactor: widgetScale * monitorScale
    // Need to subtract the monitor positon to account for any monitor offsets
    x: Math.round((clientObj.at[0] - monitorX) * scaleFactor)
    y: Math.round((clientObj.at[1] - monitorY) * scaleFactor)
    width: Math.round(clientObj.size[0] * scaleFactor) 
    height: Math.round(clientObj.size[1] * scaleFactor)
    hoverEnabled: true
    onClicked: () => {
        Hyprland.dispatch(`focuswindow address:${clientObj.address}`) 
        Root.State.workspaces.closeWindow()
    }
    property int initialX: 0
    property int initialY: 0
    onPressed: () => {
        // Store original position
        initialX = drag.target.x
        initialY = drag.target.y
    }
    onReleased: () => {
        if (Drag.target === null || Drag.target.wsId === toplevel.workspace.id) {
            console.log(`canceled drag`)
            Drag.cancel()
            // Reset to the original position
            drag.target.x = initialX
            drag.target.y = initialY
            return
        }
        console.log(`submitted drag`)
        Drag.drop()
    }
    drag.target: window
    Drag.active: drag.active
    Drag.keys: [ "workspace-client" ]
    // Moves the client to the top compared to it's sibling clients
    drag.onActiveChanged: () => drag.active ? window.z = 1 : window.z = 0
    Drag.hotSpot: Qt.point(width/2, height/2)

    ScreencopyView {
        anchors.fill: parent
        live: true // TODO: need to investigate performance impact
        captureSource: window.toplevel.wayland
    }

    // Border highlight
    //
    Rectangle {
        property int borderSize: 2
        x: -borderSize / 2; y: -borderSize / 2
        //implicitWidth: window.width + borderSize
        //implicitHeight: window.height + borderSize
        anchors.fill: parent
        border.width: borderSize
        border.color: window.containsMouse ? palette.accent : "transparent"
        color: "transparent"
        //radius: 4
    }

    /*
        // App indicator
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            visible: width < 40 || height < 40 ? false : true

            IconImage {
                id: icon
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath(window.clientObj.class)
            }
            Text {
                anchors.horizontalCenter: icon.horizontalCenter
                anchors.top: icon.bottom
                color: palette.text
                text: Services.Applications.formatClientName(window.clientObj.class)
                font.pointSize: 8
            }

            ToolTip {
                delay: 300
                text: window.clientObj.class
                visible: window.containsMouse
                background: Rectangle {
                    radius: 20
                    color: palette.window
                }
            }
        }
        Component.onCompleted: {
            //console.log(`modelData for ${wsId}: ${JSON.stringify(clientObj)}`)
            //console.log(`x: ${window.width}, y: ${window.height}, w: ${window.width}, h: ${window.height}`)
            //console.log("widgetScale " + widgetScale)
        }
    */
}
