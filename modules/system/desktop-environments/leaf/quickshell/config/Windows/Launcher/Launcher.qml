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
    implicitHeight: 640
    
    closeWindow: () => {
        Root.State.launcherVisibility = false
        searchText = "" 
        textField.text = ""
        scrollable.listViewRef.currentIndex = 0
    }

    toggleWindow: () => {
        Root.State.launcherVisibility = !Root.State.launcherVisibility
        searchText = "" 
        textField.text = ""
        scrollable.listViewRef.currentIndex = 0
    }

    function launchApp(app: DesktopEntry) {
        console.log(`Launching app: ${app.id}`)
        Services.Applications.incrementFreq(app.id) // Update it's frequency
        app.execute()
        launcher.closeWindow() // Needs to be after the execute since this will reset the current index?
    }

    content: Item {
        id: mainItem
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
                    //Layout.fillHeight: true
                    Repeater {
                        model: Root.State.config.pinnedApps
                        delegate: AppSidePanelItem {
                            toplevel: mainItem
                        }
                    }
                }
                Item { Layout.fillHeight: true; } // Push the siblings to the top and bottom

                // Bottom
                ColumnLayout {
                    spacing: 0
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    
                    PowerButton {}
                    SettingsButton {}
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
                spacing: 0
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Search field
                    TextField {
                        id: textField
                        implicitHeight: 32
                        Layout.margins: 8
                        Layout.fillWidth: true
                        leftPadding: 12; rightPadding: 12
                        focus: true // Make this have focus by default
                        placeholderText: "Search..."
                        background: Rectangle {
                            color: palette.active.base
                            radius: 16
                        }
                        onTextChanged: () => {
                            launcher.searchText = text
                            scrollable.listViewRef.currentIndex = 0
                        }
                        Keys.onUpPressed: scrollable.listViewRef.decrementCurrentIndex()
                        Keys.onDownPressed: scrollable.listViewRef.incrementCurrentIndex()
                        Keys.onReturnPressed: launchApp(scrollable.listViewRef.currentItem.modelData)
                    }

                // Application list
                Common.ListViewScrollable {
                    id: scrollable
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: ScriptModel {
                        values: DesktopEntries.applications.values
                            // Filter by search text
                            .filter(app => {
                                const formattedSearchText = searchText.toLowerCase()
                                if (app.name.toLowerCase().includes(formattedSearchText)) return true
                                if (app.genericName.toLowerCase().includes(formattedSearchText)) return true
                                app.categories.forEach(category => {
                                    if (category.toLowerCase().includes(formattedSearchText)) return true
                                })
                                return false // App should be filtered out
                            })
                            // Sort by most frequently launched
                            .sort((appA, appB) => {
                                const appFreqMap = Services.Applications.appFreqMap 
                                const appAFreq = appFreqMap[appA.id] ? appFreqMap[appA.id] : 0
                                const appBFreq = appFreqMap[appB.id] ? appFreqMap[appB.id] : 0
                                if (appAFreq > appBFreq) return -1
                                if (appAFreq < appBFreq) return 1
                                return 0 // They are equal
                            })
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


