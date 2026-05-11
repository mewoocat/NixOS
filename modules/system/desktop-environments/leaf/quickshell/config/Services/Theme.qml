pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool darkMode: true
    onDarkModeChanged: {
        // Need to use callLater to run the function after the event loop finished
        // so that darkMode is set to it's new value.
        Qt.callLater(applyTheme)
    }
    property string wallpaper: "/home/eXia/Nextcloud/Wallpapers/bluepinkclouds.jpg"
    property real opacity: 0.7
    Process {
        id: process
        command: ["sh", "-c", `notify-send "${root.darkMode}"; matugen image ${root.wallpaper} --mode ${root.darkMode ? "dark" : "light"} -t scheme-rainbow --opacity ${root.opacity} --source-color-index 0`]
    }
    function applyTheme() {
        process.running = true
    }
}
