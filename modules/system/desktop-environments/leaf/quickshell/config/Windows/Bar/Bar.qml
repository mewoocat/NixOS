import Quickshell
import Quickshell.Io // For Process
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/" as Root
import "root:/Modules/Ui" as Ui
import "root:/Windows/ControlPanel"

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
                color: "#aa000000"
                // The screen from the screens list will be injected into this property
                property var modelData
                // Set the window's screen to the injected property
                screen: modelData
                anchors {
                    top: true
                    left: true
                    right: true
                }
                height: 40
                Item {
                    anchors.fill: parent
                    // Left
                    RowLayout {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        Ui.NormalButton {
                            action: () => Launcher.toggleWindow()
                            iconName: "distributor-logo-nixos"
                        }
                        Workspaces {}
                    }
                    // Center
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        Layout.alignment: Qt.AlignCenter
                        //Clock {}
                        Rectangle {
                            implicitWidth: text.width
                            implicitHeight: text.height
                            color: "green"
                            Text {
                                id: text
                                color: "#ff0000"
                                text: "hiiiiiiii"
                            }
                        }
                    }
                    // Right
                    RowLayout {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        Rectangle {
                            color: "green"
                            x: 40
                            y: 60
                            width: 20
                            height: 10
                        }
                        Ui.NormalButton {
                            action: () => ControlPanel.toggleWindow()
                            iconName: "view-grid-symbolic"
                        }
                    }
                }
            }
        }
    }
}
