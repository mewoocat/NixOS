
    Leaf.PanelItem { 
        isClickable: false
        rows: 2
        columns: 2
        content: RowLayout {
            anchors.centerIn: parent
            spacing: 0

            Ctrls.Slider {
                orientation: Qt.Vertical
                from: 0
                to: 2
                stepSize: 1
                snapMode: Slider.SnapOnRelease
                implicitHeight: powerProfileList.height
                value: PowerProfiles.profile // 0 - PowerSaver, 1 - Balanced, 2 - Perfomance
                onValueChanged: PowerProfiles.profile = value
            }
            ColumnLayout {
                id: powerProfileList
                spacing: 0
                Leaf.NormalButton {
                    visible: PowerProfiles.hasPerformanceProfile
                    //Layout.fillWidth: true
                    text: "Performance"
                    fontSize: 10
                    buttonHeight: 32
                    leftClick: () => PowerProfiles.profile = PowerProfile.Performance
                    highlight: PowerProfiles.profile == PowerProfile.Performance
                }
                Leaf.NormalButton {
                    //Layout.fillWidth: true
                    text: "Balanced"
                    fontSize: 10
                    buttonHeight: 32
                    leftClick: () => PowerProfiles.profile = PowerProfile.Balanced
                    highlight: PowerProfiles.profile == PowerProfile.Balanced
                }
                Leaf.NormalButton {
                    //Layout.fillWidth: true
                    text: "Low Power"
                    fontSize: 10
                    buttonHeight: 32
                    leftClick: () => PowerProfiles.profile = PowerProfile.PowerSaver
                    highlight: PowerProfiles.profile == PowerProfile.PowerSaver
                }
            }
        }
    }
