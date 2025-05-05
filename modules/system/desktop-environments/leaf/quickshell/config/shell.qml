import Quickshell
import QtQuick
import Quickshell.Hyprland
import "Services" as Services
import "Windows/Bar"
import "Windows/Launcher"
import "Windows/ControlPanel"

ShellRoot {
    // Logic
    Component.onCompleted: {
        Controller.enable()
        Services.Hyprland.enable()
    }

    // Visual
    Bar {} 
    Launcher {}
    //ControlPanel.children {}
}
