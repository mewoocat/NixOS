pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs as Root

// Size of root element must be set when consumed
Rectangle {
    id: root

    // Required properties
    required property var model // The model that has the data to render for each item
    required property Component mainDelegate // The main content to show
    required property Component subDelegate // The sub content to show when expanded

    // Signals
    signal primaryClick(modelData: var)

    // Refs
    property ListView listViewRef: listView
    //// Could better type these if scrollItem was moved to it's own file ... might have issue with cyclic dependency though
    property var prevExpandedItem: null // Holds ref to previously expanded item, for collapsing it when expanded item changed
    property var expandedItem: null // Holds a ref to the currently expanded item in this scrollable, or null if none are expanded

    // style
    property int padding: 16
    property int animationSpeed: 100
    property int expansionAnimationSpeed: 350
    property int itemHeight: 48
    property int contentMargin: 4
    property color scrollItemBG: "red"
    property color scrollItemBGHighlight: Root.State.colors.primary

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

    // Rendered floating as to not affect placement of list items.
    // So the width of the scroll bar must be less than the spacing between the edge of
    // the ListView and parent
    ScrollBar {
        id: scrollBar
        implicitWidth: 4
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
    }

    // List
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

        model: root.model

        delegate: WrapperMouseArea {
            id: scrollItem
            required property var modelData

            property bool expanded: false
            property bool showBackground: false
            property int contentMargin: 0
            /*
            property Item subContentLoader: Loader {
                visible: active // To unreserve space when the component isn't loaded
                active: false
                sourceComponent: root.subContent
            }
            */

            onClicked: root.primaryClick(modelData)
            property bool interacted: scrollItem.containsMouse || scrollItem.focus // Indicates if active via mouse or focus
            bottomMargin: 8 // Yes, this will cause extra spacing at the bottom of the scrollable
            implicitWidth: parent ? parent.width : 0 // Idk why but parent is sometimes null here.  Maybe when this delegate is removed from the view?
            hoverEnabled: true

            onExpandedChanged: {
                console.log(`expanded: ${expanded}`)
                if (expanded) {
                    if (root.expandedItem != null) {
                        root.expandedItem.expanded = false
                    }
                    root.expandedItem = scrollItem
                }
                else {
                    root.expandedItem = null
                }
            }

            // scrollable item content
            Rectangle {
                id: background
                clip: true
                //color: scrollItem.containsMouse || scrollItem.showBackground || scrollItem.focus ? root.scrollItemBGHighlight : "transparent"
                color: "transparent"
                implicitWidth: parent.width
                implicitHeight: root.itemHeight // !! implicitHeight is modified via a state change
                //onImplicitHeightChanged: console.log(`implicitHeight: ${implicitHeight}`)
                // Main content
                WrapperRectangle {
                    id: mainBox
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    //color: "transparent"
                    radius: 8
                    color: scrollItem.containsMouse || scrollItem.showBackground || scrollItem.focus ? root.scrollItemBGHighlight : "transparent"
                    margin: root.contentMargin

                    // Working implementation
                    Loader {
                        id: loader
                        sourceComponent: root.mainDelegate
                    }
                    Binding {
                        id: binder
                        target: loader.item
                        property: "modelData"
                        value: scrollItem.modelData
                    }
                    Binding {
                        id: binder2
                        target: loader.item
                        property: "scrollItem"
                        value: scrollItem
                    }

                    // Idea 2
                    /*
                    // Idk why setting the created object to this WrapperRectangle's child property doesn't work
                    Item {
                        children: [
                            // Using Qt.binding() to bind the modelData property, otherwise this
                            // binding of the children will treat root.modelData as a dependecy of children
                            // And recreate the object everytime modelData changes
                            root.mainDelegate.createObject(mainBox, { 
                                modelData: Qt.binding(() => scrollItem.modelData),
                                scrollItem: Qt.binding(() => scrollItem) // Ref to the ancestor scrollItem for access from the delegate
                            })
                        ]
                    }
                    */

                    // Idea 3
                    // WARNING: I don't think this will work given the structure of this file
                    // Nesting a Component within a component (BoundComponent's sourceComponent inside of Loader's sourceComponent)
                    // means that the nested component (root.mainDelegate)'s creation context is nested inside of another component.
                    // This will throw a "Cannot instantiate bound component outside its creation context" warning since the creation
                    // context of the root.mainDelegate component (it is a created component, don't get an instantiated Component confused
                    // with an instantiated Item) is scoped to the BoundComponent Object.  But since the BoundComponent isn't apart of the 
                    // scope where root.mainDelegate exists, it's not in the creation context and can't be instantiated. 
                    /*
                    Loader {
                        id: mainLoader
                        active: true
                        property Component boundComp: BoundComponent {
                            id: boundComp
                            sourceComponent: root.mainDelegate
                            //property var modelData: scrollItem.modelData
                            //property var scrollItem: scrollItem
                        }
                        sourceComponent: boundComp
                    }
                    */
                }
                // Sub content
                WrapperRectangle {
                    id: subBox
                    anchors.top: mainBox.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: root.scrollItemBG
                    bottomLeftRadius: 8
                    bottomRightRadius: 8
                    //child: null // This gets set via the loader

                    // Use a loader to create the delegate component with Component.createObject() and inject the required properties.
                    // Then call destroy on the created component whenever the loader active property is set to false.  I think this will ensure
                    // that the subDelegate is only loaded when the loader is active while still being able to inject the required properties.
                    Loader {
                        id: subDelegateLoader
                        active: false //scrollItem.expanded // false // Modified via state change

                        function createObject() {
                            subBox.child = root.subDelegate.createObject(subBox, {
                                modelData: Qt.binding(() => scrollItem.modelData), // Bind the model data
                                scrollItem: Qt.binding(() => scrollItem) // Bind the scroll item itself
                            })
                        }

                        // Only initialize the delegate on startup if the loader is active
                        Component.onCompleted: if (active) { createObject() }

                        // If the loader becomes inactive and a created delegate exists, then destroy it.
                        onActiveChanged: {
                            console.log(`active changed to ${active}`)
                            if (!active && subBox.child != null) {
                                subBox.child.destroy()
                            }
                            else {
                                createObject()
                            }
                        }
                    }
                }
            }

            // Probably simpler to do this with a "Behavior" on instead of using states and transitions 
            states: [
                State {
                    name: "expanded"
                    when: scrollItem.expanded
                    // Define the properties changes that will occur in this state
                    PropertyChanges {
                        subDelegateLoader {
                            active: true
                        }
                        scrollItem {
                            showBackground: true
                        }
                        background {
                            implicitHeight: root.itemHeight + subBox.height
                        }
                        mainBox {
                            bottomLeftRadius: 0
                            bottomRightRadius: 0
                        }
                    }
                }
            ]
            transitions: [
                // Expanding & collapsing (due to reversible set to true)
                Transition {
                    to: "expanded"
                    // Reverses the Transition when the conditions that triggered this transition are reversed
                    reversible: true
                    // Animate the properties changed via state, this allows us to choose when and how during the
                    // state transition the properties are modified 
                    SequentialAnimation {
                        // So run these state changes first in parallel
                        ParallelAnimation {
                            PropertyAction {
                                target: scrollItem
                                property: "showBackground"
                            }
                            PropertyAction {
                                target: subDelegateLoader
                                property: "active"
                            }
                        }
                        // Then run these in parallel
                        ParallelAnimation {
                            PropertyAnimation {
                                target: mainBox
                                property: "bottomRightRadius"
                                duration: expansionAnimationSpeed
                                easing.type: Easing.InOutQuad
                            }
                            PropertyAnimation {
                                target: mainBox
                                property: "bottomLeftRadius"
                                duration: expansionAnimationSpeed
                                easing.type: Easing.InOutQuad
                            }
                            PropertyAnimation {
                                target: background
                                property: "implicitHeight"
                                duration: expansionAnimationSpeed
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            ]    
        }
        // Animations 
        // TODO: They work but need to set them up to look nice :)
        /*
        add: Transition {
            NumberAnimation {
                properties: "y"
                from: -100
                duration: root.animationSpeed
            }
        }
        addDisplaced: Transition {
            NumberAnimation {
                properties: "y"
                duration: root.animationSpeed
            }
        }
        remove: Transition {
            SequentialAnimation {
                NumberAnimation {
                    properties: "x"
                    to: -8
                    duration: 100
                }
                NumberAnimation {
                    properties: "y"
                    to: -100
                    duration: root.animationSpeed
                }
            }
        }
        */
    }
}
