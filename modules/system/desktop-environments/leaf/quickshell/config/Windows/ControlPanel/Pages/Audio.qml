import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import "../../../" as Root
import "../../../Services" as Services
import "../../../Modules" as Modules
import "../../../Modules/Common" as Common

Rectangle{
    color: "transparent"

ColumnLayout {
    // Anchor the column in order to set it's width and place it at top
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left
    Common.NormalButton {
        text: "Back"
        leftClick: () => Root.State.controlPanelPage = 0
    }


    // Default output
    Modules.MixerItem {
        node: Pipewire.defaultAudioSink
    }

    // Output device selector
    ComboBox {
        model: Pipewire.nodes.values
            .filter(n => n.isSink) // filter nodes for sinks (Output devices)
            .map(n => n.description) // Map to just the output name string (Results in a list of string names)
        /*
        delegate: WrapperMouseArea {
            id: item
            required property PwNode modelData
            Text {
                color: palette.text
                text: `name: ${item.modelData.name}`
            }
        }
        */
    }

    // Track all nodes outputting to the default output
    PwNodeLinkTracker {
        id: defaultOutputLinkTracker
        node: Pipewire.defaultAudioSink
    }

    ColumnLayout {
        //Layout.fillHeight: true
        Layout.fillWidth: true
        Repeater {
            // For each source outputting to the default output
            // i.e. Each program, etc.
            // A link is a connection between two nodes
            model: defaultOutputLinkTracker.linkGroups
            Component.onCompleted: console.error(`link list: ${defaultOutputLinkTracker.list}`)

            // MixerItem
            Modules.MixerItem {
            }
        }
    }
    // Spacer, i really need to figure out layouts
    /*
    ColumnLayout {
        Layout.fillHeight: true
    }
    */

    Button {
        text: "test"
    }
}
}
