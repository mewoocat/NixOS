pragma ComponentBehavior: Bound // allows for referencing of siblings
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules.Leaf as Leaf
import qs as Root

PageBase {
    id: page
    pageName: "Bluetooth"
    headerContent: RowLayout {
        Switch {
            checked: Bluetooth.defaultAdapter.enabled
            onClicked: Bluetooth.defaultAdapter.enabled = checked
        }
        IconImage {
            implicitSize: 18
            source: Quickshell.iconPath(Bluetooth.defaultAdapter.enabled ? "bluetooth-active" : "bluetooth-disabled")
        }
    }

    component BtMain: RowLayout {
        id: mainDelegate
        spacing: 8
        // Set by the ListViewScrollable
        property BluetoothDevice modelData: null
        property var scrollItem: null

        IconImage {
            //Layout.leftMargin: 4
            implicitSize: 24
            source: Quickshell.iconPath(mainDelegate.modelData.icon, "bluetooth") // fallbacks to "bluetooth"
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
                    color: mainDelegate.modelData.connected ?
                        Root.State.colors.green
                        : mainDelegate.scrollItem.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
                    opacity: 0.6
                    elide: Text.ElideRight
                    font.pointSize: 8
                    text: mainDelegate.modelData.paired ? BluetoothDeviceState.toString(mainDelegate.modelData.state) : "Not paired"
                }
                RowLayout {
                    spacing: 0
                    visible: mainDelegate.modelData.batteryAvailable
                    IconImage {
                        implicitSize: 12
                        source: Quickshell.iconPath("battery-100-symbolic")
                    }
                    Text {
                        id: battery
                        Layout.fillWidth: true
                        color: mainDelegate.scrollItem.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
                        opacity: 0.6
                        font.pointSize: 8
                        text: mainDelegate.modelData.batteryAvailable ? (mainDelegate.modelData.battery * 100) + ' %' : "n/a"
                    }
                }
            }
        }
        /*
        Leaf.NormalButton {
            Layout.alignment: Qt.AlignRight
            visible: mainDelegate.scrollItem.interacted
            iconName: "view-more"
            leftClick: () => mainDelegate.scrollItem.expanded = !mainDelegate.scrollItem.expanded
            defaultIconColor: Root.State.colors.on_primary
            activeIconColor: Root.State.colors.on_primary_container
            activeBgColor: Root.State.colors.primary_container
        }
        */
        Leaf.Button {
            id: expandBtn
            visible: mainDelegate.scrollItem.interacted
            icon.name: "view-more"
            onClicked: () => mainDelegate.scrollItem.expanded = !mainDelegate.scrollItem.expanded
            backgroundColor: expandBtn.hovered ? Root.State.colors.primary_container : "transparent"
            icon.color: expandBtn.hovered ? Root.State.colors.on_primary_container : Root.State.colors.on_primary
        }
    }
    
    component BtSub: ColumnLayout {
        id: subDelegate
        // These are injected by the ListViewScrollable
        required property BluetoothDevice modelData
        required property var scrollItem
        Component.onCompleted: console.debug(`btDevice: ${modelData}`)

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Leaf.NormalButton {
                visible: subDelegate.modelData.paired
                text: subDelegate.modelData.connected ? "disconnect" : "connect"
                leftClick: subDelegate.modelData.connected ? subDelegate.modelData.disconnect : subDelegate.modelData.connect
            }
            Leaf.NormalButton {
                text: subDelegate.modelData.paired ? "forget" : "pair"
                leftClick: subDelegate.modelData.paired ? subDelegate.modelData.forget : subDelegate.modelData.pair
            }
        }
        Text {
            Layout.fillWidth: true
            color: palette.text
            font.pointSize: 10
            wrapMode: Text.Wrap
            text: "name: " + subDelegate.modelData.deviceName
        }
        Text {
            Layout.fillWidth: true
            color: palette.text
            font.pointSize: 10
            wrapMode: Text.Wrap
            text: "address: " + subDelegate.modelData.address
        }
        Text {
            Layout.fillWidth: true
            color: palette.text
            font.pointSize: 10
            wrapMode: Text.Wrap
            text: "battery info available: " + subDelegate.modelData.batteryAvailable
        }
    }


    content: Leaf.FlickScrollable {
        id: scrollable
        anchors.fill: parent
        contentPadding: 0
        showBackground: false

        // Width should be determined by the scrollable - any padding
        // Then the children in the layout should be constrained by this size
        content: ColumnLayout {
            anchors.fill: parent
            id: col
            spacing: 0

            // Forces the layout to have a width of this element since it's the largest
            // All other siblings can then Layout.fillWidth: true to also become the same width
            //Item { implicitWidth: col.width }

            // Paired Devices
            SubSection { name: "My Devices" }

            Leaf.ListView {
                id: pariredListView
                implicitWidth: parent.implicitWidth 
                // implicit height defaults to full height of children
                model: ScriptModel {
                    values: Bluetooth.devices.values
                        .filter(device => device.paired)
                        .sort((a, b) => { // Sort connected devices first
                            if (a.connected && b.connected) return 0
                            if (!a.connected && !b.connected) return 0
                            if (a.connected && !b.connected) return -1
                            if (!a.connected && b.connected) return 1
                        })
                }
                delegate: Leaf.ListItemExpandable {
                    id: pairedListItem
                    margin: 2
                    padding: 2
                    contentMargin: 0
                    listView: pariredListView
                    required property BluetoothDevice modelData
                    backgroundColor: pairedListItem.interacted ? Root.State.colors.surface_container : "transparent"
                    mainColor: pairedListItem.interacted ? Root.State.colors.primary : "transparent"
                    onClicked: () => {
                        const btDevice = pairedListItem.modelData
                        if (btDevice.paired) {
                            return btDevice.connected ? btDevice.disconnect() : btDevice.connect()
                        }
                        return btDevice.pair()
                    }
                    mainDelegate: BtMain {
                        modelData: pairedListItem.modelData
                        scrollItem: pairedListItem
                    }
                    subDelegate: BtSub {
                        modelData: pairedListItem.modelData
                        scrollItem: pairedListItem
                    }
                }
            }

            // Nearby Devices
            SubSection { 
                name: "Nearby Devices"
                content: Leaf.Button {
                    Layout.rightMargin: 8 // TODO: find a better solution
                    id: refreshButton
                    icon.name: "view-refresh-symbolic" 
                    onClicked: {
                        console.log(`scannings for bt devices`)
                        Bluetooth.defaultAdapter.discovering = true
                    }
                }
            }

            //Leaf.HorizontalLine { }
            Leaf.ListView {
                id: unpariredListView
                implicitWidth: parent.implicitWidth 
                // implicit height defaults to full height of children
                model: ScriptModel { values: Bluetooth.devices.values.filter(device => !device.paired) }
                delegate: Leaf.ListItemExpandable {
                    id: listItem
                    margin: 2
                    padding: 2
                    contentMargin: 0
                    listView: pariredListView
                    required property BluetoothDevice modelData
                    //backgroundColor: listItem.interacted ? Root.State.colors.primary : "transparent"
                    onClicked: () => {
                        const btDevice = listmodelData
                        if (btDevice.paired) {
                            return btDevice.connected ? btDevice.disconnect() : btDevice.connect()
                        }
                        return btDevice.pair()
                    }
                    mainDelegate: BtMain {
                        modelData: listItem.modelData
                        scrollItem: listItem
                    }
                    subDelegate: BtSub {
                        modelData: listItem.modelData
                        scrollItem: listItem
                    }
                }
            }
            Item {
                id: nearbyFallback
                visible: !Bluetooth.devices.values.some(device => !device.paired)
                Layout.fillWidth: true
                implicitHeight: 64
                Text {
                    anchors.centerIn: parent
                    color: palette.placeholderText
                    text: "Refresh to scan for new devices"
                    font.pointSize: 10
                }
            }
        }
    }
}
