
    Leaf.PanelItem { 
        isClickable: false
        rows: 2
        columns: 4
        content: WrapperRectangle {
            anchors.fill: parent
            color: "transparent"
            margin: 8

        ColumnLayout {    
            //anchors.fill: parent
            RowLayout {
                Ctrls.Button {
                    icon.name: Services.Audio.getIcon(Pipewire.defaultAudioSink)
                    text: {
                        return Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
                        /*
                        const vol = Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100
                        const spacing = 
                        const text = spacing + vol + '%'
                        */
                    }
                    onClicked: () => Root.State.controlPanelPage = 1
                    Layout.minimumWidth: 86
                }
                Ctrls.Slider {
                    Layout.fillWidth: true
                    from: 0
                    value: Services.Audio.getVolume(Pipewire.defaultAudioSink)
                    onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
                    to: 1
                }
            }

            RowLayout {
                Ctrls.Button {
                    icon.name: Services.Brightness.getIcon()
                    text: Math.ceil(Services.Brightness.value * 100) + '%'
                    onClicked: () => Root.State.controlPanelPage = 4
                    Layout.minimumWidth: 86
                }
                Ctrls.Slider {
                    Layout.fillWidth: true
                    from: 0.01
                    value: Services.Brightness.value
                    //stepSize: 0.01
                    onValueChanged: Services.Brightness.value = value
                    to: 1
                }
            }
        }
        }
