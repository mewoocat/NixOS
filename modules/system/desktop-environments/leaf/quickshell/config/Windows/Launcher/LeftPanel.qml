import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs as Root
import qs.Services as Services
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls
import qs.Components.Shared.SequentialDragGrid as SeqDragGrid

// Left side panel
ColumnLayout {
    id: root

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

            Shared.PopupWindow {
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
