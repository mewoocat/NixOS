
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
                    top: true
                    left: true
                    right: true
                }
                implicitHeight: 40 // Bar height
                WlrLayershell.namespace: "quickshell-bar" // Set layer name
                Rectangle {
                    color: Root.State.colors.surface
                    anchors.fill: parent
                    // Left
                    RowLayout {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        BarButton {
                            onClicked: () => Root.State.launcher.toggleWindow()
                            icon.name: Root.State.launcherIcon
                            //isMutliColorIcon: true
                        }
                        Workspaces {}
                        Leaf.Slider {
                        }
                        Text {
                            font.family: "Material Symbols Rounded"
                            text: "dataset" // Material Symbols font auto renders icon when using it's name
                            color: "white"
                            //textFormat: Text.PlainText
                            //renderType: Text.NativeRendering
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
                            width: 4
                            height: 4
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
                        Leaf.Button {
                            onClicked: () => Root.State.controlPanel.toggleWindow()
                            icon.name: "open-menu-symbolic"
                            inset: 6
                            implicitHeight: bar.height
                            implicitWidth: 48
                        }
                    }
                }
            }
        }
    }
}
