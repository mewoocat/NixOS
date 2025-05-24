import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Hyprland
import "root:/" as Root
import "root:/Services/" as Services

RowLayout {
    property int numWorkspaces: 10
    spacing: 0
    Repeater {
        model: numWorkspaces
        MouseArea {
            id: mouseArea
            property int wsID: modelData + 1
            // Either active, inactive, or empty
            property string wsState: {
                const wsObj = Services.Hyprland.workspaceMap[wsID] 
                if (wsObj !== undefined && wsObj.id === Services.Hyprland.activeWsId) {
                    return "active"
                }
                if (wsObj === undefined || wsObj.lastIpcObject.windows < 1) {
                    return "empty"
                }
                return "inactive"
            }
            property int wsWidth: {
                if (wsState === "active") {
                    return 36
                }
                return 18
            }
            implicitWidth: wsWidth + 4 // add padding
            Layout.fillHeight: true
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onClicked: (event) => {
                switch(event.button) {
                    case Qt.LeftButton:
                        Hyprland.dispatch(`workspace ${wsID}`) 
                        break
                    case Qt.RightButton:
                        Root.State.workspaces.toggleWindow()
                        break
                    default:
                        console.log("button problem")
                }
            }
            Rectangle {
                anchors.centerIn: parent
                radius: 24
                implicitWidth: {
                    if (mouseArea.wsState === "empty") {
                        return 8
                    }
                    return mouseArea.wsWidth
                }
                implicitHeight: {
                    if (mouseArea.wsState === "empty") {
                        return 8
                    }
                    return 18
                }
                Behavior on implicitWidth {
                    PropertyAnimation {duration: 100}
                }
                Behavior on implicitHeight {
                    PropertyAnimation {duration: 10}
                }
                color: mouseArea.containsMouse || Services.Hyprland.activeWsId === wsID ? "#00ff00" : "#ff0000"
                Text {
                    anchors.centerIn: parent
                    text: {
                        if (mouseArea.wsState !== "empty" || mouseArea.wsState === "active") {
                            return wsID    
                        }
                        return ""
                    }
                    font.pointSize: 8
                }
            }
        }
    }
}

