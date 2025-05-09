import Quickshell
import Quickshell.Io // For Process
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Services.Pipewire
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
                //WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                Component.onCompleted: {
                    Root.State.bar = bar
                }
                id: bar
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
                WlrLayershell.namespace: "bar" // Set layer name
                Item {
                    anchors.fill: parent
                    // Left
                    RowLayout {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        Ui.NormalButton {
                            action: () => Root.State.launcher.toggleWindow()
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
                        //Layout.alignment: Qt.AlignCenter

                        Clock {}
                    }
                    // Right
                    RowLayout {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        /*
                        MouseArea {
                            implicitWidth: row.width
                            implicitHeight: 30
                            onClicked: () => text.text = "bbbb"
                            Rectangle {
                                anchors.fill: parent
                                RowLayout {
                                    id: row
                                    implicitWidth: text.width
                                    Text {
                                        id: text
                                        text: "aa"
                                    }
                                }
                            }
                        }
                        */

                        /*
                        Ui.NormalButton {
                            id: test
                            action: () => { test.text = "hiii"}
                            text: "a"
                            iconName: "view-grid-symbolic"
                        }
                        Battery {}
                        */
                        Audio {}
                        Battery {}
                        Ui.NormalButton {
                            action: () => Root.State.controlPanel.toggleWindow()
                            iconName: "view-grid-symbolic"
                        }
                    }
                }
            }
        }
    }
}
