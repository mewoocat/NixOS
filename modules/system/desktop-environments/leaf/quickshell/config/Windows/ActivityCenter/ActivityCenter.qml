
import QtQuick
import Quickshell
import "../../" as Root
import "../../Services" as Services
import "../../Modules" as Modules
import "../../Modules/Tetris" as Tetris
import "../../Modules/Common" as Common

Common.PanelWindow {
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
        columns: 16
        rows: 6

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
        Common.PanelItem { 
            isClickable: false; 
            rows: 6
            columns: 6
            content: Modules.Notifications {} 
        }
        //Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        //Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Common.PanelItem { 
            isClickable: false; 
            rows: 5
            columns: 4
            content: Tetris.Game {}
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
            content: Modules.AnalogClock {} 
        }
        Common.PanelItem { 
            isClickable: false; 
            rows: 3
            columns: 3
            content: Modules.Calendar {} 
        }
        Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Common.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
    }
}

