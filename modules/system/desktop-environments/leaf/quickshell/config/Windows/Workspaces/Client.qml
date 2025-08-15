import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import "../../" as Root
import "../../Services" as Services


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
    ScreencopyView {
        anchors.fill: parent
        //live: true // TODO: need to investigate performance impact
        captureSource: window.toplevel.wayland
    }
    // Boarder highlight
    Rectangle {
        property int borderSize: 4
        x: -borderSize / 2; y: -borderSize / 2
        implicitWidth: window.width + borderSize
        implicitHeight: window.height + borderSize
        border.width: borderSize
        border.color: window.containsMouse ? palette.highlight : palette.window
        color: "transparent"
        radius: 4
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
