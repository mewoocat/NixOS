
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
            Layout.fillHeight: true
            width: 20
            id: mouseArea
            property int wsID: modelData + 1
            hoverEnabled: true
            //text: modelData.name
            onClicked: {
                console.log(`wsID: ${wsID}`)
                Hyprland.dispatch(`workspace ${wsID}`)
            }
            Rectangle {
                anchors.centerIn: parent
                radius: 24
                width: 18
                height: 18
                //color: Hyprland.focusedMonitor.activeWorkspace.id === modelData.id ? "green" : "grey"
                // Todo fix
                //width: modelData.lastIpcObject.windows < 1 ? 16 : 24
                color: mouseArea.containsMouse || Services.Hyprland.activeWsId === wsID ? "#00ff00" : "#ff0000"
                Component.onCompleted: {
                    console.log("WS: " + Services.Hyprland.activeWsId)
                }
                Text {
                    anchors.centerIn: parent
                    text: wsID    
                    font.pointSize: 8
                }
           }
       }
    }

}

