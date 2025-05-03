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

    /*
    // Can't seem to access from outside the file, i think it needs a instance of this object
    function toggleWindow(): void { 
        Root.State.launcherVisibility = !Root.State.launcherVisibility
    }
    */

    onVisibleChanged: {
        searchText = "" 
        textField.text = ""
        listView.currentIndex = 0
    }

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
                //Layout.fillHeight: true
                TextField {
                    id: textField
                    focus: true // Make this have focus by default
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
                        listView.currentIndex = 0
                    }
                    Keys.onUpPressed: {
                        listView.decrementCurrentIndex()
                        listView.positionViewAtIndex(listView.currentIndex, ListView.Center)
                    }
                    Keys.onDownPressed: {
                        listView.incrementCurrentIndex()
                        listView.positionViewAtIndex(listView.currentIndex, ListView.Center)
                    }
                }
            }

            // Application list
            /*
            ScrollView {
                //focus: true
                Layout.fillWidth: true
                //clip: true // Ensure that scrolled items don't go outside the widget
                Layout.fillHeight: true
            */
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    //cacheBuffer: 0
                    maximumFlickVelocity: 100 // Increases bound overshoot?
                    id: listView
                    keyNavigationEnabled: true
                    model: ScriptModel {
                        values: DesktopEntries.applications.values
                            .filter(app => app.name.toLowerCase().includes(searchText.toLowerCase()))
                            //.filter(app => true)
                    }

                    snapMode: ListView.SnapToItem
                    Component.onCompleted: console.log(`model = ${model}`)
                    // Add a scroll bar to the list
                    // idk where this ScrollBar.vertical property is defined
                    ScrollBar.vertical: ScrollBar { }

                    delegate: MouseArea {
                        //focusPolicy: Qt.TabFocus
                        //focus: true
                        id: mouseArea
                        required property DesktopEntry modelData
                        //property DesktopEntry app: mouseArea.modelData
                        Component.onCompleted: console.log(`app = ${modelData.name}`)

                        height: 60
                        width: listView.width

                        hoverEnabled: true
                        onClicked: modelData.execute()
                        Keys.onReturnPressed: modelData.execute()
                        Rectangle {
                            anchors.fill: parent
                            anchors {
                                leftMargin: 16
                                rightMargin: 16
                                topMargin: 4
                                bottomMargin: 4
                            }
                            color: mouseArea.containsMouse || mouseArea.focus ? "#00ff00" : "transparent"
                            radius: 10
                            RowLayout {
                                anchors.fill: parent
                                IconImage {
                                    id: icon
                                    implicitSize: 32
                                    source: Quickshell.iconPath(modelData.icon)
                                }
                                Text{
                                    Layout.fillWidth: true
                                    leftPadding: 8
                                    color: "#ffffff"
                                    text: modelData.name
                                }
                            }
                        }
                    }
                }
            //}
        }
    }
}


