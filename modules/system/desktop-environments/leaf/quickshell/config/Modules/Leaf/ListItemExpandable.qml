pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs as Root

// Intended to be used as the delegate for a Leaf.ListView
// This ListItem variant supports the ability to expand it's size to show more content

WrapperMouseArea {
    id: root

    //required property var modelData // Injected by Leaf.ListView
    required property var listView // Should be manually injected
    required property Component mainDelegate // The main content to show
    required property Component subDelegate // The sub content to show when expanded

    property bool expanded: false // Whether this item is currently expanded
    property bool showBackground: false
    property int contentMargin: 8
    property bool interacted: root.containsMouse || root.focus || root.expanded // TODO: figure out how to make interacted false after the animation plays for expansion
    property int itemHeight: 80

    property int collapsedHeight: 80

    //onClicked: root.primaryClick(modelData)
    //bottomMargin: 8 // Yes, this will cause extra spacing at the bottom of the scrollable
    implicitWidth: parent ? parent.width : 0 // Idk why but parent is sometimes null here.  Maybe when this delegate is removed from the view?
    hoverEnabled: true
    margin: 12

    onExpandedChanged: {
        console.log(`expanded: ${expanded}`)
        if (expanded) {
            if (listView.expandedItem != null) {
                listView.expandedItem.expanded = false
            }
            listView.expandedItem = root
        }
        else {
            listView.expandedItem = null
        }
    }

    Rectangle {
        id: background
        //clip: true
        color: Root.State.colors.surface_container_highest
        radius: Root.State.rounding
        implicitWidth: parent.width
        implicitHeight: root.collapsedHeight // !! implicitHeight is modified via a state change

        // Main content
        WrapperRectangle {
            id: mainBox
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            radius: 8
            color: root.containsMouse || root.showBackground || root.focus ? "blue" : "transparent"
            //margin: root.contentMargin
            implicitHeight: parent.height

            Loader {
                id: mainLoader
                active: true // Should always be shown
                sourceComponent: root.mainDelegate
                // Force Loaded component to be size of parent
                width: parent.implicitWidth
                height: parent.implicitHeight
            }
        }

        // Sub content
        WrapperRectangle {
            id: subBox
            visible: false
            anchors.top: mainBox.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "purple"
            bottomLeftRadius: 8
            bottomRightRadius: 8

            Loader {
                id: subLoader
                active: false // Modified via state change
                sourceComponent: root.subDelegate
            }
        }
    }

    // Probably simpler to do this with a "Behavior" on instead of using states and transitions 
    states: [
        State {
            name: "expanded"
            when: root.expanded
            // Define the properties changes that will occur in this state
            PropertyChanges {
                subLoader {
                    active: true
                }
                root {
                    showBackground: true
                }
                background {
                    implicitHeight: mainBox.height + subBox.height
                }
                mainBox {
                    bottomLeftRadius: 0
                    bottomRightRadius: 0
                }
                mainLoader {
                    // Allow loaded component to resize the Loader
                    width: undefined
                    height: undefined
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
                        target: root
                        property: "showBackground"
                    }
                    PropertyAction {
                        target: subDelegateLoader
                        property: "active"
                    }
                    PropertyAction {
                        target: subBox
                        property: "visible"
                    }
                    PropertyAction {
                        target: mainLoader
                        property: "width,height"
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
