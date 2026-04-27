pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls
import qs as Root
import "../"

BarButton {
    id: button
    required property SystemTrayItem trayItem
    // Need to use an IconImage to instead of the default Button contentItem in order to render the icon sources
    // Also needs to be wrapped in an item since the size of the contentItem is determined by the geometry of the
    // control but we want to force the icon size.
    contentItem: Item {
        IconImage {
            anchors.centerIn: parent
            implicitSize: 24
            source: button.modelData?.icon ?? Qt.url("")
        }
    }
    
    //isMultiColorIcon: true
    onClicked: modelData.activate
    ContextMenu.onRequested: () => popupWindow.visible = true

    property TrayPopupMenu popupWindow: TrayPopupMenu {
        id: trayPopup
        menuHandle: button.modelData.menu
        parentButton: button
        
        anchor {
            // Only window or item should be set at a time, otherwise a crash can occur
            item: button
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Bottom | Edges.Left
        }
    }
}
