pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Services as Services
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import qs.Components.Shared as Shared
import Quickshell.Widgets
import Quickshell.Bluetooth

import Quickshell
import Quickshell.Networking
import Quickshell.Bluetooth


AbsGrid.WidgetData { 
    id: widgetData
    name: "Network"
    xSize: 3
    ySize: 2
    component: Item {
        id: root
        anchors.fill: parent
        anchors.margins: widgetData.padding
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            component RowItem: RowLayout {
                id: rowItem
                required property string iconName
                required property string title
                required property string subtext
                required property Component content

                spacing: 0

                property bool active: false
                signal normalAction()
                signal toggleAction()

                function goBack() {
                    expander.expanded = false
                }

                Layout.fillWidth: true
                Layout.fillHeight: true

                Ctrls.RoundButton {
                    id: toggleButton
                    icon.name: rowItem.iconName
                    onClicked: rowItem.toggleAction()
                    backgroundColor: rowItem.active || hovered ? Root.State.colors.primary : Root.State.colors.surface_container_highest
                    color: rowItem.active || hovered ? Root.State.colors.on_primary : Root.State.colors.on_surface
                }
                MouseArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: mouseArea
                    enabled: true
                    hoverEnabled: true
                    onClicked: expander.expanded = true
                    Shared.Expander {
                        id: expander
                        anchors.fill: parent
                        backgroundRadius: widgetData.radius
                        backgroundMargin: widgetData.padding
                        backdrop: widgetData.panelGrid
                        content: rowItem.content
                        expandee: Rectangle {
                            anchors.fill: parent
                            anchors.margins: root.anchors.margins
                            radius: Root.State.smallRounding
                            color: mouseArea.containsMouse ? Root.State.colors.surface_container_high : "transparent"
                            Column {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 0
                                Text {
                                    color: Root.State.colors.on_surface
                                    text: rowItem.title
                                    font.pointSize: 10
                                }
                                Text { 
                                    width: parent.width
                                    color: Root.State.colors.on_surface
                                    opacity: 0.6
                                    text: rowItem.subtext
                                    elide: Text.ElideRight // Truncate with ... on the right
                                    font.pointSize: 8
                                }
                            }
                        }
                    }
                }
            }
            // Internet
            RowItem {
                id: internet
                title: "Wifi"
                subtext: Services.Networking.currentWifiNetwork?.name ?? "disconnected"
                iconName: Services.Networking.getWifiActiveIconName(Services.Networking.currentWifiNetwork)
                content: Shared.PageBase {
                    pageName: "Wi-Fi"
                    onGoBack: internet.goBack()
                    headerContent: RowLayout {
                        Ctrls.Switch {
                            checked: Networking.wifiEnabled ?? false
                            onClicked: Networking.wifiEnabled = checked
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

                            Shared.SubSection {
                                name: "Nearby Networks"
                                content: Ctrls.Button {
                                    icon.name: "view-refresh-symbolic"
                                    icon.width: 16
                                    icon.height: 16
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
                                    required property WifiNetwork modelData
                                    implicitWidth: pariredListView.width - pariredListView.padding * 2
                                    margin: 2
                                    padding: 2
                                    listView: pariredListView
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
                            source: Quickshell.iconPath(Services.Networking.getWifiAPIconName(modelData), "network-wireless-disconnected")
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
                                    color: {
                                        switch(mainDelegate.modelData.state) {
                                            case ConnectionState.Connected:
                                                return "green"
                                            case ConnectionState.Connecting:
                                                return "orange"
                                            case ConnectionState.Disconnecting:
                                                return "red"
                                            case ConnectionState.Disconnected:
                                                return mainDelegate.scrollItem.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface_variant
                                        }
                                    }
                                    text: ConnectionState.toString(mainDelegate.modelData.state)
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

                active: Services.Networking.isWifiEnabled
                onToggleAction: Services.Networking.setWifiEnabled(!Services.Networking.isWifiEnabled)
            }
            // Bluetooth
            RowItem {
                id: bluetooth
                title: "Bluetooth"
                subtext: Services.Bluetooth.connectedDevices.values.length > 0
                    ? Services.Bluetooth.connectedDevices.values[0].name
                    : "disconnected"
                iconName: "network-bluetooth-symbolic"
                content: Shared.PageBase {
                    onGoBack: bluetooth.goBack()
                    id: page
                    pageName: "Bluetooth"
                    headerContent: RowLayout {
                        Ctrls.Switch {
                            checked: Bluetooth.defaultAdapter?.enabled ?? false
                            onClicked: Bluetooth.defaultAdapter.enabled = checked
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
                                        text: mainDelegate.modelData.batteryAvailable ? (mainDelegate.modelData.battery * 100) + ' %' : "n/a"
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
                    
                    component BtSub: ColumnLayout {
                        id: subDelegate
                        // These are injected by the ListViewScrollable
                        required property BluetoothDevice modelData
                        required property var scrollItem
                        Component.onCompleted: console.debug(`btDevice: ${modelData}`)

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            Ctrls.Button {
                                visible: subDelegate.modelData.paired
                                text: subDelegate.modelData.connected ? "disconnect" : "connect"
                                onClicked: subDelegate.modelData.connected ? subDelegate.modelData.disconnect : subDelegate.modelData.connect
                            }
                            Ctrls.Button {
                                text: subDelegate.modelData.paired ? "forget" : "pair"
                                onClicked: subDelegate.modelData.paired ? subDelegate.modelData.forget : subDelegate.modelData.pair
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
                            Shared.ScrollableList {
                                id: pariredListView
                                implicitWidth: parent.implicitWidth 
                                // implicit height defaults to full height of children
                                interactable: false
                                model: Services.Bluetooth.pairedDevices
                                delegate: Shared.ListItemExpandable {

                                    id: pairedListItem
                                    implicitWidth: pariredListView.width - pariredListView.padding * 2
                                    margin: 2
                                    padding: 2
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
                            Shared.SubSection { 
                                name: "Nearby Devices"
                                content: Ctrls.Button {
                                    Layout.rightMargin: 8 // TODO: find a better solution
                                    id: refreshButton
                                    icon.name: "view-refresh-symbolic" 
                                    onClicked: {
                                        console.log(`scannings for bt devices`)
                                        Bluetooth.defaultAdapter.discovering = true
                                    }
                                }
                            }

                            Shared.ScrollableList {
                                id: unpariredListView
                                implicitWidth: parent.implicitWidth 
                                // implicit height defaults to full height of children
                                model: Services.Bluetooth.unpariredDevices
                                interactable: false
                                delegate: Shared.ListItemExpandable {
                                    id: listItem
                                    margin: 2
                                    padding: 2
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

                active: Bluetooth.defaultAdapter?.enabled ?? false
                onToggleAction: Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
            }
        }
    }
}
