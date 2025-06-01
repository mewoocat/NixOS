pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    // Used to initialize this singleton
    function enable(){
        console.log("Enabling Controller Singleton")
    }
    IpcHandler {
        target: "control"

        function toggleLauncher() {
            State.launcher.toggleWindow()
        }
        function toggleActivityCenter() {
            State.activityCenter.toggleWindow()
        }
        function toggleControlPanel() {
            State.controlPanel.toggleWindow()
        }
    }
}
