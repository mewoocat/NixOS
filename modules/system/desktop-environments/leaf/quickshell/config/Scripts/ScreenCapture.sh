#!/bin/sh

recordingPID=""

stopRecording() {
    notify-send "Stopped Recording Screen!"
    kill "$recordingPID"
    quickshell ipc call control stopRecording
    exit
}

trap stopRecording TERM # Run command on SIGTERM

#mkdir ~/Screenrecordings;

geometry="$(slurp)"

quickshell ipc call control recordingStarted
if [ "$?" -ne 0 ]; then
    echo "Could not execute Quickshell IPC command, exiting..."
    notify-send "Error recording screen :("
    exit 1
fi

notify-send "Recording Screen!"
wf-recorder \
  -f ~/Screenrecordings/recording_"$(date +\'%b-%d-%Y-%I:%M:%S-%P\')".mp4 \
  -g "$geometry" \
  --pixel-format yuv420p & # Start in background
recordingPID=$! # Get process id of last command

# Wait for the recording process to finish.
# Keeps the script running while the recording is happening
# Also note that if a command is waiting to complete (i.e. wf-recorder
# is currently running in the foreground of this script) when a signal 
# for a trap is set (i.e. TERM), the trap won't fire.  But if its 
# running the wait command, the wait command will return immediately
# when the signal is received and then the handler is executed.
wait $recordingPID

