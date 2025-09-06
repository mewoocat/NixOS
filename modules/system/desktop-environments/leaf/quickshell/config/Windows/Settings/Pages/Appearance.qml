import "../Components"
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls

PageBase {
    id: root
    pageName: "Appearance"
    // Note that PageBase isn't the parent of this component
    // And that the width of a ColumnLayout is determined by it's children
    content: WrapperItem {
        margin: 24
        ColumnLayout {
            implicitWidth: root.width - 24 * 2
            spacing: 24
            OptionSection {
                name: "General"
                options: [
                    Option {
                        title: "Animations"
                        subtitle: "Whether to enable animations"
                        content: Switch {

                        }
                    },
                    Option {
                        title: "Rounding"
                        subtitle: "How much to round the corners"
                        content: SpinBox {

                        }
                    }
                ]
            }
        }
    }
}
