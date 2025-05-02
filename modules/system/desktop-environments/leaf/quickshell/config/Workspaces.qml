
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import Quickshell.Hyprland


RowLayout {
    anchors {
        //fill: parent
    }
    Repeater {
        model: Hyprland.workspaces
        /*
        Button {
            implicitWidth: 50
            text: modelData.name
            onClicked: Hyprland.dispatch(`workspace ${modelData.id}`)
        }
        */
        Rectangle {
            color: Hyprland.focusedMonitor.activeWorkspace.id === modelData.id ? "green" : "grey"
            // Todo fix
            width: modelData.lastIpcObject.windows < 1 ? 16 : 24
            height: 16
            radius: 8
            MouseArea {
                anchors.fill: parent
                //text: modelData.name
                onClicked: Hyprland.dispatch(`workspace ${modelData.id}`)
                Text {
                    anchors.centerIn: parent
                    text: modelData.id     
                    font.pointSize: 8
                }
           }
       }
    }

}

