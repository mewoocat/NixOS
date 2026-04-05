
    Leaf.PanelItem { 
        rows: 1
        columns: 1
        onClicked: () => Services.NightLight.toggle()
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: `file://${Quickshell.shellDir}/Icons/nightlight-symbolic.svg` // For some reason configDir exists but shellRoot doesn't

            // Recolor
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1 // Full re-color
                colorizationColor: palette.text
            }
        }
    }
