pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool running: process.running

    Process {
        id: process
        running: root.running
        command: ["sh", "-c", "wlsunset -T 4010"]
    }
}
