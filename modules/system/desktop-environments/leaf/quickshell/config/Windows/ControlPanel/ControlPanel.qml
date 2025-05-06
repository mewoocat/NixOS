//pragma Singleton
import "root:/Modules/Ui" as Ui
import QtQuick
import Quickshell
import "root:/" as Root

//Singleton {

    Ui.PopupWindow {
        name: "controlPanel"
        visible: Root.State.controlPanelVisibility
        function toggleWindow(){
            console.log("toggle window")
            Root.State.controlPanelVisibility = !Root.State.controlPanelVisibility
        } 
        anchors {
            top: true
            right: true
        }
        content: Text {
            text: "pwiughprhugpiuebpiun"
        }
    }
//}
