// With this line the type becomes a singleton
// A singleton object has only one instance, and is accessible from any scope
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Singletons should always have the Singleton as the type
Singleton {
    property string time

    // Create a process management object
    Process {
        // An ID to refer to this with
        id: dateProc
        // The command to run, every argument is it's own string
        command: ["date"]
        // Run the command immediately
        running: true
        // Process the stdout stream using a SplitParser
        // which returns chunks of output after a delimiter
        stdout: SplitParser {
            // Listen for the read signal, which returns the data
            // that was read from stdout, then write that data to
            // the clock's text
            onRead: data => time = data
        }
    }

    // Use a timer to rerun the process at an interval
    Timer {
        interval: 1000
        // Start the timer immediately
        running: true
        // Run the timer again when it ends
        repeat: true

        // When the timer is triggered, set the running property
        // process to true, which reruns it if stopped
        onTriggered: dateProc.running = true
    }
}
