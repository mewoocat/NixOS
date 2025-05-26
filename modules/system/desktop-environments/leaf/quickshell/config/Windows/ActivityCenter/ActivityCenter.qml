import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "root:/" as Root
import "root:/Modules" as Modules
import "root:/Modules/Common" as Common

Common.PopupWindow {
    toggleWindow: () => {
        Root.State.activityCenterVisibility = !Root.State.activityCenterVisibility
    } 
    closeWindow: () => {
        Root.State.activityCenterVisibility = false
    } 
    //id: window
    name: "activityCenter"
    visible: Root.State.activityCenterVisibility
    anchors {
        top: true
    }
    implicitWidth: 600
    implicitHeight: content.height
    content: GridLayout {
        width: parent.width
        height: parent.width / columns * rows
        columns: 3
        rows: 2

        Common.PanelItem { 
            isClickable: false; 
            content: Modules.Calendar {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            content: Modules.Calendar {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            content: Modules.Calendar {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            content: Modules.Calendar {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            content: Modules.Calendar {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            content: Modules.Weather {}
        }
    }
}

