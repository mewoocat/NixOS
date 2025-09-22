import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

WrapperMouseArea {
    id: root
    required property Item content
    property Component subContent: null
    property bool expanded: true
    property Item subContentLoader: Loader {
        visible: active // To unreserve space when the component isn't loaded
        active: true//root.expanded
        property Component things: root.subContent
        sourceComponent: things
    }

    rightMargin: 8 // Try to have this match the scrollbar width
    leftMargin: 8
    implicitWidth: parent.width
    hoverEnabled: true
    onClicked: {
        if (expanded) {
            background.implicitHeight = content.height
        }
        else {
            background.implicitHeight = content.height + subContentLoader.item.height
        }
        expanded = !expanded
    }
    
    WrapperRectangle {
        id: background
        clip: true
        color: root.containsMouse ? palette.alternateBase : "transparent"
        radius: 8

        onHeightChanged: console.log(`height: ${height}`)
        Behavior on implicitHeight {
            PropertyAnimation { 
                duration: 500
                easing.type: Easing.InOutQuint
            }
        }

        ColumnLayout {
            spacing: 0
            children: [ 
                root.content,
                root.subContentLoader
            ]
        }
    }
}
