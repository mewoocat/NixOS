pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import qs as Root
import qs.Services as Services

RowLayout {
    id: root
    property int numWorkspaces: 10
    spacing: 0
    Repeater {
        model: root.numWorkspaces
        MouseArea {
            id: mouseArea
            required property var modelData
            property int wsID: modelData + 1
            property var wsObj: Services.Hyprland.workspaceMap[wsID] 
            property string wsName: Root.State.config.workspaces.wsMap[`ws${mouseArea.wsID}`].name
            // Either active, inactive, or empty
            property string wsState: {
                //const wsObj = Services.Hyprland.workspaceMap[wsID] 
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
                    if (displayName.implicitWidth > 36 ) {
                        return displayName.implicitWidth
                    }
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
                color: {
                    mouseArea.containsMouse || Services.Hyprland.activeWsId === mouseArea.wsID ? palette.accent : mouseArea.wsState === "empty" ? palette.base : palette.link
                }
                WrapperItem {
                    id: displayName
                    anchors.centerIn: parent
                    leftMargin: 8
                    rightMargin: 8
                    Text {
                        text: {
                            //console.log("text: " + JSON.stringify(mouseArea.wsObj.name))
                            if (mouseArea.wsState === "empty") {
                                return ""
                            }
                            if (mouseArea.wsState === "inactive" || mouseArea.wsName === "") {
                                return mouseArea.wsID    
                            }
                            // Setting name: and defaultName: for a workspace doesn't change this name prop
                            //return mouseArea.wsObj.name
                            return Root.State.config.workspaces.wsMap[`ws${mouseArea.wsID}`].name
                        }
                        font.pointSize: 8
                    }
                }
            }
        }
    }
}

