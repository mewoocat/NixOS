import QtQuick
import Quickshell.Widgets

WrapperItem {
    id: root

    required property Item expandee
    required property Component content
    required property Item backdrop

    property bool expanded: false
    onExpandedChanged: console.debug(expanded)

    property int collaspedWidth: child.width
    property int collaspedHeight: child.height
    property int expandedWidth: backdrop.width
    property int expandedHeight: backdrop.height
    // IMPORTANT! Calculating the actual value here should be done after the component completes since it's 
    // position seems to shift around before then
    property point expandeeOrigin: Qt.point(0,0)
    // Doing this seems to work for now.  Be warned that the order in which components are completed is undefined
    Component.onCompleted: { expandeeOrigin = backdrop.mapFromItem(root.child, 0, 0) }

    property int animationSpeed: 400
    property var easingType: Easing.InOutQuint

    property Item contentItem: Loader {
        id: contentItem
        //opacity: 0
        active: false
        //Behavior on active { PropertyAnimation { to: false; duration: root.animationSpeed; easing.type: root.easingType; } }
        parent: root.backdrop
        x: root.expandeeOrigin.x
        y: root.expandeeOrigin.y
        width: root.collaspedWidth
        height: root.collaspedHeight
        /*
        Behavior on opacity { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on x { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on y { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on width { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on height { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        */
        sourceComponent: root.content
    }

    /*
    function showContent() {
        expandeeOrigin = backdrop.mapFromItem(child, 0, 0)
        contentItem.active = true
        contentItem.opacity = 1
        contentItem.x = 0
        contentItem.y = 0
        contentItem.width = expandedWidth
        contentItem.height = expandedHeight
    }

    function hideContent() {
        //contentItem.opacity = 0
        contentItem.active = false
        contentItem.x = expandeeOrigin.x
        contentItem.y = expandeeOrigin.y
        contentItem.width = collaspedWidth
        contentItem.height = collaspedHeight
    }
    */

    child: expandee

    // Animations
    states: [
        State {
            name: "expanded"
            when: root.expanded
            // Define the properties changes that will occur in this state
            /* Not needed?
            PropertyChanges {
                root {
                    expandeeOrigin: backdrop.mapFromItem(child, 0, 0)
                }
            }
            */
            PropertyChanges {
                contentItem {
                    active: true
                    //opacity: 1
                    x: 0
                    y: 0
                    width: expandedWidth
                    height: expandedHeight
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
                        target: contentItem
                        property: "active"
                    }
                    PropertyAction {
                        target: root
                        property: "expandeeOrigin"
                    }
                }
                NumberAnimation{
                    target: root.contentItem
                    properties: "x,y,width,height"
                    duration: root.animationSpeed
                    easing.type: root.easingType
                }
            }
        }
    ]
}
