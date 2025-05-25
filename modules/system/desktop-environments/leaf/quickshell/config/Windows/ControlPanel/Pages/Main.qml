import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import "../"
import "root:/" as Root
import "root:/Services" as Services
import "root:/Modules" as Modules
import "root:/Modules/Common" as Common

GridLayout {
    id: grid
    //uniformCellWidths: true
    //uniformCellHeights: true

    // Setting this with implicit width/height causes the height to be 
    // basically 0 after hiding and showing the window
    // **Likely an upstream bug in qt quick**
    //implicitWidth: parent.width
    //implicitHeight: (parent.width / rows) * columns
    width: parent.width
    height: parent.width * grid.rows / grid.columns / 2

    columns: 2
    columnSpacing: 0
    rows: 3
    rowSpacing: 0

    //PanelItem { Layout.columnSpan: 2; iconName: "ymuse-home-symbolic"}
    Common.PanelItem { 
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
        Common.PanelItem { 
            action: () => {
                console.log("width: " + grid.width)
                console.log(`height: ` + grid.height)
                console.log(`parent.width: ${grid.parent.width}`)
                console.log(`parent.height: ${grid.parent.height}`)
                console.log(`parent.count: ${grid.parent.count}`)
            }
            content: IconImage {
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath("ymuse-home-symbolic")
            }
        }
        Common.PanelItem { 
            content: IconImage {
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath("ymuse-home-symbolic")
            }
        }
        Common.PanelItem { 
            content: IconImage {
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath("ymuse-home-symbolic")
            }
            action: () => {
                console.log('action:')
                console.log(Root.State.config.location.latitude)
                Root.State.config.location.latitude = 3
                console.log(Root.State.config.location.latitude)
            }
        }
        PanelItem { 
            content: IconImage {
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath("ymuse-home-symbolic")
            }
        }
    }

    PanelItem { 
        content: Modules.SystemStats {
            anchors.centerIn: parent
        }
    }
    PanelItem { 
        content: ComboBox {
            model: ["First", "Second", "Third"]
        }
    }

    PanelItem { 
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
