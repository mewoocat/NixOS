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
                    model: Root.State.config.pinnedApps
                    onModelUpdated: (newModel) => {
                        Root.State.config.pinnedApps = newModel
                    }
                    delegate: SidePanelItem {
                        required property var modelData
                        property string appId: modelData
                        property DesktopEntry desktopEntry: Services.Applications.findDesktopEntryById(appId)
                        imgName: desktopEntry.icon ?? desktopEntry.id 
                        action: desktopEntry.execute
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

                    mainDelegate: RowLayout {
                        id: mainDelegate

                        // Set by the ListViewScrollable
                        property DesktopEntry modelData: null
                        property var scrollItem: null

                        property alias app: mainDelegate.modelData

                        Component.onCompleted: console.log(`main data: ${modelData}`)
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
                                //color: mouseArea.containsMouse || mouseArea.focus || mouseArea.expanded ? palette.highlightedText : palette.placeholderText
                                color: palette.text
                                font.pointSize: 8
                            }
                        }
                        // Used to enforce the height of the show more button when it's invisible
                        Item { implicitHeight: showMoreBtn.buttonHeight }
                        Common.NormalButton {
                            id: showMoreBtn
                            visible: mainDelegate.scrollItem.interacted && mainDelegate.app.actions.length > 0
                            Layout.alignment: Qt.AlignRight
                            iconName: "view-more"
                            leftClick: () => mouseArea.expanded = !mouseArea.expanded
                            defaultIconColor: palette.highlightedText
                            activeIconColor: palette.text
                            recolorIcon: true
                        }
                    }
                    
                    subDelegate: Rectangle {
                        property var modelData
                        visible: false
                        color: "red"
                        // These need to be implicit sizes if parent will be WrapperItem
                        width: 60
                        height: 60
                        Component.onCompleted: console.log(`subDelegate modelData: ${modelData}`)
                        Rectangle {
                            width: 30
                            height: 30
                            color: "blue"
                        }
                        Text {text: modelData}
                    }
                }
            }
        }
    }
}


