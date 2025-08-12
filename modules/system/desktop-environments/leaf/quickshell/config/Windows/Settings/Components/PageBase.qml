pragma ComponentBehavior: Bound // allows for referencing of siblings

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// Template for settings pages
Rectangle {
    id: root
    required property string pageName
    required property Item content
    color: "#0000ff00"

    // Header
    Rectangle {
        id: header
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        implicitHeight: 64
        //color: "#22ff0000"
        color: "transparent"
        Text {
            anchors {
                verticalCenter: parent.verticalCenter
            }
            color: palette.text
            text: root.pageName
            font {
                bold: true
                pixelSize: 28
            }
        }
    }

    /*
    ScrollBar {
        id: scrollBar
        parent: root
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
    */
    Button {
        text: "scrollview"
        onClicked: {
            console.log(`scrollview width = ${scrollView.width}`)
            console.log(`scrollView = ${scrollView}`)
        }
    }

    // Content
    ScrollView {
        implicitWidth: parent.width
        id: scrollView
        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.bottom: parent.bottom

        //ScrollBar.vertical: scrollBar

        contentChildren: [ 
            // For some reason wrapping the content in an top center anchored Rectangle is needed to avoid weird
            // sizing issues for a Layout root.content type
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                implicitHeight: childrenRect.height
                color: "lightgreen"
                children: [ root.content ]
            }
        ]
    }
}
