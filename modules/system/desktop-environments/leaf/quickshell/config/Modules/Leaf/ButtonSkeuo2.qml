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
    padding: inset * 2

    // Defines the padding of the background
    property real inset: 6
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    implicitWidth: background.implicitWidth + leftInset + rightInset
    implicitHeight: background.implicitHeight + bottomInset + topInset
    background: Rectangle {
        id: bg
        implicitWidth: control.contentItem.implicitWidth + control.padding
        implicitHeight: 30 // control.contentItem.implicitHeight + control.padding // TODO: might want to force this to be static?
        color: "transparent"
        radius: 8 // This propagates to the children RectangularShadow's

        property int skeuo: 2
        property int blur: 4
        property int spread: 2 // increasing this causes the positions to get wack
        property int animSpeed: 500
        property var easingType: Easing.InOutCubic
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
        property color highlightColor: Qt.lighter(Root.State.colors.surface, 2)
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
            spread: bg.spread
            color: bg.highlightColor
        }

        Rectangle {
            id: surface
            implicitWidth: bg.implicitWidth
            implicitHeight: bg.implicitHeight
            radius: bg.radius
            //color: "transparent" // WARNING: Color set via state change
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
                    }
                    shadow {
                        x: bg.botLeftPos.x
                        y: bg.botLeftPos.y
                        z: -1 // show behind highlight
                    }
                    surface {
                        color: bg.surfaceColorRaised
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
                    }
                    shadow {
                        x: bg.topRightPos.x
                        y: bg.topRightPos.y
                    }
                    surface {
                        color: bg.surfaceColorPressed
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
                        properties: "x,y,z"
                        duration: bg.animSpeed
                        easing.type: bg.easingType
                    }
                    PropertyAnimation {
                        target: shadow
                        properties: "x,y,z"
                        duration: bg.animSpeed
                        easing.type: bg.easingType
                    }
                    ColorAnimation {
                        from: bg.surfaceColorPressed
                        to: bg.surfaceColorRaised
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
                        properties: "x,y,z"
                        duration: bg.animSpeed
                        easing.type: bg.easingType
                    }
                    PropertyAnimation {
                        target: shadow
                        properties: "x,y,z"
                        duration: bg.animSpeed
                        easing.type: bg.easingType
                    }
                    ColorAnimation {
                        from: bg.surfaceColorRaised
                        to: bg.surfaceColorPressed
                        duration: bg.animSpeed
                        easing.type: bg.easingType
                    }
                }
            }
        ]    
    }

    icon.name: ""
    icon.source: ""
    icon.width: 24
    icon.height: 24
    icon.color: "red"

    // The geometry of the contentItem is determined by the padding
    // IconLabel source: https://github.com/qt/qtdeclarative/blob/dev/src/quickcontrolsimpl/qquickiconlabel_p.h
    // Might want to look into IconImage (from the impl namespace, not qs) as well
    contentItem: Item {
        implicitHeight: iconLabel.implicitHeight
        implicitWidth: iconLabel.implicitWidth
        IconLabel {
            id: iconLabel
            icon.name: control.icon.name
            icon.color: Root.State.colors.on_surface
            text: control.text
            color: Root.State.colors.on_surface
            /*
            x: control.hovered ? 1 : 0
            y: control.hovered ? -1 : 0
            Behavior on x { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }
            Behavior on y { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }
            */
        }
    }
}
