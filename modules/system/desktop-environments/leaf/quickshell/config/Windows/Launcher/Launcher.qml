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
                
                // Pinned apps
                GridView {
                    id: gridView
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    component Tile: DropArea {
                        id: panel
                        required property string modelData
                        required property int index
                        onEntered: (drag) => {
                          //console.log('drag ' + drag.source.modelData + ' ' + (drag.source as Tile).index)
                          delegateModel.items.move((drag.source as Tile).index, panel.index, 1) // TODO: this causes the launcher to not open
                        }
                        property var originalParent: "what"
                        DragHandler {
                          id: dragHandler
                          target: panel
                          // manually modifying the parent when dragged
                          /*
                          onActiveChanged: {
                            if (active) {
                              console.log(`active: ${panel.parent}`)
                              console.log(`panel.x = ${panel.x}`) 
                              originalParent = panel.parent
                              console.log(`panel.x = ${panel.x}`) 
                              panel.parent = gridView
                            }
                            else {
                              console.log(`inactive: ${panel.parent}`)
                              panel.parent = originalParent
                            }
                          }
                          */
                        }

                        states: [
                          State {
                            when: dragHandler.active
                            ParentChange { 
                              target: panel
                              parent: gridView
                            }
                          }
                        ]

                        // In order for this item to emit drag events, the active state of this attached
                        // property needs to be bound to the drag handler.
                        Drag.active: dragHandler
                        Drag.source: panel
                        //Drag.hotSpot: Qt.point(width/2, height/2)
                        Rectangle {
                            anchors.fill: parent 
                            Text {
                              text: panel.modelData
                            }
                        }
                    }

                    // Using a DelegateModel so that we can take advantage of the attached itemsIndex property and 
                    // move() method on the items (DelegateModelGroup) property
                    model: DelegateModel {
                      id: delegateModel
                      model: ["foot", "vesktop", "nautilus"]
                      delegate: Tile {
                        implicitWidth: gridView.width
                        implicitHeight: gridView.width
                        index: DelegateModel.itemsIndex // TODO: is this how to access an attached property?
                      }
                    }
                }

                // Top
                // Pinned apps
                /*
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
                */
                /*
                Common.PanelGridDragable {
                    id: pinnedAppGrid
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    unitSize: 64
                    rows: 5
                    columns: 1
                    Repeater {
                        // Converts the pinned apps from a map to array
                        //property var pinnedAppArray: {
                        //    let array = []
                        //    const appMap = Root.State.config.pinnedApps
                        //    for (let i = 0; i < 5; i++) {
                        //        const app = appMap[i]
                        //        console.log(`app: ${app}`)
                        //        array.push(app)
                        //    }
                        //    console.log(`poop: ${array}`)
                        //    return array
                        //}
                        model: ["foot", "vesktop", "vesktop", "foot", "foot"]
                        // TODO: should make the app side panel item a sub class of PanelItem and delgate drag handling to the PanelItem type
                        delegate: Common.PanelItemDragable {
                            required property string modelData
                            id: appItem
                            isClickable: false; 
                            rows: 1
                            columns: 1
                            content: Loader {
                                property Component placeholder: PanelItemPlaceholder {}
                                property Component app: BoundComponent {
                                    sourceComponent: AppSidePanelItem {}
                                    property Item toplevel: mainItem
                                    property string appId: appItem.modelData
                                }
                                sourceComponent: modelData ? app : placeholder
                            }
                        }
                    }
                }
                */

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


