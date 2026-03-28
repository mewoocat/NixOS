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
import qs.Modules.Leaf as Leaf
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls
import qs.Modules.Leaf.SequentialDragGrid as SeqDragGrid

Leaf.PanelWindow {
    // Doesn't seem to force focus
    //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    id: launcher
    name: "launcher"
    visible: Root.State.launcherVisibility
    anchors {
        top: true
        left: true
    }
    implicitWidth: 420
    implicitHeight: 640
    focusable: true

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
                    delegate: Shared.PanelButton {
                        id: appPanelItem
                        required property var modelData
                        property string appId: modelData
                        property DesktopEntry desktopEntry: Services.Applications.findDesktopEntryById(appId)
                        icon.name: if (!desktopEntry) { return '' } else { return desktopEntry.icon ?? desktopEntry.id }
                        isMultiColorIcon: true

                        onClicked: () => { if (!desktopEntry) { return () => {} } else { return desktopEntry.execute } }
                        ContextMenu.onRequested: position => { // on right click
                            console.debug(position)
                            appPanelPopup.visible = true
                        }

                        Leaf.PopupWindow {
                            id: appPanelPopup

                            anchor {
                                item: appPanelItem
                                edges: Edges.Top | Edges.Right
                                gravity: Edges.Bottom | Edges.Right
                            }

                            content: ColumnLayout {
                                spacing: 0
                                Ctrls.MenuItem { hoverEnabled: false; text: appPanelItem.desktopEntry?.name ?? "error: desktop entry not found"}
                                Ctrls.MenuItem { text: "Remove"; onClicked: () => {
                                    console.log(`pinned apps: ${Root.State.config.pinnedApps}`)
                                    // Need to close the window before the delegate that created this popup window gets destroyed by removing it from the model
                                    // TODO: Probably need to find a way to automatically do this
                                    appPanelPopup.closeWindow()
                                    Root.State.config.pinnedApps = Root.State.config.pinnedApps.filter(appId => appId != appPanelItem.appId)
                                    Root.State.configFileView.writeAdapter()

                                }; icon.name: "remove"}
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
            
            AppList {
                onAppSelected: app => root.launchApp(app)
            }
        }
    }
}


