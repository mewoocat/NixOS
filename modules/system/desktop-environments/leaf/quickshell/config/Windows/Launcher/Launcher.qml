pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

import "../../" as Root
import "../../Modules/Common" as Common
import "../../Modules" as Modules
import "../../Services" as Services

Common.PanelWindow {
    // Doesn't seem to force focus
    //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
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


    function launchApp(app: DesktopEntry) {
        console.log(`Launching app: ${app.id}`)
        Services.Applications.incrementFreq(app.id) // Update it's frequency
        app.execute()
        launcher.closeWindow() // Needs to be after the execute since this will reset the current index?
    }

    visible: Root.State.launcherVisibility
    anchors {
        top: true
        left: true
    }
    focusable: true // Enable keyboard focus
    implicitWidth: 400
    implicitHeight: 600
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
                Layout.margins: 4
                Layout.fillHeight: true
                spacing: 0

                //Rectangle {implicitWidth: 32;Layout.fillHeight: true;color: "red"}
                // Top
                // Pinned apps
                ColumnLayout { 
                    spacing: 0
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.fillHeight: true
                    Repeater {
                        model: Root.State.config.pinnedApps
                        delegate: SidePanelItem {
                            id: item
                            required property string modelData
                            property alias appId: item.modelData // Aliasing a sibling property requires accessing via an id?
                            property DesktopEntry desktopEntry: Services.Applications.findDesktopEntryById(appId)
                            //Component.onCompleted: console.log(`comp app id: ${appId}`)
                            imgPath: Quickshell.iconPath(desktopEntry.icon)
                            action: desktopEntry.execute
                        }
                    }
                }
                Item {Layout.fillHeight: true;} // Idk why, but needed to push the siblings to the top and bottom
                // Bottom
                ColumnLayout {
                    spacing: 0
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    

                    // Power options popup menu
                    // TODO: refractor this into it's own file
                    SidePanelItem {
                        id: power
                        imgPath: Quickshell.iconPath('system-shutdown-symbolic')
                        imgSize: 22
                        action: () => {
                            console.log("click")
                            powerPopup.visible = true
                        }
                        Common.PopupWindow {
                            id: powerPopup

                            anchor {
                                window: launcher
                                item: power
                                edges: Edges.Bottom | Edges.Right
                                gravity: Edges.Top | Edges.Right
                            }

                            content: ColumnLayout {
                                Common.PopupMenuItem { text: "Shutdown"; action: () => Services.Power.shutdown(); iconName: "system-shutdown-symbolic"}
                                Common.PopupMenuItem { text: "Hibernate"; action: () => Services.Power.hibernate(); iconName: "system-shutdown-symbolic"}
                                Common.PopupMenuItem { text: "Restart"; action: () => Services.Power.restart(); iconName: "system-restart-symbolic"}
                                Common.PopupMenuItem { text: "Sleep"; action: () => Services.Power.sleep(); iconName: "system-suspend-symbolic"}
                            }
                        }

                    }
                    SidePanelItem {
                        onClicked: Root.State.settings.openWindow()
                        imgPath: Quickshell.iconPath('application-menu-symbolic')
                    }
                    ProfilePictureItem {
                        id: user
                        onClicked: () => {
                            console.log("click")
                            userPopup.visible = true
                        }
                        Common.PopupWindow {
                            id: userPopup

                            anchor {
                                window: launcher
                                item: user
                                edges: Edges.Bottom | Edges.Right
                                gravity: Edges.Top | Edges.Right
                            }

                            content: ColumnLayout {
                                Text { color: palette.text; text: Services.User.username }
                                Common.PopupMenuItem { text: "User Settings"; action: () => {}; iconName: "application-menu-symbolic"}
                                Common.PopupMenuItem { text: "Logout"; action: () => {}; iconName: "go-previous-symbolic"}
                            }
                        }
                    }
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
                        Keys.onReturnPressed: launchApp(listView.currentItem.modelData)
                    }
                }

                // Application list
                Rectangle {
                    id: listBox
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"

                ListView {
                    //anchors.fill: parent
                    implicitWidth: parent.width - scrollBar.width
                    implicitHeight: parent.height
                    highlightMoveDuration: 0
                    clip: true // Ensure that scrolled items don't go outside the widget
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
                    ScrollBar.vertical: ScrollBar {
                        id: scrollBar
                        parent: listView.parent
                        anchors.left: listView.right
                        anchors.top: listView.top
                        anchors.bottom: listView.bottom
                    }

                    delegate: MouseArea {
                        id: mouseArea
                        required property DesktopEntry modelData
                        height: 48
                        width: listView.width
                        hoverEnabled: true
                        onClicked: launchApp(modelData)
                        Rectangle {
                            anchors.fill: parent
                            anchors {
                                leftMargin: 16
                                rightMargin: 16
                                topMargin: 4
                                bottomMargin: 4
                            }
                            color: mouseArea.containsMouse || mouseArea.focus ? palette.highlight : "transparent"
                            radius: 10
                            RowLayout {
                                anchors.fill: parent
                                IconImage {
                                    Layout.leftMargin: 4
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
}


