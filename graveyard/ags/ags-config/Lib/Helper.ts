import Utils from 'resource:///com/github/Aylur/ags/utils.js';
import icons from '../icons.js'


// Used to make a client name more human readable
export function formatClientName(input: string) {
    if (input.startsWith("org.") || input.startsWith("com.")){
        let pathList = input.split('.')
        input = pathList[pathList.length - 1]
    }
    if (input.length > 0){
        return input[0].toUpperCase() + input.slice(1)
    }
    return "Desktop"
}

// Lookup an icon for a client
export function lookupClientIcon(clientClass: string) {
    const icon = Utils.lookUpIcon(clientClass)
    if (icon) {
        // icon is the corresponding Gtk.IconInfo
        return clientClass
    }
    else {
        // null if it wasn't found in the current Icon Theme
        // Return place holder icon
        return icons.desktop
    }
}
