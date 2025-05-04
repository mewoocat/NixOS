
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
            property int wsWidth: {
                const wsObj = Services.Hyprland.workspaceMap[wsID] 
                if (wsObj !== undefined && wsObj.id === Services.Hyprland.activeWsId) {
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
                implicitWidth: mouseArea.wsWidth
                height: 18
                //color: Hyprland.focusedMonitor.activeWorkspace.id === modelData.id ? "green" : "grey"
                // Todo fix
                color: mouseArea.containsMouse || Services.Hyprland.activeWsId === wsID ? "#00ff00" : "#ff0000"
                /*
                Component.onCompleted: {
                    console.log("WS: " + Services.Hyprland.activeWsId)
                    console.log("window: " + modelData.lastIpcObject)
                }
                */
                Text {
                    anchors.centerIn: parent
                    text: wsID    
                    font.pointSize: 8
                }
           }
       }
    }

}

