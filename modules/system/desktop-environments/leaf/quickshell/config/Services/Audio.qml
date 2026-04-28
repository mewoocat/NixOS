pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import qs as Root

Singleton {
    // Binding a Pipewire object makes all of its properties available
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Track all nodes outputting to the default output
    // Useful for mixer entries
    property PwNodeLinkTracker defaultOutputLinkTracker: PwNodeLinkTracker {
        node: Pipewire.defaultAudioSink
    }

    //////////////////////////////////////////////////////////////// 
    // Functions
    //////////////////////////////////////////////////////////////// 
    
    function enable() {
        //console.log("Enabling sound service")
    }
    // For use with a QT icon pack
    function getIconName(node: PwNode): string {

        // Ensure node is set and is bound
        if (!node || !node.ready) { return "audio-volume-off-symbolic" }
        const properties = node.properties

        // First try the app icon-name
        const iconName = properties["application.icon-name"] // Can be ""
        if (iconName) {
            // Passing in true for the second param will return an empty string if icon is not found
            const iconAttempt = Quickshell.iconPath(iconName, true)
            if (iconAttempt) return iconName
        }
        // If none is found try the app name
        const appName = properties["application.name"]?.toLowerCase()
        console.debug(`appName: ${appName}`)
        if (appName) {
            const nameAttempt = Quickshell.iconPath(appName, true)
            console.debug(`nameAttempt: ${nameAttempt}`)
            if (nameAttempt) return appName
        }

        if (node.audio.muted) {
            return "audio-volume-muted-symbolic"
        }
        const vol = node.audio.volume * 100
        switch (true) {
            case vol > 80: return "audio-volume-high-symbolic"
            case vol > 50: return "audio-volume-medium-symbolic"
            case vol > 0: return "audio-volume-low-symbolic"
            default: return "audio-volume-off-symbolic"
        }
    }
    // For use with the Material Symbols font
    function getGlyph(node: PwNode): string {
        if (node === null) {
            return "volume_off"
        }
        if (node.audio.muted) {
            return "volume_off"
        }
        const vol = node.audio.volume * 100
        switch (true) {
            case vol > 80: return "volume_up"
            case vol > 50: return "volume_down"
            case vol > 0: return "volume_mute"
            default: return "volume_off"
        }
    }
    function getVolume(node: PwNode): real {
        if (node === null) {
            return 0
        }
        return node.audio.volume
    }

    property list<PwNode> outputDevices: Pipewire.nodes.values
        .filter(n => n.isSink) // filter nodes for sinks (Output devices)
        .filter(n => !n.isStream) // filter only hardware

}
