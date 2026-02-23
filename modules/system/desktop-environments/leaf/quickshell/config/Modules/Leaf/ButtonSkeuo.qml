import QtQuick
import QtQuick.Effects
import QtQuick.Controls.impl // For IconLabel
import QtQuick.Templates as T

import qs as Root

// Custom button based off logic template.  This is the recommended way to create a custom
// style.  Should probably follow this pattern for the rest of the controls
T.Button {
    id: control

    hoverEnabled: true

    //defines the padding of the contentItem relative to the edge of the control
    padding: 8

    // Defines the padding of the background
    property real inset: 4
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    implicitWidth: background.implicitWidth + leftInset + rightInset
    implicitHeight: background.implicitHeight + bottomInset + topInset
    background: Rectangle {
        id: bg
        implicitWidth: control.contentItem.implicitWidth + control.padding
        implicitHeight: control.contentItem.implicitHeight + control.padding
        color: "transparent"
        radius: 8 // This propagates to the children RectangularShadow's

        property int skeuo: 2
        property int blur: 4
        property int spread: 2 // increasing this causes the positions to get wack
        property int animSpeed: 200
        property var easingType: Easing.InOutQuart
        //property var easingType: Easing.InOutCirc
        property var topRightPos: QtObject {
            property int x: 0
            property int y: -(bg.skeuo * 2)
        }
        property var botLeftPos: QtObject {
            property int x: -bg.skeuo
            property int y: 0
        }
        property color shadowColor: Qt.darker(Root.State.colors.surface, 4)
        property color highlightColor: Qt.lighter(Root.State.colors.surface, 1.8)
        property color surfaceColorRaised: Qt.lighter(Root.State.colors.surface, 1.4)
        property color surfaceColorPressed: Qt.darker(Root.State.colors.surface, 1.4)

        // Shadow
        RectangularShadow {
            id: shadow

            implicitWidth: bg.implicitWidth + (bg.skeuo * 2)
            implicitHeight: bg.implicitHeight + (bg.skeuo * 2)
            // WARNING: Position is set via states
            radius: bg.radius
            blur: bg.blur
            spread: bg.spread
            color: bg.shadowColor
        }

        // Highlight
        RectangularShadow {
            id: highlight

            implicitWidth: bg.implicitWidth + (bg.skeuo * 2)
            implicitHeight: bg.implicitHeight + (bg.skeuo * 2)
            // WARNING: Position is set via states
            radius: bg.radius
            blur: bg.blur
            spread: bg.spread - 2
            color: bg.highlightColor
        }

        Rectangle {
            id: surface
            implicitWidth: bg.implicitWidth
            implicitHeight: bg.implicitHeight
            radius: bg.radius
            color: "transparent" // WARNING: Color set via state change
        }        
    }

    icon.name: ""
    icon.source: ""
    icon.width: 18
    icon.height: 18
    icon.color: "red"

    // The geometry of the contentItem is determined by the padding
    // IconLabel source: https://github.com/qt/qtdeclarative/blob/dev/src/quickcontrolsimpl/qquickiconlabel_p.h
    // Might want to look into IconImage (from the impl namespace, not qs) as well
    contentItem: Item {
        id: content
        implicitHeight: iconLabel.implicitHeight
        implicitWidth: iconLabel.implicitWidth

        property color textColorRaised: Root.State.colors.on_surface
        property color textColorPressed: Qt.darker(Root.State.colors.on_surface, 1.4)
        IconLabel {
            anchors.centerIn: content
            id: iconLabel
            icon.name: control.icon.name
            icon.color: Root.State.colors.on_surface
            text: control.text
            icon.width: control.icon.width
            icon.height: control.icon.height
            //color: Root.State.colors.on_surface
            //color: control.hovered ? content.textColorPressed : content.textColorRaised
            color: "transparent" // WARNING: Property set via state // Try unbinding this <-
            implicitHeight: control.height

            /*
            x: control.hovered ? -1 : 0
            y: control.hovered ? 1 : 0
            Behavior on x { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }
            Behavior on y { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }
            */
        }
    }

    state: "raised" // Default state
    states: [
        State {
            name: "raised"
            when: !control.hovered
            PropertyChanges {
                highlight {
                    x: bg.topRightPos.x
                    y: bg.topRightPos.y
                    spread: bg.spread - 2
                }
                shadow {
                    x: bg.botLeftPos.x
                    y: bg.botLeftPos.y
                    z: -1 // show behind highlight
                    spread: bg.spread
                }
                surface {
                    color: bg.surfaceColorRaised
                }
                iconLabel {
                    color: content.textColorRaised
                    icon.color: content.textColorRaised
                }
            }
        },
        State {
            name: "pressed"
            when: control.hovered
            PropertyChanges {
                highlight {
                    x: bg.botLeftPos.x
                    y: bg.botLeftPos.y
                    z: -1 // show behind shadow
                    spread: bg.spread
                }
                shadow {
                    x: bg.topRightPos.x
                    y: bg.topRightPos.y
                    spread: bg.spread - 2
                }
                surface {
                    color: bg.surfaceColorPressed
                }
                iconLabel {
                    color: content.textColorPressed
                    icon.color: content.textColorPressed
                }
            }
        }
    ]

    transitions: [
        Transition {
            to: "raised"
            // Reverses the Transition when the conditions that triggered this transition are reversed
            //reversible: true
            // Animate the properties changed via state, this allows us to choose when and how during the
            // state transition the properties are modified 
            ParallelAnimation {
                PropertyAnimation {
                    target: highlight
                    properties: "x,y,z,spread"
                    duration: bg.animSpeed
                    easing.type: bg.easingType
                }
                PropertyAnimation {
                    target: shadow
                    properties: "x,y,z,spread"
                    duration: bg.animSpeed
                    easing.type: bg.easingType
                }
                // NOTE: Seems ColorAnimation has a weird effect when the state change is reverted halfway through.  It appears to 
                // force the color property change to go all the way to the original target color instantly and then starts animating
                // the whole reverted transition.  PropertyAnimation seems to work fine instead.
                // UPDATE: This appears to be due to State Fast Forwarding (https://doc.qt.io/qt-6/qtquick-statesanimations-states.html#state-fast-forwarding)
                PropertyAnimation {
                    target: surface
                    properties: "color"
                    duration: bg.animSpeed
                    easing.type: bg.easingType
                }
                PropertyAnimation {
                    target: iconLabel
                    properties: "color,icon.color"
                    duration: bg.animSpeed
                    easing.type: bg.easingType
                }
            }
        },
        Transition {
            to: "pressed"
            // Reverses the Transition when the conditions that triggered this transition are reversed
            //reversible: true
            // Animate the properties changed via state, this allows us to choose when and how during the
            // state transition the properties are modified 
            ParallelAnimation {
                PropertyAnimation {
                    target: highlight
                    properties: "x,y,z,spread"
                    duration: bg.animSpeed
                    easing.type: bg.easingType
                }
                PropertyAnimation {
                    target: shadow
                    properties: "x,y,z,spread"
                    duration: bg.animSpeed
                    easing.type: bg.easingType
                }
                PropertyAnimation {
                    target: surface
                    properties: "color"
                    duration: bg.animSpeed
                    easing.type: bg.easingType
                }
                PropertyAnimation {
                    target: iconLabel
                    properties: "color,icon.color"
                    duration: bg.animSpeed
                    easing.type: bg.easingType
                }
            }
        }
    ]    
}
