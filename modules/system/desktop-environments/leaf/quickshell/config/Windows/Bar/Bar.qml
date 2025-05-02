import Quickshell
import Quickshell.Io // For Process
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/" as Root

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
                RowLayout {
                    anchors.fill: parent
                    //implicitWidth: clock.width
                    //implicitHeight: clock.height
                    RoundButton {
                        icon.name: "distributor-logo-nixos"
                        anchors.leftMargin: 16
                        onClicked: {
                            Root.State.launcherVisibility = !Root.State.launcherVisibility
                        }
                    }
                    Workspaces {}
                    Clock {}
                    Rectangle {
                        color: "green"
                        x: 40
                        y: 60
                        width: 20
                        height: 10
                    }
                }
            }
        }
    }
}
