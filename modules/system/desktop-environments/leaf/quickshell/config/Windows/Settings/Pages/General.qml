import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../" as Root

PageBase {
    id: root
    pageName: "General"
    // Note that PageBase isn't the parent of this component
    // And that the width of a ColumnLayout is determined by it's children
    content: WrapperItem {
        margin: 24
        ColumnLayout {
            implicitWidth: root.width - 24 * 2
            PageSection {
                options: [
                    Option{},
                    Option{},
                    Option{},
                    Option{},
                    Option{},
                    Option{}
                ]
            }
        }
    }
}
