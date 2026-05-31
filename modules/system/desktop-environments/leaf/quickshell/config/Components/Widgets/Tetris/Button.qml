import QtQuick

// For some reason this seems to capture key events
MouseArea {
    id: root
    width: 64
    height: 32
    focus: false
    hoverEnabled: true 
    required property string text

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
