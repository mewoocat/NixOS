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
import qs.Modules.Common.SequentialDragGrid as SeqDragGrid

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

                SeqDragGrid.SequentialDragGrid {
                    id: grid
                    Layout.fillHeight: true
                    property var pinnedApps: Root.State.config.pinnedApps
                    model: ScriptModel { values: Root.State.config.pinnedApps }
                    onModelUpdated: (newModel) => {
                        Root.State.config.pinnedApps = newModel.values
                        Root.State.configFileView.writeAdapter()
                    }
                    delegate: SidePanelItem {
                        id: appPanelItem
                        required property var modelData
                        property string appId: modelData
                        property DesktopEntry desktopEntry: Services.Applications.findDesktopEntryById(appId)
                        imgName: if (!desktopEntry) { return '' } else { return desktopEntry.icon ?? desktopEntry.id }

                        onLeftClick: () => { if (!desktopEntry) { return () => {} } else { return desktopEntry.execute } }
                        onRightClick: () => { appPanelPopup.visible = true }

                        Common.PopupWindow {
                            id: appPanelPopup

                            anchor {
                                item: appPanelItem
                                edges: Edges.Top | Edges.Right
                                gravity: Edges.Bottom | Edges.Right
                            }

                            content: ColumnLayout {
                                Text { color: palette.text; text: appPanelItem.desktopEntry.name }
                                Common.PopupMenuItem { text: "Remove"; action: () => {
                                    console.log(`pinned apps: ${Root.State.config.pinnedApps}`)
                                    // Need to close the window before the delegate that created this popup window gets destroyed by removing it from the model
                                    // TODO: Probably need to find a way to automatically do this
                                    appPanelPopup.closeWindow()
                                    Root.State.config.pinnedApps = Root.State.config.pinnedApps.filter(appId => appId != appPanelItem.appId)
                                    Root.State.configFileView.writeAdapter()

                                }; iconName: "remove"}
                            }
                        }
                    }
                }
                
                // Bottom
                ColumnLayout {
                    spacing: 0
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    
                    PowerButton {}
                    SettingsButton {}
                    ProfileButton {}
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
                    onPrimaryClick: (modelData) => launchApp(modelData)
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

                    // Main content
                    mainDelegate: RowLayout {
                        id: mainDelegate

                        // Set by the ListViewScrollable
                        property DesktopEntry modelData: null
                        property var scrollItem: null

                        property alias app: mainDelegate.modelData

                        anchors.fill: parent
                        // Warning: this icon lookup is expensive on the startup time
                        IconImage {
                            Layout.leftMargin: 4
                            id: icon
                            implicitSize: 32
                            source: Quickshell.iconPath(mainDelegate.app.icon, "dialog-question")
                        }
                        ColumnLayout {
                            spacing: 0
                            Text{
                                Layout.fillWidth: true
                                leftPadding: 8
                                rightPadding: 8
                                elide: Text.ElideRight // Truncate with ... on the right
                                text: mainDelegate.app.name
                                //color: mouseArea.containsMouse || mouseArea.focus ? palette.highlightedText : palette.text
                                color: palette.text
                            }
                            Text{
                                Layout.fillWidth: true
                                leftPadding: 8
                                rightPadding: 8
                                elide: Text.ElideRight // Truncate with ... on the right
                                text: {
                                    if (mainDelegate.app.genericName !== "" && mainDelegate.app.comment !== "") {
                                        return mainDelegate.app.genericName + " | " + mainDelegate.app.comment
                                    }
                                    else if (mainDelegate.app.genericName !== "") {
                                        return mainDelegate.app.genericName
                                    }
                                    else if (mainDelegate.app.comment !== "") {
                                        return mainDelegate.app.comment
                                    }
                                    else {
                                        return "No description"
                                    }
                                }
                                color: palette.text
                                font.pointSize: 8
                            }
                        }
                        // Used to enforce the height of the show more button when it's invisible
                        Item { implicitHeight: showMoreBtn.buttonHeight }
                        Common.NormalButton {
                            id: showMoreBtn
                            visible: mainDelegate.scrollItem.interacted //&& mainDelegate.app.actions.length > 0
                            Layout.alignment: Qt.AlignRight
                            iconName: "view-more"
                            leftClick: () => scrollItem.expanded = !scrollItem.expanded
                            defaultIconColor: palette.highlightedText
                            activeIconColor: palette.text
                            activeBgColor: palette.alternateBase
                            recolorIcon: true
                        }
                    }
                    
                    // Expanded content
                    subDelegate: ColumnLayout {
                        id: subDelegate
                        // These are injected by the ListViewScrollable
                        required property DesktopEntry modelData
                        required property var scrollItem

                        Repeater {
                            model: subDelegate.modelData.actions
                            // Maybe should make this type more generic (since it works for a non popup menu scenario)
                            delegate: Common.SubMenuItem {
                                required property DesktopAction modelData
                                text: modelData.name
                                action: modelData.execute
                                iconName: ""
                            }
                        }
                        Common.HorizontalLine { visible: subDelegate.modelData.actions.length > 0 }
                        RowLayout {
                            Common.NormalButton {
                                text: "Pin"
                                iconName: "pin"
                                leftClick: () => {
                                    const pinnedApps = Root.State.config.pinnedApps
                                    const isAppPinned = pinnedApps.find(appId => appId == subDelegate.modelData.id)
                                    if (!isAppPinned) {
                                        pinnedApps.push(subDelegate.modelData.id)
                                    }

                                    // Need to set the pinnedApps value to something new to force consumers of it to update.
                                    // Otherwise the actual value won't change since it's a reference.  And the consumers
                                    // won't know to update.
                                    Root.State.config.pinnedApps = null
                                    Root.State.config.pinnedApps = pinnedApps
                                    Root.State.configFileView.writeAdapter()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


