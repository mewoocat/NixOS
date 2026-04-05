
    Leaf.PanelItem { 
        rows: 1
        columns: 1
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("media-record-symbolic")
            // Recolor
            layer.enabled: false
            layer.effect: MultiEffect {
                colorization: 1 // Full re-color
                colorizationColor: "red"
            }
        }
        onClicked: () => Services.ScreenCapture.toggleRecording()
        isActive: Services.ScreenCapture.recording
    }
