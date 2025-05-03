import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland

import "root:/" as Root

PanelWindow {
    // Stores the current search
    property string searchText: ""

    id: launcher
    visible: Root.State.launcherVisibility
    anchors {
        top: true
        left: true
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
                implicitHeight: 48
                Layout.fillWidth: true
                TextField {
                    placeholderText: "Seach..."
                    anchors.margins: 8
                    anchors.fill: parent
                    leftPadding: 12
                    rightPadding: 12
                    background: Rectangle {
                        color: "gray"
                        radius: 16
                    }
                    onTextChanged: () => {
                        searchText = text
                        console.log(`searchText: ${searchText}`)
                    }
                }
            }

            // Application list
            ScrollView {
                focus: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                ColumnLayout {
                    anchors.fill: parent
                    Repeater {
                        focus: true
                        //anchors.fill: parent
                        model: DesktopEntries.applications
                        Component.onCompleted: console.log(`model = ${model}`)

                        MouseArea {
                            focus: true
                            id: mouseArea
                            property var app: modelData

                            Component.onCompleted: console.log(`model = ${app.name}`)

                            // Filter using search text
                            visible: {
                                if (
                                    app.name.toLowerCase().includes(app.name.toLowerCase())
                                ) {
                                    return true
                                }
                                return false
                            }
                            Layout.fillWidth: true
                            height: 60
                            hoverEnabled: true
                            onClicked: app.execute()
                            Rectangle {
                                anchors.fill: parent
                                anchors {
                                    leftMargin: 16
                                    rightMargin: 16
                                    topMargin: 4
                                    bottomMargin: 4
                                }
                                color: mouseArea.containsMouse ? "#00ff00" : "transparent"
                                radius: 10
                                RowLayout {
                                    anchors.fill: parent
                                    IconImage {
                                        implicitSize: 32
                                        source: Quickshell.iconPath(app.icon)
                                    }
                                    Text{
                                        color: "#ffffff"
                                        text: app.name
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


