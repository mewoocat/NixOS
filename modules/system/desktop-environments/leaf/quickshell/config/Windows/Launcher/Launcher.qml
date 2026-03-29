pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs as Root
import qs.Services as Services
import qs.Components.Shared as Shared

Shared.PanelWindow {
    // Doesn't seem to force focus
    //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    id: launcher
    name: "launcher"
    visible: Root.State.launcherVisibility
    anchors {
        top: true
        left: true
    }
    implicitWidth: 420
    implicitHeight: 640
    focusable: true

    closeWindow: () => {
        Root.State.launcherVisibility = false
        appList.reset()
    }

    toggleWindow: () => {
        Root.State.launcherVisibility = !Root.State.launcherVisibility
        appList.reset()
    }

    function launchApp(app: DesktopEntry) {
        console.log(`Launching app: ${app.id}`)
        Services.Applications.incrementFreq(app.id) // Update it's frequency
        app.execute()
        launcher.closeWindow() // Needs to be after the execute since this will reset the current index?
    }

    content: Item {
        id: mainItem
        anchors.fill: parent
        RowLayout {
            spacing: 0
            anchors.fill: parent

            LeftPanel {

                Layout.margins: 4
                Layout.fillHeight: true
            }
            
            AppList {
                id: appList
                onAppSelected: app => launcher.launchApp(app)
            }
        }
    }
}


