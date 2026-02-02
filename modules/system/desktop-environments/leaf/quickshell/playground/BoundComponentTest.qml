pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

FloatingWindow {
    id: root
    color: "grey"

    Rectangle {
        id: box
        width: 400
        height: 400

        Loader {
            id: loader
            property Component boundComp: BoundComponent {
                component Thing: Text {
                    id: thing
                    text: "what"
                }
                sourceComponent: Thing {}
            }
            sourceComponent: boundComp
        }
    }
}
