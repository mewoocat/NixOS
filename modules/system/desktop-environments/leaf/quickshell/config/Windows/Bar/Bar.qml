
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets as QsWidgets
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Controls.impl // For IconLabel
import QtQuick.Layouts
import qs as Root
//import qs.Windows.Bar.WorkspacesHyprland
import qs.Windows.Bar.WorkspacesGeneric
import qs.Windows.ControlPanel
import qs.Components.Controls as Ctrls
import "./SystemTray"

import qs.Services as Services

Scope {
    property string time;

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
                implicitHeight: Root.State.barHeight // Bar height
                WlrLayershell.namespace: "quickshell-bar" // Set layer name
                Rectangle {
                    color: Root.State.colors.surface
                    anchors.fill: parent
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
                        BarButton {
                            text: "+"
                            onClicked: Hyprland.dispatch(`workspace emptynm`) // "Create" the next empty workspace
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
                        Rectangle {
                            visible: Services.ScreenCapture.recording
                            implicitWidth: 4
                            implicitHeight: 4
                            radius: 4
                            color: "red"
                        }
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
                        BarButton {
                            onClicked: () => Root.State.controlPanelActive = !Root.State.controlPanelActive
                            icon.name: "open-menu-symbolic"
                        }
                    }
                }
            }
        }
    }
}
