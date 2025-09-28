pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland
import qs as Root
import qs.Services as Services
import qs.Modules.Common as Common

Common.PanelWindow {
    // Doesn't seem to force focus
    //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    id: launcher
    name: "launcher"
    property string searchText: "" // Stores the current search
    visible: Root.State.launcherVisibility
    anchors {
        top: true
        left: true
    }
    margins {
        left: 16
        top: 16
    }
    focusable: true // Enable keyboard focus
    implicitWidth: 420
    implicitHeight: 720
    
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

    content: Item {
        anchors.fill: parent
        RowLayout {
            spacing: 0
            anchors.fill: parent

            // Left side panel
            ColumnLayout {
                Layout.margins: 4
                Layout.fillHeight: true
                spacing: 0

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
                                // Only window or item should be set at a time, otherwise a crash can occur
                                //window: launcher
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
                        onClicked: {
                            Root.State.settings.openWindow()
                            launcher.closeWindow()
                        }
                        imgPath: Quickshell.iconPath('application-menu-symbolic')
                        imgSize: 24
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
                                //window: launcher
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
                Common.VScrollable {
                    id: scrollable
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    content: ListView {
                        id: listView
                        interactive: false // Disable flicking input, since parent scrollable handles this
                        implicitHeight: contentHeight
                        spacing: 0
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
                        delegate: LauncherItem {
                            launcher: launcher
                            parentScrollable: scrollable
                        }
                    }
                }
            }
        }
    }
}


