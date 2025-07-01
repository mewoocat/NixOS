
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../" as Root
import "../../Services" as Services
import "./Pages/" as Pages

FloatingWindow {
    // No work?
    //minimumSize: "200x300"
    id: root    
    color: contentItem.palette.window
    visible: false

    Component.onCompleted: {
        console.log("adding settings to state")
        Root.State["settings"] = root // Set the window ref in state
    }

    function openWindow() {
        console.log('open windwo')
        root.visible = true
    }
    function closeWindow() {
        root.visible = false
    }
    
    property var selectedMonitorId: 0 

    Rectangle {
        id: box
        color: "transparent"
        anchors.fill: parent

        /*
        PageIndicator {
            id: pageIndicator
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            implicitWidth: 120
        }
        */
        Rectangle {
            id: pageIndicator
            color: "#00000000"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            implicitWidth: 240 - scrollBar.width

            component UserPageButton: MouseArea {
                id: pageButton
                enabled: true
                hoverEnabled: true
                required property string text
                required property string icon
                anchors.left: parent.left
                anchors.right: parent.right
                implicitHeight: 64
                Rectangle {
                    radius: 16
                    anchors.margins: 4
                    anchors.fill: parent
                    color: pageButton.containsMouse ? palette.accent: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        ClippingRectangle {
                            id: pfp
                            property int size: 48
                            radius: size
                            implicitWidth: size
                            implicitHeight: size
                            IconImage {
                                implicitSize: pfp.size
                                anchors.centerIn: parent
                                source: Services.User.pfpPath
                            }
                        }
                        Text {
                            Layout.fillWidth: true
                            text: Services.User.username
                            color: palette.text
                        }
                    }
                }
            }

            // Button to pick the current settings page
            component PageButton: MouseArea {
                id: pageButton
                enabled: true
                hoverEnabled: true
                required property string text
                required property string icon
                anchors.left: parent.left
                anchors.right: parent.right
                implicitHeight: 48
                Rectangle {
                    radius: 16
                    anchors.margins: 4
                    anchors.fill: parent
                    color: pageButton.containsMouse ? palette.accent: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        IconImage {
                            implicitSize: 24
                            source: Quickshell.iconPath(pageButton.icon)
                        }
                        Text {
                            Layout.fillWidth: true
                            text: pageButton.text
                            color: palette.text
                        }
                    }
                }
            }

            Flickable {
                id: listView
                anchors.fill: parent
                anchors.margins: 16
                flickDeceleration: 0.00001
                maximumFlickVelocity: 10000
                clip: true // Ensure that scrolled items don't go outside the widget
                ScrollBar.vertical: ScrollBar {
                    id: scrollBar
                    parent: listView.parent
                    anchors.left: listView.right
                    anchors.top: listView.top
                    anchors.bottom: listView.bottom
                }

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    UserPageButton { }
                    PageButton { text: "General"; icon: "systemsettings" }
                    PageButton { text: "Display"; icon: "video-display" }
                    PageButton { text: "Appearance"; icon: "preferences-desktop-display-color" }
                    PageButton { text: "Network"; icon: "applications-network" }
                    PageButton { text: "Bluetooth"; icon: "bluetooth" }
                    PageButton { text: "Sound"; icon: "preferences-sound" }
                    PageButton { text: "Notifications"; icon: "notifyconf" }
                    PageButton { text: "About"; icon: "stock_about" }
                }
            }
            ColumnLayout {
                anchors.fill: parent
            }
        }

        Rectangle {
            anchors.left: pageIndicator.right
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: palette.base
            SwipeView {
                anchors.fill: parent
                id: swipeView
                orientation: Qt.Vertical
                currentIndex: Root.State.controlPanelPage

                Text {text: "hi"}
                Pages.Monitors {}
            }
        }
    }



}
