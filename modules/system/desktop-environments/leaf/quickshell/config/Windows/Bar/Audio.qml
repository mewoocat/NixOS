import QtQuick
import Quickshell.Services.Pipewire
import "root:/Modules/Ui" as Ui
import "root:/" as Root

Ui.NormalButton {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    leftClick: () => {}
    // Doesn't seem to be available on the sink?
    //iconName: Pipewire.defaultAudioSink.properties["application.iconName"]
    iconName: {
        let vol = Pipewire.defaultAudioSink.audio.volume * 100
        switch (true) {
            case vol > 80: return "audio-volume-high"
            case vol > 50: return "audio-volume-medium"
            case vol > 0: return "audio-volume-low"
            case vol === 0: return "audio-ready"
            default: return "audio-off"
        }
    }
    text: {
        const vol = Pipewire.defaultAudioSink.audio.volume
        return Math.ceil(vol * 100) + '%'
    }
}
