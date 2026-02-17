pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs as Root
import qs.Modules as Modules
import qs.Modules.Tetris as Tetris
import qs.Modules.Leaf as Leaf

Leaf.PanelWindow {
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

        Leaf.PanelItem { 
            isClickable: false; 
            Layout.columnSpan: 2
            Layout.rowSpan: 2
            content: Modules.Calendar {} 
        }
        Leaf.PanelItem { 
            isClickable: false; 
            Layout.columnSpan: 2
            Layout.rowSpan: 2
            content: Modules.Weather {}
        }
    }
    */

    // Something weird's going on here
    content: Leaf.PanelGrid {
        columns: 16
        rows: 6

        /*
        Leaf.PanelItem {
            isClickable: true
            rows: 1
            columns: 1
            content: Modules.Image {}
            action: () => {
                console.log(`${Layout.row} x ${Layout.column}`)
            }
        }

        Leaf.PanelItem {
            isClickable: true
            rows: 1
            columns: 1
            content: Modules.Image {}
            action: () => {
                console.log(`${Layout.row} x ${Layout.column}`)
            }
        } 
        */

        Leaf.PanelItem { 
            isClickable: false; 
            rows: 6
            columns: 6
            content: Leaf.ListView {
                id: listView
                model: 5
                delegate: Leaf.ListItemExpandable {
                    id: listItem
                    required property var modelData
                    listView: listView
                    mainDelegate: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: "green"
                        RowLayout {
                            Text {
                                text: "main shit"
                            }
                            Leaf.NormalButton {
                                text: "what"
                                onClicked: listItem.expanded = !listItem.expanded
                            }
                        }
                    }
                    subDelegate: Rectangle {
                        color: "red"
                        implicitWidth: 100
                        implicitHeight: 40
                        Text {
                            text: "fuck shit"
                        }
                    }
                }
            }
        }
        /*
        Leaf.PanelItem { 
            isClickable: false; 
            rows: 6
            columns: 6
            content: Modules.Notifications {} 
        }
        */
        //Leaf.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        //Leaf.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Leaf.PanelItem { 
            isClickable: false; 
            rows: 5
            columns: 4
            content: Tetris.Game {}
        }
        Leaf.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Modules.Weather {}
        }
        Leaf.PanelItem { 
            isClickable: false; 
            rows: 2
            columns: 2
            content: Modules.AnalogClock {} 
        }
        Leaf.PanelItem { 
            isClickable: false; 
            rows: 3
            columns: 3
            content: Modules.Calendar {} 
        }
        Leaf.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Leaf.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Leaf.PanelItem { isClickable: true; rows: 1; columns: 1; content: Modules.Image {} }
        Leaf.PanelItem {
            isClickable: false
            rows: 2
            columns: 6
            content: Modules.MusicPlayer {}
        }
    }
}

