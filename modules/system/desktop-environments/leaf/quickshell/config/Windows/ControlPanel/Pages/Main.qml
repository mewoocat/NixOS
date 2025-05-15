import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../"
import "root:/" as Root

GridLayout {
    id: grid
    //uniformCellWidths: true
    //uniformCellHeights: true

    // Setting this with implicit width/height causes the height to be 
    // basically 0 after hiding and showing the window
    // **Likely an upstream bug in qt quick**
    //implicitWidth: parent.width
    //implicitHeight: (parent.width / rows) * columns
    //width: parent.width
    //height: (parent.width / rows) * columns
    width: 300
    height: 300

    columns: 2
    columnSpacing: 0
    rows: 2
    rowSpacing: 0

    //PanelItem { Layout.columnSpan: 2; iconName: "ymuse-home-symbolic"}
    PanelItem { 
        //action: () => {grid.height = grid.height + 100}
        action: () => {
            console.log("clicked")
            Root.State.controlPanelPage = 1
        }
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("ymuse-home-symbolic")
        }
    }

    PanelGrid {
        PanelItem { 
            action: () => {}
            content: IconImage {
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath("ymuse-home-symbolic")
            }
        }
        PanelItem { 
            action: () => {}
            content: IconImage {
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath("ymuse-home-symbolic")
            }
        }
        PanelItem { 
            action: () => {}
            content: IconImage {
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath("ymuse-home-symbolic")
            }
        }
        PanelItem { 
            action: () => {}
            content: IconImage {
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath("ymuse-home-symbolic")
            }
        }
    }

    PanelItem { 
        action: () => {}
        content: SliderPanel {}
        Layout.columnSpan: 2;
    }


    /*
    PanelItem { iconName: "ymuse-home-symbolic"}
    PanelItem { iconName: "ymuse-home-symbolic"}
    PanelItem { iconName: "ymuse-home-symbolic"}
    PanelItem { iconName: "ymuse-home-symbolic"}
    */
}
