import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import "../../" as Root
import "../../Modules/Common" as Common
import "./Pages" as Pages

Common.PanelWindow {
    id: root
    name: "controlPanel"
    visible: Root.State.controlPanelVisibility

    /*
    property int unitSize: 86
    implicitWidth: unitSize * 4
    implicitHeight: unitSize * 6
    */
    //implicitWidth: 400
    //implicitHeight: 400
    //
    implicitWidth: content.width
    implicitHeight: content.height

    toggleWindow: () => {
        Root.State.controlPanelVisibility = !Root.State.controlPanelVisibility
        console.log(swipeView.contentChildren[0].width + "x" + swipeView.contentChildren[0].height)
        console.log("test: " + swipeView.test)
    } 
    closeWindow: () => {
        Root.State.controlPanelVisibility = false
    } 
    anchors {
        top: true
        right: true
    }

    //content: Pages.Main {} 
    content: SwipeView {
        Component.onCompleted: {
            console.log(`${itemAt(0).implicitWidth} x ${itemAt(0).implicitHeight}`)
            console.log(currentItem)
        }
        id: swipeView

        // can't use contentHeight since it uses the implicit size of the children
        // and due to a bug, we need to use non implicit size for the grid child

        // Need to use implicit sizes here for some reason
        // In order to properly size this element to the GridLayout child with no fixed size
        implicitWidth: itemAt(0).implicitWidth
        implicitHeight: itemAt(0).implicitHeight
        currentIndex: Root.State.controlPanelPage

        property Item test: main

        // Multiple items here seems to make the width of the swipeview expand when accessed?
        Pages.Main {
            id: main
            //unitSize: root.unitSize
        } 
        Pages.Audio {}
        Pages.Network {}

        /*
        PageIndicator {
            id: pageIndicator
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            //anchors.bottom: swipeView.bottom
            //anchors.horizontalCenter: parent.horizontalCenter
            Layout.alignment: Qt.AlignHCenter
        }
        */
    }
}
