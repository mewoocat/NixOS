pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs as Root
import qs.Components.Widgets as Widgets
import qs.Components.Widgets.Tetris as Tetris
import qs.Components.Shared as Shared
import qs.Modules.Leaf as Leaf

Shared.PanelWindow {
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


    // Something weird's going on here
    content: Leaf.PanelGrid {
        columns: 16
        rows: 6

        Leaf.PanelItem { 
            isClickable: false; 
            rows: 6
            columns: 6
            content: Widgets.Notifications {} 
        }
        //Leaf.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        //Leaf.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Leaf.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Widgets.Weather {}
        }
        Leaf.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Widgets.AnalogClock {} 
        }
        Leaf.PanelItem { 
            isClickable: false; 
            rows: 3
            columns: 3
            content: Widgets.Calendar {} 
        }
        Leaf.PanelItem { 
            isClickable: false; 
            rows: 5
            columns: 4
            content: Tetris.Game {}
        }
        Leaf.PanelItem {
            isClickable: false
            rows: 2
            columns: 6
            content: Widgets.MusicPlayer {}
        }
    }
}

