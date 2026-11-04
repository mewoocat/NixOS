pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs as Root
import qs.Services as Services
import qs.Components.Shared as Shared

Shared.PanelWindow2 {
    id: launcher

    anchors {
        top: true
        left: true
    }
    focusable: true
    //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: 'quickshell-panel-launcher'

    onVisibleChanged: () => {
        appList.reset();
    }

    function launchApp(app: DesktopEntry) {
        console.log(`Launching app: ${app.id}`);
        Services.Applications.incrementFreq(app.id);
        app.execute();
        launcher.closeWindow()
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
            // NOTE: A layout will set it's implicit size internally, overriding it doesn't do anything ...
            // seems using preferred size works to specify the size of a layout nested in a layout
            Layout.preferredHeight: 600
            Layout.preferredWidth: 400
        }
    }
}
