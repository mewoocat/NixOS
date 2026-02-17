pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs as Root
import qs.Modules.Leaf as Leaf

// TODO: Could split the expanded portion of this type into a different type that builds off this one
// Size of root element must be set when consumed
Rectangle {
    id: root

    // Required properties
    required property var model // The model that has the data to render for each item
    required property Component delegate // The component to render for each item in the model

    // Signals

    // Refs
    property ListView listViewRef: listView
    //// Could better type these if scrollItem was moved to it's own file ... might have issue with cyclic dependency though
    property var prevExpandedItem: null // Holds ref to previously expanded item, for collapsing it when expanded item changed
    property var expandedItem: null // Holds a ref to the currently expanded item in this scrollable, or null if none are expanded

    // style
    property int padding: 0
    property int animationSpeed: 100
    property int expansionAnimationSpeed: 350
    property int itemHeight: 48
    property int contentMargin: 4
    property color scrollItemBG: Root.State.colors.surface_container
    property color scrollItemBGHighlight: Root.State.colors.primary

    // Behavior
    property bool interactable: true

    onExpandedItemChanged: {
        if (prevExpandedItem != null) {
            prevExpandedItem.expanded = false
        }
        prevExpandedItem = expandedItem
    }
    onVisibleChanged: { // Whenever this is hidden, reset the expanded state if applicable
        if (!visible && expandedItem != null) {
            expandedItem.expanded = false
        }
        listView.positionViewAtBeginning() // Reset the view to the top
    }
    color: "transparent" //"#770000ff"
    radius: 8
    clip: true
    implicitHeight: listView.childrenRect.height// Defaults to as large as is needed to show all items
    implicitWidth: 200 // Default width

    // Rendered floating as to not affect placement of list items.
    // So the width of the scroll bar must be less than the spacing between the edge of
    // the ListView and parent
    Leaf.LeafScrollBar {
        id: scrollBar
        //visible: interactable
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
    }

    ListView {
        id: listView

        anchors {
            margins: root.padding
            fill: parent
        }

        ScrollBar.vertical: scrollBar
        snapMode: ListView.SnapToItem
        //keyNavigationEnabled: true // Enabled by default
        highlightMoveDuration: 0 // Instantly snaps to item
        clip: true // Ensure that scrolled items don't go outside the widget
        interactive: root.interactable

        model: root.model
        delegate: root.delegate

        WrapperItem {
            id: loadBox

            // Use a loader to create the delegate component with Component.createObject() and inject the required properties.
            // Then call destroy on the created component whenever the loader active property is set to false.  I think this will ensure
            // that the subDelegate is only loaded when the loader is active while still being able to inject the required properties.
            Loader {
                id: delegateLoader
                active: false //scrollItem.expanded // false // Modified via state change

                function createObject() {
                    loadBox.child = root.delegate.createObject(loadBox, {
                        modelData: Qt.binding(() => loadBox.modelData), // Bind the model data
                        listView: Qt.binding(() => listView) // Bind the ListView ref
                    })
                }

                // Only initialize the delegate on startup if the loader is active
                Component.onCompleted: if (active) { createObject() }

                // If the loader becomes inactive and a created delegate exists, then destroy it.
                onActiveChanged: {
                    if (!active && loadBox.child != null) {
                        loadBox.child.destroy()
                    }
                    else {
                        createObject()
                    }
                }
            }
        }
    }
}
