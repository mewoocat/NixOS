import QtQuick
import Quickshell.Widgets
import qs as Root

WrapperItem {
    id: root

    required property Item expandee
    required property Component content
    required property Item backdrop

    property bool expanded: false
    property int backgroundMargin: 0
    property int backgroundRadius: 0

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

    // Wrap the Loader in a MouseArea to trap any mouse events since this content could be rendered over
    // a button.
    property Item contentItem: MouseArea {
        id: contentItem
        visible: false
        property bool active: false
        parent: root.backdrop
        x: root.expandeeOrigin.x
        y: root.expandeeOrigin.y
        width: root.collaspedWidth
        height: root.collaspedHeight

        Rectangle {
            id: background
            anchors.fill: parent
            //anchors.margins: root.backgroundMargin
            color: Root.State.colors.surface_container
            radius: root.backgroundRadius

            Loader {
                id: loader
                opacity: 0
                anchors.fill: parent
                active: false
                sourceComponent: root.content
            }
        }
    }

    child: expandee

    // Animations
    states: [
        State {
            name: "expanded"
            when: root.expanded
            // Define the properties changes that will occur in this state
            PropertyChanges {
                contentItem {
                    visible: true
                    active: true
                    x: 0 + root.backgroundMargin
                    y: 0 + root.backgroundMargin
                    width: expandedWidth - root.backgroundMargin * 2
                    height: expandedHeight - root.backgroundMargin * 2
                }
                expandee {
                    opacity: 0
                }
                loader {
                    active: true
                    opacity: 1
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
                        target: loader
                        property: "active"
                    }
                    PropertyAction {
                        target: root
                        property: "expandeeOrigin"
                    }
                }
                NumberAnimation{
                    target: root.child
                    properties: "opacity"
                    duration: 100
                    easing.type: root.easingType
                }
                PropertyAction {
                    target: contentItem
                    property: "visible"
                }
                ParallelAnimation {
                    NumberAnimation{
                        target: root.contentItem
                        properties: "x,y,width,height"
                        duration: root.animationSpeed
                        easing.type: root.easingType
                    }
                    NumberAnimation{
                        target: loader
                        properties: "opacity"
                        duration: root.animationSpeed
                        easing.type: root.easingType
                    }
                }
            }
        }
    ]
}
