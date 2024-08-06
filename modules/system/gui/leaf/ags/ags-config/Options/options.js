import GLib from 'gi://GLib';
import { exec, writeFile, writeFileSync, readFile } from 'resource:///com/github/Aylur/ags/utils.js'

let homeDir = GLib.get_home_dir()
let defaultConfig = `${App.configDir}/defaultUserSettings.json`
let configPath = `${homeDir}/.cache/ags/`
let configName = `UserSettings.json`

export var Options = null   // Options object
export var data = null;     // Json data


// Hyprland Option object constructor
function Option(identifer, name, type, widget, before, value, after, min, max) {
    this.identifer = identifer  // Unique reference to option 
    this.name = name            // Human readable name
    this.type = type            // Type of widget
    this.widget = widget        // Reference to widget
    this.before = before        // Option string before value
    this.value = value          // Option value
    this.after = after          // Option string after value
    this.min = min              // Option min value
    this.max = max              // Option max value
}

// Development options
export const opt = {
    // In rem
    xsmall: "2",
    small: "4",
    medium: "6",
    large: "8",
    xlarge: "10",
}

function InitilizeOptions(){
    data = JSON.parse(Utils.readFile(configPath + configName))
    if (data == null){
        return
    }
    Options = {
        gaps_in: new Option("gaps_in", "Gaps in", "spin", null, "general:gaps_in = ", data.options.gaps_in, "", 0, 400),
        gaps_out: new Option("gaps_out", "Gaps out", "spin", null, "general:gaps_out = ", data.options.gaps_out, "", 0, 400),
        gaps_workspaces: new Option("gaps_workspaces", "Gaps workspaces", "slider", null, "general:gaps_workspaces = ", data.options.gaps_workspaces, "", 0, 400),
        rounding: new Option("rounding", "Rounding", "slider", null, "decoration:rounding = ", data.options.rounding, "", 0, 40),
        blur: new Option("blur", "Blur", "switch", null, "decoration:blur:enabled = ", data.options.blur, "", 0, 40),
        sensitivity: new Option("sensitivity", "Sensitivity", "slider", null, "input:sensitivity = ", data.options.sensitivity, "", -1, 1),
    }
}


// Refreshes the contents of data
export function GetOptions() {
    // Read in user settings
    try {
        print(`Reading in ${configPath + configName}`)
        data = JSON.parse(Utils.readFile(configPath + configName))
    } 

    // user setting file could not be read in, create default one
    catch (error) {
        print(`Could not read ${configPath + configName}`)
        print(error)
        const defaultConfigContents = readFile(defaultConfig)
        writeFileSync(defaultConfigContents, `${configPath + configName}`)
    }

    InitilizeOptions()
}

GetOptions()


