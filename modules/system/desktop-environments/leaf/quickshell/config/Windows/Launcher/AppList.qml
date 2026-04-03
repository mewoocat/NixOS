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
        //Layout.fillWidth: true
        leftPadding: 12; rightPadding: 12
        // Make this have focus by default
        // Trying to ensure this item is the last to set focus so it actually recieves focus.
        // Otherwise if any other item is interacted in the window it will also get focus set to
        // true and it stays that way unless manually unset (i think).
        onVisibleChanged: () => focus = true
        focus: true
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
        Keys.onReturnPressed: root.appSelected(scrollable.listViewRef.currentItem.modelData)
    }

    // Application list
    Shared.ScrollableList {
        id: scrollable
        Layout.fillHeight: true
        padding: 8
        //onPrimaryClick: (modelData) => root.appSelected(modelData)
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

        delegate: Shared.ListItemExpandable
        {
            id: appItem
            required property DesktopEntry modelData
            property DesktopEntry desktopEntry: modelData
            property bool isHighlighted: interacted || ListView.isCurrentItem
            margin: 2
            padding: 2
            contentMargin: 0
            listView: scrollable
            implicitWidth: 300
            backgroundColor: "transparent"
            mainColor: isHighlighted ? Root.State.colors.primary : "transparent"

            onClicked: root.appSelected(modelData)

            // Main content
            mainDelegate: RowLayout {
                id: mainDelegate
                anchors.fill: parent
                // Warning: this icon lookup is expensive on the startup time
                IconImage {
                    Layout.leftMargin: 4
                    id: icon
                    implicitSize: 32
                    source: Quickshell.iconPath(appItem.desktopEntry.icon, "dialog-question")
                }
                ColumnLayout {
                    spacing: 0
                    Text{
                        Layout.fillWidth: true
                        leftPadding: 8
                        rightPadding: 8
                        elide: Text.ElideRight // Truncate with ... on the right
                        text: appItem.desktopEntry.name
                        color: appItem.isHighlighted ? Root.State.colors.on_primary : Root.State.colors.on_surface
                    }
                    Text {
                        Layout.fillWidth: true
                        leftPadding: 8
                        rightPadding: 8
                        elide: Text.ElideRight // Truncate with ... on the right
                        text: Services.Applications.getAppDescription(appItem.desktopEntry)
                        color: appItem.isHighlighted ? Root.State.colors.on_primary : Root.State.colors.on_surface
                        font.pointSize: 8
                    }
                }
                Ctrls.Button {
                    id: showMoreBtn
                    visible: appItem.interacted //&& mainDelegate.app.actions.length > 0
                    Layout.alignment: Qt.AlignRight
                    icon.name: "overflow-menu-symbolic"
                    icon.width: 16
                    icon.height: 16
                    onClicked: () => appItem.expanded = !appItem.expanded
                    icon.color: hovered ? Root.State.colors.on_primary_container : Root.State.colors.on_primary
                    backgroundColor: hovered ? Root.State.colors.primary_container : "transparent"
                }
            }
            
            // Expanded content
            subDelegate: ColumnLayout {
                id: subDelegate
                spacing: 0
                // These are injected by the ListViewScrollable

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
                Shared.HorizontalLine { visible: subDelegate.modelData.actions.length > 0 }
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
}
