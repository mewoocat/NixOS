
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
    property SwipeView settingsView: null

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
                Layout.fillWidth: true
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
                required property int pageIndex
                required property string text
                required property string icon
                enabled: true
                hoverEnabled: true
                Layout.fillWidth: true
                implicitHeight: 48
                onClicked: () => {
                    root.settingsView.setCurrentIndex(pageIndex)    
                }
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

            ScrollView {
                id: listView
                anchors.fill: parent
                anchors.margins: 16
                clip: true // Ensure that scrolled items don't go outside the widget
                ScrollBar.vertical: ScrollBar {
                    id: scrollBar
                    parent: listView.parent
                    anchors.left: listView.right
                    anchors.top: listView.top
                    anchors.bottom: listView.bottom
                }

                //implicitWidth: content.width
                //implicitHeight: content.height
                ColumnLayout {
                    id: content
                    anchors.left: parent.left
                    anchors.right: parent.right
                    UserPageButton { }
                    PageButton { pageIndex: 0; text: "General"; icon: "systemsettings" }
                    PageButton { pageIndex: 1; text: "Display"; icon: "video-display" }
                    PageButton { pageIndex: 2; text: "Appearance"; icon: "preferences-desktop-display-color" }
                    PageButton { pageIndex: 3; text: "Network"; icon: "applications-network" }
                    PageButton { pageIndex: 4; text: "Bluetooth"; icon: "bluetooth" }
                    PageButton { pageIndex: 5; text: "Sound"; icon: "preferences-sound" }
                    PageButton { pageIndex: 6; text: "Notifications"; icon: "notifyconf" }
                    PageButton { pageIndex: 7; text: "About"; icon: "stock_about" }
                }
            }
        }

        Rectangle {
            anchors.left: pageIndicator.right
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: palette.window
            SwipeView {
                anchors.fill: parent
                //interactive: false
                id: swipeView
                orientation: Qt.Vertical
                currentIndex: Root.State.controlPanelPage
                Component.onCompleted: () => {
                    root.settingsView = swipeView
                }

                // It appears these children are auto given the parent's size?
                Pages.General {}
                Pages.Monitors {}
                Pages.Appearance {}
                Pages.Network {}
                Pages.Bluetooth {}
                Pages.Sound {}
                Pages.Notifications {}
                Pages.About {}
            }
        }
    }



}
