
import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Wayland
import qs as Root
import qs.Modules.Leaf as Leaf
import qs.Windows.ControlPanel
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
            PanelWindow {
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
                    bottom: true
                    left: true
                    right: true
                }
                implicitHeight: 100 // Bar height
                WlrLayershell.namespace: "quickshell-bar" // Set layer name
                Rectangle {
                    color: Root.State.colors.surface
                    anchors.fill: parent
                    // Left
                    RowLayout {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        Leaf.NormalButton {
                            leftClick: () => Root.State.launcher.toggleWindow()
                            defaultInternalMargin: 6
                            iconName: "distributor-logo-nixos"
                        }
                        Workspaces {}
                        Button {
                            text: "what"
                            icon.name: "weather-fog-symbolic"
                        }
                        Leaf.Button {
                            text: "what"
                            icon.name: "view-more"
                            onClicked: () => console.log('hi')
                        }
                        Leaf.ButtonSkeuo {
                            text: "what"
                            icon.name: "view-more"
                            onClicked: () => console.log('hi')
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
                        Leaf.NormalButton {
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
