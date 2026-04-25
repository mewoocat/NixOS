pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Networking
import qs as Root
import qs.Services as Services
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared

PageBase {
    pageName: "Network"
    headerContent: RowLayout {
        Switch {
            checked: Networking.wifiEnabled ?? false
            onClicked: Networking.wifiEnabled = checked
        }
        IconImage {
            implicitSize: 18
            source: Quickshell.iconPath(Networking.wifiEnabled ? "network-bluetooth-symbolic" : "network-bluetooth-inactive-symbolic")
        }
    }
    content: Shared.ScrollableView {
        id: scrollable
        anchors.fill: parent
        contentPadding: 0
        showBackground: false

        // Width should be determined by the scrollable - any padding
        // Then the children in the layout should be constrained by this size
        ColumnLayout {
            id: col
            spacing: 0

            // Forces the layout to have a width of this element since it's the largest
            // All other siblings can then Layout.fillWidth: true to also become the same width
            //Item { implicitWidth: col.width }

            // Paired Devices
            SubSection {
                name: "Wifi Networks"
                content: Ctrls.Button {
                    icon.name: "view-refresh-symbolic"
                    onClicked: () => Services.Networking.wifiInterface.scannerEnabled = true
                }
            }

            Shared.ScrollableList {
                id: pariredListView
                implicitWidth: parent.implicitWidth 
                // implicit height defaults to full height of children
                interactable: false
                model: Services.Networking.wifiInterface.networks
                delegate: Shared.ListItemExpandable {

                    id: pairedListItem
                    implicitWidth: pariredListView.width - pariredListView.padding * 2
                    margin: 2
                    padding: 2
                    contentMargin: 0
                    listView: pariredListView
                    required property WifiNetwork modelData
                    backgroundColor: pairedListItem.interacted ? Root.State.colors.surface_container : "transparent"
                    mainColor: pairedListItem.interacted ? Root.State.colors.primary : "transparent"
                    onClicked: () => {
                    }
                    mainDelegate: APMain {
                        modelData: pairedListItem.modelData
                        scrollItem: pairedListItem
                    }
                    subDelegate: APSub {
                        modelData: pairedListItem.modelData
                        scrollItem: pairedListItem
                    }
                }
            }
        }
    }

    component APMain: RowLayout {
        id: mainDelegate
        spacing: 8
        // Set by the ListViewScrollable
        property WifiNetwork modelData: null
        property var scrollItem: null

        Shared.Icon {
            Layout.leftMargin: 4
            implicitSize: 24
            color: mainDelegate.scrollItem.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
            source: Quickshell.iconPath(Services.Networking.getWifiIconName(modelData), "network-wireless-disconnected")
        }
        ColumnLayout {
            spacing: 0
            Text {
                id: name
                Layout.fillWidth: true
                color: mainDelegate.scrollItem.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
                elide: Text.ElideRight
                text: mainDelegate.modelData.name
            }
            RowLayout {
                Text {
                    id: status
                    opacity: 0.6
                    elide: Text.ElideRight
                    font.pointSize: 8
                    text: ConnectionState.toString(mainDelegate.modelData.state)
                }
                RowLayout {
                    spacing: 0
                    /*
                    IconImage {
                        implicitSize: 12
                        source: Quickshell.iconPath("battery-100-symbolic")
                    }
                    */
                    Text {
                        id: battery
                        Layout.fillWidth: true
                        color: mainDelegate.scrollItem.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
                        opacity: 0.6
                        font.pointSize: 8
                        text: "test"
                    }
                }
            }
        }
        Ctrls.Button {
            id: expandBtn
            visible: mainDelegate.scrollItem.interacted
            icon.name: "view-more-symbolic"
            onClicked: () => mainDelegate.scrollItem.expanded = !mainDelegate.scrollItem.expanded
            backgroundColor: expandBtn.hovered ? Root.State.colors.primary_container : "transparent"
            icon.color: expandBtn.hovered ? Root.State.colors.on_primary_container : Root.State.colors.on_primary
        }
    }
    
    component APSub: ColumnLayout {
        id: subDelegate
        // These are injected by the ListViewScrollable
        required property WifiNetwork modelData
        required property var scrollItem

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Ctrls.Button {
            }
            Ctrls.Button {
            }
        }
        Text {
            Layout.fillWidth: true
            color: palette.text
            font.pointSize: 10
            wrapMode: Text.Wrap
            text: "name: "
        }
    }
}
