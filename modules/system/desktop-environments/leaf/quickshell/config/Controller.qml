pragma Singleton

import Quickshell
import Quickshell.Io
import "root:/" as Root

Singleton {
    // Used to initialize this singleton
    function enable(){
        console.log("Enabling Controller Singleton")
    }
    IpcHandler {
        target: "control"

        function toggleLauncher() {
            Root.State.launcher.toggleWindow()
        }
    }
}
