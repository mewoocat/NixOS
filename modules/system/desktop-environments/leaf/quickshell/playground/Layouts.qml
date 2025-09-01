import QtQuick
import QtQuick.Layouts
import Quickshell

FloatingWindow {
  color: "grey"

  Rectangle {
    implicitWidth: 300
    implicitHeight: 300
    anchors.centerIn: parent

    RowLayout {
      spacing: 0
      anchors.fill: parent

      ColumnLayout {
        id: column
        spacing: 0

        // In here this has no effect here as you specified a fillWidth/height for
        // the blue rect; so it tries to push in every direction it can
        // and it's just prefered width to the column in case it doesn't have one
        // but if the column has a child that has fill width; it will make it grow in
        // size until the column is hit by a limit; which is the other column size limit
        // uncomment it and see that it has no effect
        // Layout.preferredWidth: 100

        // but here now; u made the maximum size of the column layout to be 100; so if it
        // has a child with fillwidth; the item will grow until it hits a limit; which is
        // the column 100 maximum width; even if a child has a width more than 100; it will
        // be limited to 100 only
        // uncomment it and see the effect
        // Layout.maximumWidth: 100

        Rectangle {
          implicitWidth: 100
          implicitHeight: 100
          color: "red"

          Text {
            text: column.width
            anchors.centerIn: parent
          }
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          color: "blue"
        }
      }

      ColumnLayout {
        spacing: 0

        Rectangle {
          implicitWidth: 100
          implicitHeight: 100
          color: "green"
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          color: "orange"
        }
      }
    }
  }
}
