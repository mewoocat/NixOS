pragma Singleton
import Quickshell

Singleton {
    function secToMinAndSec(seconds: int): string {
        const minutes = Math.floor(seconds / 60)
        var leftoverSeconds = Math.floor(seconds % 60)
        if (leftoverSeconds < 10) {leftoverSeconds = `0${leftoverSeconds}`}
        return `${minutes}:${leftoverSeconds}`
    }
}
