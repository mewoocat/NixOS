pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Services as Services

WrapperMouseArea {
    id: mouseArea
    hoverEnabled: true
    onHoveredChanged: {
        Root.State.logWsPopupState()
        if (containsMouse) {
            popupCloseDelay.running = false
            Root.State.isWorkspaceWidgetHovered = true
        }
        else {
            popupCloseDelay.running = true
        }
    }

RowLayout {
    id: root
    property int numWorkspaces: 10
    property int smallSize: 10
    property int mediumSize: 18
    property int largeSize: 36
    property int padding: 4

    spacing: 0

    Timer {
        id: popupCloseDelay
        interval: 300
        onTriggered: () => {
            Root.State.isWorkspaceWidgetHovered = false
        }
        running: false
    }

    Repeater {
        model: root.numWorkspaces
        Ctrls.Button {
            id: workspaceButton
            implicitHeight: Root.State.barHeight
            topInset: 8
            bottomInset: 8
            padding: 0
            required property int modelData
            //wsId: modelData + 1

            onHoveredChanged: {
                console.debug(`ws btn hover is now: ${workspaceButton.hovered}`)
                if (workspaceButton.hovered) {
                    Root.State.currentHoveredWorkspace = workspaceButton
                    Root.State.hoveredWorkspace = modelData + 1
                }
            }
            text: modelData + 1
            Layout.fillHeight: true
        }
    }

    ////////////////////////////////////////////////////////////////
    // Components
    ////////////////////////////////////////////////////////////////
    component WsIndicator: MouseArea {
        id: wsIndicator
        required property int wsId
        onHoveredChanged: {
            if (containsMouse) {
                popupCloseDelay.running = false
                Root.State.hoveredWorkspace = wsId
                console.debug(`wsId: ${wsId}`)
                console.debug(`wsIndicator: ${wsIndicator}`)
                Root.State.currentHoveredWorkspace = wsIndicator
                Root.State.isWorkspacePopupVisible = true
            }
            else {
                popupCloseDelay.running = true
            }
        }
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
}
}

