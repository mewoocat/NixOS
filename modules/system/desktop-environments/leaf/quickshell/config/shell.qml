import Quickshell
import QtQuick
import Quickshell.Hyprland
import "Windows/Bar"
import "Windows/Launcher"
import "Services" as Services

ShellRoot {
    // Logic
    Component.onCompleted: {
        Controller.enable()
        Services.Hyprland.enable()
    }

    // Visual
    Bar {} 
    Launcher {}
}
