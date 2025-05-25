pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import "root:/" as Root

Singleton {
    // Binding a Pipewire object makes all of its properties available
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    function enable() {
        console.log("Enabling sound service")
    }
    function getIcon(node: PwNode): string {
        if (node === null) {
            return "audio-volume-off"
        }
        if (node.audio.muted) {
            return "audio-volume-muted"
        }
        const vol = node.audio.volume * 100
        switch (true) {
            case vol > 80: return "audio-volume-high"
            case vol > 50: return "audio-volume-medium"
            case vol > 0: return "audio-volume-low"
            default: return "audio-off"
        }
    }
    function getVolume(node: PwNode): real {
        if (node === null) {
            return 0
        }
        return node.audio.volume
    }

}
