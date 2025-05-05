pragma Singleton
import "root:/Modules/Ui" as Ui
import QtQuick
import Quickshell
import "root:/" as Root

Singleton {

    function toggleWindow(){
        console.log("toggle window")
        Root.State.controlPanelVisibility = !Root.State.controlPanelVisibility
    } 

    Ui.PopupWindow {
        //id: window
        visible: Root.State.controlPanelVisibility
        name: "ControlPanel"
        anchors {
            top: true
            right: true
        }
        content: Text {
            text: "pwiughprhugpiuebpiun"
        }
    }
}

