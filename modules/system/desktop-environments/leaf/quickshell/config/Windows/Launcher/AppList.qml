import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs as Root
import qs.Services as Services
import qs.Modules.Leaf as Leaf
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls

// Search and app list
ColumnLayout {
    id: root
    spacing: 0
    property string searchText: "" // Stores the current search

    function reset() {
        searchText = "" 
        textField.text = ""
        scrollable.listViewRef.currentIndex = 0
    }
    signal appSelected(app: DesktopEntry)

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
            color: Root.State.colors.surface_container
            radius: 16
        }
        onTextChanged: () => {
            root.searchText = text
            scrollable.listViewRef.currentIndex = 0
        }
        Keys.onUpPressed: scrollable.listViewRef.decrementCurrentIndex()
        Keys.onDownPressed: scrollable.listViewRef.incrementCurrentIndex()
        Keys.onReturnPressed: appSelected(scrollable.listViewRef.currentItem.modelData)
    }

    // Application list
    Leaf.ListViewScrollable {
        id: scrollable
        Layout.fillWidth: true
        Layout.fillHeight: true
        padding: 8
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
                    color: scrollItem.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
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
                    color: scrollItem.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
                    font.pointSize: 8
                }
            }
            Ctrls.Button {
                id: showMoreBtn
                visible: mainDelegate.scrollItem.interacted //&& mainDelegate.app.actions.length > 0
                Layout.alignment: Qt.AlignRight
                icon.name: "overflow-menu-symbolic"
                icon.width: 16
                icon.height: 16
                onClicked: () => scrollItem.expanded = !scrollItem.expanded
                icon.color: hovered ? Root.State.colors.on_primary_container : Root.State.colors.on_primary
                backgroundColor: hovered ? Root.State.colors.primary_container : "transparent"
            }
        }
        
        // Expanded content
        subDelegate: ColumnLayout {
            id: subDelegate
            spacing: 0
            // These are injected by the ListViewScrollable
            required property DesktopEntry modelData
            required property var scrollItem

            Repeater {
                model: subDelegate.modelData.actions
                // Maybe should make this type more generic (since it works for a non popup menu scenario)
                delegate: Ctrls.MenuItem {
                    required property DesktopAction modelData
                    implicitWidth: parent.width
                    text: modelData.name
                    onClicked: () => modelData.execute()
                }
            }
            Leaf.HorizontalLine { visible: subDelegate.modelData.actions.length > 0 }
            RowLayout {
                Ctrls.Button {
                    text: "Pin"
                    icon.name: "pin"
                    onClicked: () => {
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
