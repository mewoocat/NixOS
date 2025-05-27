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
    implicitWidth: content.width
    implicitHeight: content.height

    /*
    content: GridLayout {
        width: parent.width
        height: parent.width / columns * rows
        columns: 8
        rows: 4

        Common.PanelItem { 
            isClickable: false; 
            Layout.columnSpan: 2
            Layout.rowSpan: 2
            content: Modules.Calendar {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            Layout.columnSpan: 2
            Layout.rowSpan: 2
            content: Modules.Weather {}
        }
    }
    */

    // Something weird's going on here
    content: Common.PanelGrid {
        columns: 6
        rows: 8

        /*
        Common.PanelItem {
            isClickable: true
            rows: 1
            columns: 1
            content: Modules.Image {}
            action: () => {
                console.log(`${Layout.row} x ${Layout.column}`)
            }
        }

        Common.PanelItem {
            isClickable: true
            rows: 1
            columns: 1
            content: Modules.Image {}
            action: () => {
                console.log(`${Layout.row} x ${Layout.column}`)
            }
        } 
        */
        Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Common.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Modules.Weather {}
        }
        Common.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Modules.Weather {}
        }
        Common.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Modules.Weather {}
        }
        Common.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Modules.Calendar {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Modules.Calendar {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Modules.Calendar {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Modules.Calendar {} 
        }
        Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
    }
}

