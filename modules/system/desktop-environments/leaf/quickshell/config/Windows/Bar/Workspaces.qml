
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import Quickshell.Hyprland

import "root:/Services/" as Services

RowLayout {
    property int numWorkspaces: 10
    Repeater {
        //model: Hyprland.workspaces
        model: numWorkspaces
        /*
        Button {
            implicitWidth: 50
            text: modelData.name
            onClicked: Hyprland.dispatch(`workspace ${modelData.id}`)
        }
        */
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
                console.log(`ws ${wsID} state: ${wsState}`)
                if (wsState === "active") {
                    return 36
                }
                return 18
            }
            implicitWidth: wsWidth
            //Layout.alignment: Qt.AlignLeft
            Layout.fillHeight: true
            hoverEnabled: true
            //text: modelData.name
            onClicked: { Hyprland.dispatch(`workspace ${wsID}`) }
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
                /*
                Behavior on implicitHeight {
                    PropertyAnimation {duration: 100}
                }
                */
                color: mouseArea.containsMouse || Services.Hyprland.activeWsId === wsID ? "#00ff00" : "#ff0000"
                Component.onCompleted: {
                    //console.log("WS: " + Services.Hyprland.activeWsId)
                    //console.log("window: " + modelData.lastIpcObject)
                    //console.log(`ws: ${Services.Hyprland.workspaceMap[wsID]}`)
                }
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

