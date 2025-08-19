import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs as Root
import qs.Modules.Common as Common
import "./Pages" as Pages

Common.PanelWindow {
    id: root
    name: "controlPanel"
    visible: Root.State.controlPanelVisibility

    // Make window size according to it's content
    implicitWidth: content.width
    implicitHeight: content.height 

    toggleWindow: () => {
        Root.State.controlPanelVisibility = !Root.State.controlPanelVisibility
    } 
    closeWindow: () => {
        Root.State.controlPanelVisibility = false
    } 
    anchors {
        top: true
        right: true
    }

    content: SwipeView {
        id: swipeView
        currentIndex: Root.State.controlPanelPage
        //background: Rectangle {
        //    color: "transparent"
        //}

        // Set size to first child element
        // Need to use implicit sizes here for some reason
        // In order to properly size this element to the GridLayout child with no fixed size
        implicitWidth: itemAt(0).implicitWidth
        implicitHeight: itemAt(0).implicitHeight

        // Multiple items here seems to make the width of the swipeview expand when accessed?
        Pages.Main {} 
        Pages.Audio {}
        Pages.Network {}

        //PageIndicator {
        //    id: pageIndicator
        //    count: swipeView.count
        //    currentIndex: swipeView.currentIndex
        //    //anchors.bottom: swipeView.bottom
        //    //anchors.horizontalCenter: parent.horizontalCenter
        //    Layout.alignment: Qt.AlignHCenter
        //}
    }
}
