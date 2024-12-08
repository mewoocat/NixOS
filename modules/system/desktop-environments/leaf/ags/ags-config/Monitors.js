
import Gdk from 'gi://Gdk'

// Obtaining monitor information
const display = Gdk.Display.get_default()
const numMonitors = display.get_n_monitors()
export let monitors = {}
for (var i = 0; i < numMonitors; i++){
    var monitor = display.get_monitor(i)
    // Add monitor
    //monitors[`${i}`] = monitor.get_model();
    monitors[`${monitor.get_model()}`] = i;
    print("INFO: Detected monitor id " + i + " as " + monitor.get_model())
}

