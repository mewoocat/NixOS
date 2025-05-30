//@ pragma UseQApplication
// //@ pragma Env QT_QUICK_CONTROLS_STYLE=org.kde.desktop
import Quickshell
import QtQuick
import Quickshell.Hyprland
import "Services" as Services
import "Windows" as Windows
import "Windows/Bar"
import "Windows/Launcher"
import "Windows/ControlPanel"
import "Windows/ActivityCenter"
import "Windows/Workspaces"
import "Windows/Notifications"
import "Windows/Settings"
//import Quickshell.Services.NetworkManager

ShellRoot {
    // Logic
    Component.onCompleted: {
        Controller.enable() // Need to call something from the controller to init it
        Services.Notifications.enable() // don't think this is needed anymore
        Services.Monitors.enable()
        //Services.Weather.enable()
        //Services.Hyprland.enable()
        //Services.Brightness.enable()
        //Services.Audio.enable()
    }

    // Visual
    Bar {} 
    Launcher {}
    ControlPanel {}
    ActivityCenter {}
    Workspaces {}
    Notifications {}
    Settings {}

}
