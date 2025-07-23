pragma ComponentBehavior: Bound

import "../../../Modules/Common" as Common
import "../../../" as Root
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// An item in a SystemTray popup menu
MouseArea {
    id: root
    // Note that it appears that some entry handles (i.e. for nm-applet) will become null at some point
    // important to check if null when referencing this entry property
    required property QsMenuEntry entry
    implicitHeight: background.height
    implicitWidth: box.width // 
    //Layout.fillWidth: true // But expand if allowed
    enabled: true
    hoverEnabled: true
    onClicked: {
        console.log('clicked')
        if (root.entry.hasChildren) {
            // setting the popup vis
            loader.item.item.visible = true    
            console.log(loader.item.item)
        }
        root.entry.triggered()
    }
    //Component.onCompleted: console.log(`MenuEntry entry value = ${root.entry} with text = ${root.entry.text}`)
    //onEntryChanged: console.log(`MenuEntry CHANGED entry value = ${root.entry}`)

    // Loads a nested popup window if the entry supplies children
    Loader {
        id: loader
        active: root.entry.hasChildren
        onActiveChanged: console.log(`nested loader: ${root.entry.hasChildren}`)
        property Component trayPopupMenu: BoundComponent {
            id: trayPopup
            source: "TrayPopupMenu.qml"
            property var menu: root.entry
            property Item parentButton: root
            property bool isNested: true
        }
        sourceComponent: trayPopupMenu
    }

    Rectangle {
        id: background
        color: root.containsMouse ? palette.accent : "transparent"
        radius: Root.State.rounding
        implicitHeight: box.height
        implicitWidth: parent.width
        WrapperItem {
            id: box
            margin: 4
            // This doesn't prevent the entry is null warnings that occur at runtime :(
            Loader {
                active: root.entry !== null
                onActiveChanged: console.log(`active now ${active}`)
                sourceComponent: BoundComponent {
                    bindValues: false
                    property QsMenuEntry entry: root.entry
                    sourceComponent: RowLayout {
                        id: content
                        required property QsMenuEntry entry
                        IconImage {
                            visible: content.entry.icon === ""
                            implicitSize: content.entry.icon !== "" ? 16 : 0
                            source: content.entry.icon
                        }
                        CheckBox {
                            visible: content.entry.buttonType === QsMenuButtonType.CheckBox
                            checkState: content.entry.checkState
                        }
                        RadioButton {
                            visible: content.entry.buttonType === QsMenuButtonType.RadioButton
                        }
                        Text { 
                            id: text
                            color: palette.text
                            text: content.entry.text
                        }
                        Text { 
                            color: palette.text
                            text: content.entry.hasChildren
                        }
                    }
                }
            }
        }
    }
}
