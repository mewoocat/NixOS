pragma Singleton

import Quickshell

Singleton {
    
    // Used to make a client name more human readable
    // TODO: Refractor
    function formatClientName(input: string): string {
        if (input.startsWith("org.") || input.startsWith("com.")){
            let pathList = input.split('.')
            input = pathList[pathList.length - 1]
        }
        if (input.length > 0){
            return input[0].toUpperCase() + input.slice(1)
        }
        return "?"
    }
}
