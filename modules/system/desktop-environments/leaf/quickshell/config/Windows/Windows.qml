pragma Singleton
import Quickshell

import "Bar"
import "Launcher"

Singleton {
    id: root
    function render() {
        let windowArr = []
        for (let key in root.windows) {
            windowArr.push(root.windows[key])
        }
        return windowArr
    }
    property var windows: {
        "Bar": Bar
        "Launcher": Launcher
    }
}
