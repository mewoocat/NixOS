import "root:/Modules/Ui" as Ui
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
    }
    content: GridLayout {
        columns: 1
        rows: 2
        Text {
            color: "white"
            text: "pwiughprhugpiuebpiun"
        }
        MonthGrid {
        }
    }
}

