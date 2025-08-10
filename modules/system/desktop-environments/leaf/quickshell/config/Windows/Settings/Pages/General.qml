import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../" as Root
import "../Components"

PageBase {
    id: root
    pageName: "General"
    // Note that PageBase isn't the parent of this component
    // And that the width of a ColumnLayout is determined by it's children
    content: WrapperItem {
        margin: 24
        ColumnLayout {
            implicitWidth: root.width - 24 * 2
            spacing: 24
            OptionSection {
                name: "Input"
                options: [
                    SwitchOption {},
                    ComboOption {},
                    SliderOption {},
                    SpinOption {},
                    TextOption {}
                ]
            }

            OptionSection {
                name: "Other"
                options: [
                    SwitchOption {},
                    SwitchOption {},
                    SwitchOption {},
                    SwitchOption {}
                ]
            }
        }
    }
}
