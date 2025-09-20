import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules.Common as Common

PageBase {
    id: page
    pageName: "Bluetooth"
    headerContent: Switch {

    }
    component BTDevice: Common.ScrollableItem {
        id: device
        required property var modelData
        content: RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            implicitWidth: 60
            implicitHeight: 24
            IconImage {
                Layout.leftMargin: 8
                implicitSize: 18
                source: Quickshell.iconPath(modelData.icon)
            }
            Text {
                Layout.fillWidth: true
                color: palette.text
                elide: Text.ElideRight
                text: device.modelData.name
            }
            Common.NormalButton {
                Layout.alignment: Qt.AlignRight
                iconName: "settings"
            }
        }
    }
    content: ColumnLayout {
        anchors.fill: parent
        Button {
            onClicked: {
                /*
                console.log("bt devices " + Bluetooth.devices.values)
                console.log("bt adapters " + Bluetooth.adapters.values)
                console.log("bt state " + Bluetooth.defaultAdapter.state.toString())
                */
               Bluetooth.defaultAdapter.discovering = true
            }
        }
        Common.VScrollable {
            id: scrollable
            padding: 8
            Layout.fillWidth: true; Layout.fillHeight: true
        
            content: ColumnLayout {
                id: col
                spacing: 5

                Item {
                    Layout.fillWidth: true
                    implicitHeight: section.height
                    Text {
                        id: section
                        padding: 8
                        color: palette.text
                        text: "My Devices"
                    }
                }
                // Horizontal line
                Rectangle {
                    color: palette.text
                    Layout.fillWidth: true
                    implicitHeight: 1
                    opacity: 0.2
                }
                Repeater {
                    Component.onCompleted: console.log(`repeater width: ${width}`)
                    model: ScriptModel {
                        values: Bluetooth.devices.values.filter(device => device.paired)
                    }
                    delegate: Common.ScrollableItem {
                        id: device
                        required property var modelData
                        //implicitWidth: parent.width
                        content: RowLayout {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            implicitWidth: 60
                            implicitHeight: 24
                            IconImage {
                                Layout.leftMargin: 8
                                implicitSize: 18
                                source: Quickshell.iconPath(modelData.icon)
                            }
                            Text {
                                Layout.fillWidth: true
                                color: palette.text
                                elide: Text.ElideRight
                                text: device.modelData.name
                            }
                            Common.NormalButton {
                                Layout.alignment: Qt.AlignRight
                                iconName: "settings"
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    implicitHeight: 20
                    Text {
                        color: palette.text
                        text: "Nearby Devices"
                    }
                }
                // Horizontal line
                Rectangle {
                    color: palette.text
                    Layout.fillWidth: true
                    implicitHeight: 1
                    opacity: 0.2
                }
                Repeater {
                    model: ScriptModel {
                        values: Bluetooth.devices.values.filter(device => !device.paired)
                    }
                    delegate: Common.ScrollableItem {
                        id: device
                        required property var modelData
                        //implicitWidth: col.width
                        content: RowLayout {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            implicitHeight: 24
                            IconImage {
                                Layout.leftMargin: 8
                                implicitSize: 18
                                source: Quickshell.iconPath(modelData.icon)
                            }
                            Text {
                                Layout.fillWidth: true
                                color: palette.text
                                elide: Text.ElideRight
                                text: device.modelData.name
                            }
                            Common.NormalButton {
                                Layout.alignment: Qt.AlignRight
                                iconName: "settings"
                            }
                        }
                    }
                }
            }
        }
    }
}
