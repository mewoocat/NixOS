import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import "../../" as Root
import "../../Modules/Common" as Common
import "./Pages" as Pages

Common.PopupWindow {
    id: root
    name: "controlPanel"
    visible: Root.State.controlPanelVisibility

    /*
    property int unitSize: 86
    implicitWidth: unitSize * 4
    implicitHeight: unitSize * 6
    */
    implicitWidth: content.width
    implicitHeight: content.height
    //implicitWidth: 400
    //implicitHeight: 400

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

    //content: Pages.Main {} 
    content: SwipeView {
        // Need to calculate these based on rows, cols, and unitSize of main panel grid
        // That what it ensures that all pages will show as the same size
        implicitWidth: 320 
        implicitHeight: 480
        //anchors.fill: parent
        id: stackView
        //width: 300
        // can't use contentHeight since it uses the implicit size of the children
        // and due to a bug, we need to use non implicit size for the grid child

        //implicitHeight: currentItem.height
        //implicitWidth: currentItem.width
        currentIndex: Root.State.controlPanelPage

        // Multiple items here seems to make the width of the swipeview expand when accessed?
        Pages.Main {
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
