import QtQuick
import QtQuick.Controls

// For some reason this seems to capture key events
MouseArea {
    id: root
    width: 64
    height: 32
    hoverEnabled: true 
    required property string text
    onFocusChanged: () => {
        focus = false
        console.log(`focus changed to ${focus}`)
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: root.containsMouse ? "dimgrey" : "grey"
        Text {
            anchors.centerIn: parent
            text: root.text
            color: "white"
        }
    }
}
/*
Button {
    
}
*/
