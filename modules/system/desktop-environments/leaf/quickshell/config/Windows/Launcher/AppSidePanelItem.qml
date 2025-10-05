pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.Services as Services

SidePanelItem {
    id: item
    required property string modelData
    property alias appId: item.modelData // Aliasing a sibling property requires accessing via an id?
    property DesktopEntry desktopEntry: Services.Applications.findDesktopEntryById(appId)
    imgName: desktopEntry.icon
    action: desktopEntry.execute
    Component.onCompleted: console.log(`pinned app: ${modelData}; pinned desktopEntry: ${desktopEntry.icon}`)
    
    // Drag and drop setup
    property int initialX: 0
    property int initialY: 0
    onPressed: () => {
        // Store original position
        initialX = drag.target.x
        initialY = drag.target.y
    }
    onReleased: () => {
        if (Drag.target === null) {
            console.log(`canceled drag`)
            Drag.cancel()
            // Reset to the original position
            drag.target.x = initialX
            drag.target.y = initialY
            return
        }
        console.log(`submitted drag`)
        Drag.drop()
    }
    drag.target: item
    Drag.active: drag.active
    Drag.keys: [ "pinned-app" ]
    // Moves the client to the top compared to it's sibling clients
    drag.onActiveChanged: () => drag.active ? item.z = 1 : item.z = 0
    Drag.hotSpot: Qt.point(width/2, height/2)
}
