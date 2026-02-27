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
    property int maxCollapsedHeight: 100
    property int padding: 8
    property int expansionAnimationSpeed: 350

    implicitWidth: parent ? parent.width : 0 // Idk why but parent is sometimes null here.  Maybe when this delegate is removed from the view?
    hoverEnabled: true
    margin: 8

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
        clip: true
        color: root.containsMouse ? Root.State.colors.surface_container_high : Root.State.colors.surface_container_highest
        radius: Root.State.rounding
        implicitWidth: parent.implicitWidth - (root.margin * 2)  // We want the width after taking into account the margins
        implicitHeight: Math.min(root.maxCollapsedHeight, mainBox.implicitHeight)// !! implicitHeight is modified via a state change

        // Main content
        WrapperRectangle {
            id: mainBox
            implicitWidth: background.implicitWidth
            implicitHeight: mainLoader.implicitHeight + (root.padding * 2) // Need to add the margin amount on each side since the mainLoader's height is shrunk by 2x the margin amount
            //implicitHeight: parent.implicitHeight
            radius: 8
            margin: root.padding
            color: "transparent"
            //margin: root.contentMargin

            Loader {
                id: mainLoader
                active: true // Should always be shown
                sourceComponent: root.mainDelegate
                // Force Loaded component to be size of parent, until state change
                //width: mainBox.implicitWidth
                //height: parent.implicitHeight
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
                    implicitHeight: mainBox.implicitHeight + subBox.implicitHeight
                }
                mainBox {
                    bottomLeftRadius: 0
                    bottomRightRadius: 0
                }
                mainLoader {
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
                        target: subLoader
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
                        duration: root.expansionAnimationSpeed
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAnimation {
                        target: mainBox
                        property: "bottomLeftRadius"
                        duration: root.expansionAnimationSpeed
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAnimation {
                        target: background
                        property: "implicitHeight"
                        duration: root.expansionAnimationSpeed
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    ]    
}
