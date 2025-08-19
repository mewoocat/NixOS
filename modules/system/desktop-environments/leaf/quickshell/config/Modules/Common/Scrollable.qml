import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    required property Item content
    color: "#77000000"
    radius: 8

    ScrollBar {
        id: scrollBar
        parent: root
        anchors.left: scrollView.right
        //anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        policy: ScrollBar.AlwaysOn // Doesn't work?
    }

    // Content
    ScrollView {
        /*
        anchors.leftMargin: 16
        anchors.topMargin: 16
        anchors.bottomMargin: 16
        */
        //anchors.margins: 16

        implicitWidth: parent.width //- scrollBar.width
        id: scrollView
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        //ScrollBar.vertical: scrollBar

        // Idk why this works
        contentChildren: Rectangle {
            color: "transparent"
            //color: "#2200ff00"
            implicitWidth: scrollView.width - scrollBar.width
            implicitHeight: column.height + 16

            ColumnLayout {
                anchors.centerIn: parent
                id: column
                implicitWidth: parent.width - 16
                children: [ root.content ]
                Component.onCompleted: {
                    console.log(`column height: ${column.height}`)
                }
            }    
        }
        /*
        contentChildren: [ 
            WrapperRectangle {
                color: "blue"
                children: [ root.content ]
            }
        ]
        */
        /*
        contentChildren: Rectangle {
            implicitHeight: childrenRect.height
            implicitWidth: scrollView.width - scrollBar.width
            color: "transparent"

            children: [ root.content ]
        }
        */
    }
}
