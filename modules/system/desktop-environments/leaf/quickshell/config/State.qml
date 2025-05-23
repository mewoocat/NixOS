pragma Singleton

import Quickshell
import "Windows/Bar"

Singleton {
    property bool launcherVisibility: false
    property bool controlPanelVisibility: false
    property bool activityCenterVisibility: false
    property bool workspacesVisibility: false

    property var bar: null
    property var launcher: null
    property var controlPanel: null
    property var activityCenter: null
    property var workspaces: null

    property int controlPanelPage: 0

    //property var Bar: Bar {}
    /*
    Scope {
        id: windows
        property var bar: null
        property var launcher: null
        property var controlPanel: null
        property var activityCenter: null
    }
    */

    // Map of current window objects
    // Init'd to null and set within each window
    // WARNING: I think that if just one of the prop of this js obj is updated
    // that, it won't be reactive
    /*
    property var windows: {
        "Bar": null,
        "Launcher": null,
        "ControlPanel": null,
        "ActivityCenter": null,
    }
    */
}
