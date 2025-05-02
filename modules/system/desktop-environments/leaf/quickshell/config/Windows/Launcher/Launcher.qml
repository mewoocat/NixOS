import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland

import "root:/" as Root

PanelWindow {
    id: launcher
    visible: Root.State.launcherVisibility
    anchors {
        //top: true
        //left: true
        bottom: true
        right: true
    }
    focusable: true // Enable keyboard focus
    width: 300
    height: 400
    color: "transparent"
    margins {
        left: 16
        top: 16
    }

    /////////////////////////////////////////////////////////////////////////
    // Close on click away

    // Create a timer that sets the grab active state after a delay
    // Used to workaround a race condition with HyprlandFocusGrab where the onVisibleChanged
    // signal for the window occurs before the window is actually created
    // This would cause the grab to not find the window
    Timer {
        id: delay
        triggeredOnStart: false
        interval: 100
        repeat: false
        onTriggered: grab.active = Root.State.launcherVisibility
    }
    // Connects to the launcher onVisibleChanged signal
    // Starts a small delay which then sets the grab active state to match the 
    Connections {
        target: launcher
        function onVisibleChanged() {
            delay.start()
            console.log(`visible ${visible}`)
        }
    }
    HyprlandFocusGrab {
        id: grab
        active: false
        windows: [ launcher ]
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            console.log("cleared")
            Root.State.launcherVisibility = false
        }
    }
    /////////////////////////////////////////////////////////////////////////

    Rectangle {
        anchors.fill: parent
        color: "#aa000000"
        radius: 12
        ColumnLayout {
            anchors.fill: parent

            // Search field
            Rectangle {
                color: "transparent"
                height: 40
                Layout.fillWidth: true
                //Layout.fillWidth: true
                //Layout.fillHeight: true
                TextField {
                    anchors.margins: 8
                    anchors.fill: parent
                    Layout.fillWidth: true
                    background: Rectangle {
                        anchors.fill: parent
                        color: "grey"
                        radius: 16
                    }
                }
            }

            // Application list
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    Repeater {
                        model: DesktopEntries.applications
                        Component.onCompleted: console.log(`model = ${model}`)
                        MouseArea {
                            Layout.fillWidth: true
                            //Layout.fillHeight: true
                            height: 60
                            id: mouseArea
                            hoverEnabled: true
                            onClicked: modelData.execute()
                            Rectangle {
                                anchors.fill: parent
                                anchors {
                                    leftMargin: 16
                                    rightMargin: 16
                                    topMargin: 4
                                    bottomMargin: 4
                                }
                                /*
                                implicitWidth: 200
                                implicitHeight: 40
                                */
                                //Layout.fillWidth: true
                                //Layout.fillHeight: true
                                color: mouseArea.containsMouse ? "#00ff00" : "transparent"
                                radius: 10
                                RowLayout {
                                    anchors.fill: parent
                                    IconImage {
                                        implicitSize: 32
                                        source: Quickshell.iconPath(modelData.icon)
                                    }
                                    Text{
                                        color: "#ff00ff"
                                        text: modelData.name
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


