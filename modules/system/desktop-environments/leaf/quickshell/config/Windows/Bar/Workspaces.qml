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
    property int smallSize: 10
    property int mediumSize: 18
    property int largeSize: 36
    property int padding: 4
    spacing: 0

    component WsIndicator: MouseArea {
        id: wsIndicator
        required property int wsId
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
            console.error(`something bad happened`)
        }

        implicitWidth: {
            let width = 0
            switch(wsIndicator.wsState) {
                case "focused":
                    if (displayName.implicitWidth > root.largeSize ) {
                        width = displayName.implicitWidth; break
                    }
                    width = root.largeSize; break
                case "active":
                case "inactive":
                case "empty":
                    width = root.mediumSize; break
                default:
                    console.error("Invalid wsState")
            }
            return width + root.padding
        }
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: (event) => {
            switch(event.button) {
                case Qt.LeftButton:
                    Hyprland.dispatch(`workspace ${wsId}`)
                    break
                case Qt.RightButton:
                    Root.State.workspaces.toggleWindow()
                    break
                default:
                    console.log("button problem")
            }
        }
        Rectangle {
            id: dot
            anchors.centerIn: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4
            radius: 24
            color: {
                if (wsIndicator.containsMouse) {
                    return Root.State.colors.primary
                }
                switch(wsIndicator.wsState) {
                    case "focused":
                    case "active":
                        return Root.State.colors.primary
                    case "inactive":
                        return Root.State.colors.primary_container
                    case "empty":
                        return Root.State.colors.surface_container
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
                        switch(wsIndicator.wsState) {
                            case "focused":
                            case "active":
                                return wsIndicator.wsName !== "" ? wsIndicator.wsName : wsIndicator.wsId
                            case "inactive":
                                return wsIndicator.wsId
                            case "empty":
                                return ""
                            default:
                                console.error("Invalid wsState")
                        }
                    }
                    font.pointSize: 8

                    color: {
                        if (wsIndicator.containsMouse) {
                            return Root.State.colors.on_primary
                        }
                        switch(wsIndicator.wsState) {
                            case "focused":
                            case "active":
                                return Root.State.colors.on_primary
                            case "inactive":
                                return Root.State.colors.on_primary_container
                            case "empty":
                                return Root.State.colors.on_surface
                            default:
                                console.error("invalid wsState")
                                return "red"
                        }
                    }
                }
            }
        }
    }

    Repeater {
        model: root.numWorkspaces
        WsIndicator {
            required property int modelData
            wsId: modelData + 1
            Layout.fillHeight: true
        }
    }
}

