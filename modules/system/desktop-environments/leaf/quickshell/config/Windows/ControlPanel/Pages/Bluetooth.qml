pragma ComponentBehavior: Bound // allows for referencing of siblings
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules.Common as Common
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
            Layout.leftMargin: 4
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
                    color: mainDelegate.scrollItem.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
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
        Common.NormalButton {
            Layout.alignment: Qt.AlignRight
            visible: mainDelegate.scrollItem.interacted //&& mainDelegate.app.actions.length > 0
            iconName: "view-more"
            leftClick: () => mainDelegate.scrollItem.expanded = !mainDelegate.scrollItem.expanded
            defaultIconColor: Root.State.colors.on_primary
            activeIconColor: Root.State.colors.on_primary_container
            activeBgColor: Root.State.colors.primary_container
            recolorIcon: true
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
            Common.NormalButton {
                visible: subDelegate.modelData.paired
                text: subDelegate.modelData.connected ? "disconnect" : "connect"
                leftClick: subDelegate.modelData.connected ? subDelegate.modelData.disconnect : subDelegate.modelData.connect
            }
            Common.NormalButton {
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


    content: ColumnLayout {
        id: pageContent
        anchors.fill: parent

        Common.FlickScrollable {
            id: scrollable
            // Size determined by the pageContent
            implicitWidth: parent.width
            implicitHeight: parent.height
            contentPadding: 0
            showBackground: false

            // Width should be determined by the scrollable - any padding
            // Then the children in the layout should be constrained by this size
            content: ColumnLayout {
                anchors.fill: parent
                id: col
                spacing: 8

                // Forces the layout to have a width of this element since it's the largest
                // All other siblings can then Layout.fillWidth: true to also become the same width
                //Item { implicitWidth: col.width }

                // Paired Devices
                WrapperItem {
                    Layout.fillWidth: true
                    Text {
                        padding: 8
                        color: palette.text
                        text: "My Devices"
                    }
                }
                //Common.HorizontalLine { }
                Common.ListViewScrollable {
                    Layout.fillWidth: true
                    interactable: false
                    model: ScriptModel {
                        values: Bluetooth.devices.values.filter(device => device.paired)
                    }
                    // When an entry is clicked (modelData is a BluetoothDevice)
                    onPrimaryClick: (modelData) => {
                        const btDevice = modelData
                        if (btDevice.paired) {
                            return btDevice.connected ? btDevice.disconnect() : btDevice.connect()
                        }
                        return btDevice.pair()
                    }
                    mainDelegate: BtMain {}
                    subDelegate: BtSub {} 
                }

                // Nearby Devices
                RowLayout {
                    WrapperItem {
                        Layout.fillWidth: true
                        Text {
                            padding: 8
                            color: palette.text
                            text: "Nearby Devices"
                        }
                    }
                    Button {
                        Layout.rightMargin: 8 // TODO: find a better solution
                        id: refreshButton
                        icon.name: "view-refresh-symbolic" 
                        onClicked: {
                           console.log(`scannings for bt devices`)
                           Bluetooth.defaultAdapter.discovering = true
                        }
                    }
                }
                //Common.HorizontalLine { }
                Common.ListViewScrollable {
                    Layout.fillWidth: true
                    interactable: false
                    model: ScriptModel {
                        values: Bluetooth.devices.values.filter(device => !device.paired)
                    }
                    // When an entry is clicked (modelData is a BluetoothDevice)
                    onPrimaryClick: (modelData) => {
                        const btDevice = modelData
                        if (btDevice.paired) {
                            return btDevice.connected ? btDevice.disconnect() : btDevice.connect()
                        }
                        return btDevice.pair()
                    }
                    mainDelegate: BtMain {}
                    subDelegate: BtSub {} 
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
}
