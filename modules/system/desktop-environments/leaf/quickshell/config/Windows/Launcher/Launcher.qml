pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Wayland

import "../../" as Root
import "../../Modules/Common" as Common
import "../../Modules" as Modules
import "../../Services" as Services

Common.PopupWindow {
    // Doesn't seem to force focus
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    id: launcher
    name: "launcher"
    // Stores the current search
    property string searchText: ""
    
    closeWindow: () => {
        Root.State.launcherVisibility = false
        searchText = "" 
        textField.text = ""
        listView.currentIndex = 0
    }

    toggleWindow: () => {
        Root.State.launcherVisibility = !Root.State.launcherVisibility
        searchText = "" 
        textField.text = ""
        listView.currentIndex = 0
    }
    visible: Root.State.launcherVisibility
    anchors {
        top: true
        left: true
    }
    focusable: true // Enable keyboard focus
    implicitWidth: 400
    implicitHeight: 460
    color: "transparent"
    margins {
        left: 16
        top: 16
    }
    content: Rectangle {
        anchors.fill: parent
        //color: "#aa000000"
        color: palette.window
        radius: 12
        RowLayout {
            spacing: 0
            anchors.fill: parent

            // Left side panel
            ColumnLayout {
                Layout.margins: 8
                Layout.fillHeight: true
                spacing: 0

                //Rectangle {implicitWidth: 32;Layout.fillHeight: true;color: "red"}
                // Top
                ColumnLayout { 
                    spacing: 0
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.fillHeight: true
                    SidePanelItem {
                        imgPath: Quickshell.iconPath('systemsettings')
                    }
                    SidePanelItem {
                        imgPath: Quickshell.iconPath('systemsettings')
                    }

                }
                Item {Layout.fillHeight: true;} // Idk why, but needed to push the siblings to the top and bottom
                // Bottom
                ColumnLayout {
                    spacing: 0
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    
                    SidePanelItem {
                        onClicked: Root.State.settings.openWindow()
                        imgPath: Quickshell.iconPath('systemsettings')
                    }
                    SidePanelItem {
                        imgPath: Services.User.pfpPath
                    }
                    
                    // pfp
                    WrapperMouseArea {
                        id: root
                        enabled: true
                        hoverEnabled: true
                        onClicked: console.log("clicked")
                        margin: 4
                        WrapperRectangle {
                            margin: 4
                            radius: 12
                            //color: root.containsMouse ? palette.highlight : palette.base
                            color: "transparent"
                            Modules.ProfilePicture {

                            }
                        }
                    }

                    //Rectangle {implicitWidth: 32;implicitHeight: 32;color: "red"}

                    //Modules.ProfilePicture {
                    //    implicitWidth: 40
                    //    implicitHeight: 40
                    //}
                }
            }

            // Search and app list
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Search field
                Rectangle {
                    color: "transparent"
                    implicitHeight: 48
                    Layout.fillWidth: true
                    //Layout.fillHeight: true
                    TextField {
                        id: textField
                        focus: true // Make this have focus by default
                        placeholderText: "Search..."
                        anchors.margins: 8
                        anchors.fill: parent
                        leftPadding: 12
                        rightPadding: 12
                        background: Rectangle {
                            color: palette.active.base
                            radius: 16
                        }
                        onTextChanged: () => {
                            launcher.searchText = text
                            listView.currentIndex = 0
                        }
                        Keys.onUpPressed: {
                            listView.decrementCurrentIndex()
                        }
                        Keys.onDownPressed: {
                            listView.incrementCurrentIndex()
                        }
                        Keys.onReturnPressed: {
                            listView.currentItem.modelData.execute()
                            launcher.toggleWindow() // Needs to be after the execute since this will reset the current index
                        }
                    }
                }

                // Application list
                ListView {
                    highlightMoveDuration: 0
                    clip: true // Ensure that scrolled items don't go outside the widget
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    //cacheBuffer: 0
                    maximumFlickVelocity: 1000 // Increases bound overshoot?
                    id: listView
                    keyNavigationEnabled: true
                    model: ScriptModel {
                        values: DesktopEntries.applications.values
                            // Filter by search text
                            .filter(app => {
                                const formattedSearchText = searchText.toLowerCase()
                                if (app.name.toLowerCase().includes(formattedSearchText)) {
                                    return true
                                }
                                if (app.genericName.toLowerCase().includes(formattedSearchText)) {
                                    return true
                                }
                                app.categories.forEach(category => {
                                    if (category.toLowerCase().includes(formattedSearchText)) {
                                        return true
                                    }
                                })
                                return false
                            })
                            // Sort by most frequently launched
                            .sort((appA, appB) => {
                                const appFreqMap = Services.Applications.appFreqMap 
                                const appAFreq = appFreqMap[appA.id] ? appFreqMap[appA.id] : 0
                                const appBFreq = appFreqMap[appB.id] ? appFreqMap[appB.id] : 0
                                if (appAFreq > appBFreq) {
                                    return -1
                                }
                                if (appAFreq < appBFreq) {
                                    return 1
                                }
                                return 0 // They are equal
                            })
                            //.filter(app => true)
                    }

                    snapMode: ListView.SnapToItem
                    // Add a scroll bar to the list
                    // idk where this ScrollBar.vertical property is defined
                    ScrollBar.vertical: ScrollBar { }

                    delegate: MouseArea {
                        id: mouseArea
                        required property DesktopEntry modelData
                        height: 60
                        width: listView.width
                        hoverEnabled: true
                        onClicked: {
                            Root.State.launcher.closeWindow()
                            Services.Applications.incrementFreq(modelData.id)
                            modelData.execute()
                        }
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
                                    Layout.leftMargin: 8
                                    id: icon
                                    implicitSize: 32
                                    source: Quickshell.iconPath(mouseArea.modelData.icon)
                                }
                                Text{
                                    Layout.fillWidth: true
                                    leftPadding: 8
                                    rightPadding: 8
                                    elide: Text.ElideRight // Truncate with ... on the right
                                    text: mouseArea.modelData.name
                                    color: palette.text
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


