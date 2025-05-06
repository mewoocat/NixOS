import "root:/Modules/Ui" as Ui
import QtQuick
import Quickshell
import "root:/" as Root

Ui.PopupWindow {
    function toggleWindow(){
        console.log("toggle window")
        Root.State.activityCenterVisibility = !Root.State.activityCenterVisibility
    } 
    //id: window
    name: "activityCenter"
    visible: Root.State.activityCenterVisibility
    anchors {
        top: true
        right: true
    }
    content: Text {
        color: "white"
        text: "pwiughprhugpiuebpiun"
    }
}

