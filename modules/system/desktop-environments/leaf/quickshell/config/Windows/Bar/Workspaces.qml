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
    property int smallSize: 8
    property int mediumSize: 18
    property int largeSize: 36
    spacing: 0

    component WsIndicator: WrapperMouseArea {
        id: wsIndicator
        required property var wsId
        property HyprlandWorkspace wsObj: Hyprland.workspaces.values.find(ws => ws.id === wsId) ?? null
        property string wsName: Root.State.config.workspaces.wsMap[`ws${wsId}`].name
        // Either focused, active, inactive, or empty
        property string wsState: {
            if (wsObj === null ) { 
                return "empty"
            }
            if (wsObj.focused) {
                return "focused"
            }
            if (wsObj.active) {
                return "active"
            }
            if (wsObj.toplevels.values.length > 0) {
                return "inactive"
            }
            if (wsObj.toplevels.values.length < 1) {
                return "empty"
            }
            console.error(`SOMETHING REALLY FUCKING BAD HAPPENED`)
        }

        leftMargin: 4
        rightMargin: 4
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
            color: {
                if (wsIndicator.containsMouse) return palette.accent
                switch(wsIndicator.wsState) {
                    case "focused":
                    case "active":
                        return palette.accent
                    case "inactive":
                        return palette.link
                    case "empty":
                        return palette.alternateBase
                    default:
                        console.error("invalid wsState")
                }
            }
            implicitHeight: wsIndicator.wsState !== "empty" ? root.mediumSize : root.smallSize
            implicitWidth: {
                switch(wsIndicator.wsState) {
                    case "focused":
                        if (displayName.implicitWidth > root.largeSize ) {
                            return displayName.implicitWidth
                        }
                        return root.largeSize
                    case "active":
                    case "inactive":
                        return root.mediumSize
                    case "empty":
                        return root.smallSize
                    default:
                        console.error("Invalid wsState")
                }
            }
            Behavior on implicitWidth {
                PropertyAnimation {duration: 100}
            }
            Behavior on implicitHeight {
                PropertyAnimation {duration: 10}
            }
            WrapperItem {
                id: displayName
                anchors.centerIn: parent
                leftMargin: 8
                rightMargin: 8
                Text {
                    text: {
                        if (wsIndicator.wsState === "focused") {
                            return wsIndicator.wsName
                        }
                        if (wsIndicator.wsState === "inactive" || wsIndicator.wsName === "") {
                            return wsIndicator.wsId
                        }
                        return ""
                    }
                    font.pointSize: 8
                }
            }
        }
    }

    Repeater {
        model: root.numWorkspaces
        WsIndicator {
            wsId: modelData + 1
            Layout.fillHeight: true
        }
    }
}

