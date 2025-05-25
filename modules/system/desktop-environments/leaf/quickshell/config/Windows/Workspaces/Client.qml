import Quickshell
import QtQuick


MouseArea {
    id: window
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
    Component.onCompleted: {
        //console.log(`client: ${widgetScale}, ${monitorScale}`)
    }
    Rectangle {
        anchors.fill: parent
        color: window.containsMouse ? palette.highlight : palette.window
        radius: 4
        Text {
            anchors.centerIn: parent
            color: palette.text
            text: window.clientObj.class
        }
        Component.onCompleted: {
            //console.log(`modelData for ${wsId}: ${JSON.stringify(clientObj)}`)
            //console.log(`x: ${window.width}, y: ${window.height}, w: ${window.width}, h: ${window.height}`)
            //console.log("widgetScale " + widgetScale)
        }
    }
}
