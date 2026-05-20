import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs as Root
import "./SystemTray"
import "./Workspaces"

Scope {

    // This creates an instance for each screen
    Variants {
        model: Quickshell.screens 

        // Note: 
        // Component (s) can be defined implicitly, so it could be ommited here
        // Delegate is a default property and can be skipped as well
        delegate: Component {
            PanelWindow { // qmllint disable uncreatable-type
                id: bar
                // The screen from the screens list will be injected into this property
                property var modelData
                color: "transparent"
                screen: modelData
                anchors {
                    top: true
                    left: true
                    right: true
                }
                implicitHeight: Root.State.barHeight // Bar height
                WlrLayershell.namespace: "quickshell-bar" // Set layer name

                Rectangle {
                    color: Root.State.colors.surface
                    anchors.fill: parent

                    // Set the window's screen to the injected property

                    // Left
                    RowLayout {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        spacing: 0

                        Launcher {}
                        WorkspacesDynamic {
                            screen: bar.screen
                        }
                    }

                    // Center
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        spacing: 0

                        NotificationIndicator {}
                        Clock {}
                        RecordingIndicator {}
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
                        ControlPanel {}
                    }
                }
            }
        }
    }
}
