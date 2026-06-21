import QtQuick
import QtQuick.Controls.Basic
import Quickshell

FloatingWindow {
  color: "black"

  Button {
    text: "Open"
    onClicked: popup.visible = !popup.visible
  }

  ComboBox {
      id: comobobox
      model: ["adadafsd", "sopidfjpsdoif", "apdsoifjasd"]

  popup: Menu {
    id: popup

    //width : 600
    //popupType: Popup.Window

    //x: 100
    y: comobobox.height

    background: Rectangle {
      color: "white"
      radius: 12
      border.color: "grey"
    }

    enter: Transition {
      NumberAnimation {
        property: "height"
        from: 0
        to: implicitHeight
        duration: 2000
      }
    }

    exit: Transition {
      NumberAnimation {
        property: "height"
        from: implicitHeight
        to: 0
        duration: 2000
      }
    }

   contentItem: ListView {
      id: listView
      model: ["eiwf", "rgp.............iugheoiruhgpier", "rgrgrgrg"]//DesktopEntries.applications
      //anchors.fill: parent
      implicitHeight: contentItem.childrenRect.height
      implicitWidth: contentItem.childrenRect.width

      delegate: Text {
        required property var modelData
        
        text: modelData
      }
    }
  }
  }
}
