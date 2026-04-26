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
    function getIcon(node: PwNode): string {
        if (node === null) {
            return "audio-volume-off-symbolic"
        }
        if (node.audio.muted) {
            return "audio-volume-muted-symbolic"
        }
        const vol = node.audio.volume * 100
        switch (true) {
            case vol > 80: return "audio-volume-high-symbolic"
            case vol > 50: return "audio-volume-medium-symbolic"
            case vol > 0: return "audio-volume-low-symbolic"
            default: return "audio-volume-off-symbolic" // Why is this icon so much smaller
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
