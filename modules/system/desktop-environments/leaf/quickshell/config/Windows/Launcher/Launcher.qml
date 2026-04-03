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

    onCloseWindow: () => {
        Root.State.launcherVisibility = false
        appList.reset()
    }

    onToggleWindow: () => {
        Root.State.launcherVisibility = !Root.State.launcherVisibility
        appList.reset()
    }

    function launchApp(app: DesktopEntry) {
        console.log(`Launching app: ${app.id}`)
        Services.Applications.incrementFreq(app.id) // Update it's frequency
        app.execute()
        launcher.closeWindow() // Needs to be after the execute since this will reset the current index?
    }

    content: RowLayout {
        spacing: 0

        LeftPanel {
            Layout.margins: 4
            Layout.fillHeight: true
            onAppSelected: app => launcher.launchApp(app)
        }
        
        AppList {
            id: appList
            onAppSelected: app => launcher.launchApp(app)
            Layout.preferredHeight: 600
            Layout.preferredWidth: 400
        }
    }
}


