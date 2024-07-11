import GtkSessionLock from 'gi://GtkSessionLock'
import App from 'resource:///com/github/Aylur/ags/app.js';

// Check for support of the `ext-session-lock-v1` protocol
if (!GtkSessionLock.is_supported()) {
    print("Error: ext-session-lock-v1 is not supported") 
    App.quit()     
}


function onLocked(){
    print("Locked")
}

function onFinished(){
    print("Finished")
    GtkSessionLock.lock_destroy(lock)
    App.quit()     
}

print("Setting up lock")
const lock = GtkSessionLock.prepare_lock()
lock.lock_lock()
lock.connect("locked", onLocked())
lock.connect("finished", onFinished())

