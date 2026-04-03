import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs as Root
import qs.Modules.Leaf as Leaf
import qs.Components.Controls as Ctrls
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

AbsGrid.WidgetDefinition {
    uid: "calendar-3x3"
    name: "Calendar"
    xSize: 3
    ySize: 3
    defaultState: null
    component: Item {
        anchors.fill: parent
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            RowLayout {
                spacing: 0
                Layout.fillWidth: true
                Ctrls.Button {
                    Layout.alignment: Qt.AlignLeft
                    icon.name: "arrow-left"
                    onClicked: () => {
                        if (monthGrid.month === Calendar.January) {
                            monthGrid.month = Calendar.December
                        }
                        else {
                            monthGrid.month += -1
                        }
                    }
                }
                Text {
                    Layout.fillWidth: true
                    text: monthGrid.locale.monthName(monthGrid.month)
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 10
                    color: Root.State.colors.on_surface
                }
                Ctrls.Button {
                    icon.name: "arrow-right"
                    onClicked: () => {
                        if (monthGrid.month === Calendar.December) {
                            monthGrid.month = Calendar.January
                        }
                        else {
                            monthGrid.month += 1
                        }
                    }
                }
            }
            MonthGrid {
                id: monthGrid
                spacing: 0
                delegate: Rectangle {
                    id: day
                    required property var model
                    radius: 20
                    implicitHeight: text.height
                    implicitWidth: text.width
                    color: model.today ? Root.State.colors.primary : "transparent"
                    Text {
                        anchors.centerIn: parent
                        id: text
                        text: day.model.day
                        padding: 4
                        color: day.model.today ? Root.State.colors.on_primary : Root.State.colors.on_surface
                        opacity: day.model.month != monthGrid.month ? 0.3 : 1
                        font.pointSize: 10
                    }
                }
            }
        }
    }
}
