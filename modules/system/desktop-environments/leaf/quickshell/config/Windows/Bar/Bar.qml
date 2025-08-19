
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import qs as Root
import qs.Modules.Common as Common
import qs.Windows.ControlPanel
import "./SystemTray"

Scope {
    property string time;

    // This creates an instance for each screen
    Variants {
        model: [ Quickshell.screens[0] ] // just for one screen

        // Note: 
            // Component (s) can be defined implicitly, so it could be ommited here
            // Delegate is a default property and can be skipped as well
        delegate: Component {
            PanelWindow {
                id: bar
                // The screen from the screens list will be injected into this property
                property var modelData
                color: "transparent"
                focusable: true
                //WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                Component.onCompleted: {
                    Root.State.bar = bar
                }
                // Set the window's screen to the injected property
                screen: modelData
                anchors {
                    top: true
                    left: true
                    right: true
                }
                implicitHeight: 40 // Bar height
                WlrLayershell.namespace: "bar" // Set layer name
                Rectangle {
                    color: palette.window
                    anchors.fill: parent
                    // Left
                    RowLayout {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        Common.NormalButton {
                            leftClick: () => Root.State.launcher.toggleWindow()
                            defaultInternalMargin: 6
                            iconName: "distributor-logo-nixos"
                        }
                        Workspaces {}
                    }
                    // Center
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        //anchors.verticalCenter: parent.verticalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        spacing: 0
                        //Layout.alignment: Qt.AlignCenter

                        NotificationIndicator {}
                        Clock {}
                    }
                    // Right
                    RowLayout {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        spacing: 0

                        SystemTray {}
                        Network {}
                        Bluetooth {}
                        Audio {}
                        Battery {}
                        Common.NormalButton {
                            leftClick: () => Root.State.controlPanel.toggleWindow()
                            iconName: "view-grid-symbolic"
                           defaultInternalMargin: 6
                        }
                    }
                }
            }
        }
    }
}
