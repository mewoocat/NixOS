import GLib from 'gi://GLib';
import { exec, writeFile, writeFileSync, readFile } from 'resource:///com/github/Aylur/ags/utils.js'
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Gtk from 'gi://Gtk'

// Configure animations
// I think this only applys the option to the default window
Gtk.Settings.get_default().gtk_enable_animations = true

let homeDir = GLib.get_home_dir()
let defaultConfig = `${App.configDir}/defaultUserSettings.json`
let configPath = `${homeDir}/.cache/ags/`
let configName = `UserSettings.json`

// Export an object which contains all option widgets
export var Options = {
    // Static system options
    system: {
        xsmall: "2",
        small: "4",
        medium: "6",
        large: "8",
        xlarge: "10",
    },
    // User options read from json file
    user: null,
} 
export var data = null;     // Json data

// Option types
// - User
//     - Ags/Gtk:       Controlled internally
//     - Hyprland:      Controlled via config file 
// - System
//     - Ags/Gtk:       Controlled internally


// Option object constructor
function Option(id, name, type, widget, value, min, max, external, configFile, beforeStr, afterStr) {
    this.id = id                    // Unique identifer to be able to retrieve option value from json
    this.name = name                // Human readable name
    this.type = type                // Type of widget
    this.widget = widget            // Reference to widget
    this.value = value              // Option value
    this.min = min                  // Option min value
    this.max = max                  // Option max value
    this.external = external        // Contains bool
    this.configFile = configFile      // Config file where option string will be appended
    this.beforeStr = beforeStr        // Option string before value
    this.afterStr = afterStr          // Option string after value
}


// Create widget from option
export function CreateOptionWidget(option){
    switch(option.type){
        case "slider":
            return Widget.Slider({
                onChange: ({ value }) => print(value),
                hexpand: true,
                min: option.min,
                max: option.max,
                step: 1, // Only works for keybinds?
                value: data.options[option.id],
            })
            break
        case "switch":
            return Widget.Switch({
                class_name: "switch-button",
                hpack: "end",
                active: data.options[option.id],
            })
            break
        case "spin":
            return Widget.SpinButton({
                class_name: "spin-button",
                hpack: "end",
                range: [option.min, option.max],
                increments: [1, 5],
                value: data.options[option.id],
                onValueChanged: ({ value }) => {
                    print(value)
                },
            })
            break
        default:
            print("Invalid CreateOptionWidget() type")
            return null
    }
}



// function Option(id, name, type, widget, value, min, max, external, configFile, beforeStr, afterStr) {

// Initilize options with data from json config
function InitilizeOptions(){
    data = JSON.parse(Utils.readFile(configPath + configName))
    if (data == null){
        return
    }
    Options.user = {
        gaps_in: new Option("gaps_in", "Gaps in", "spin", null, data.options.gaps_in, 0, 400, true, "", "general:gaps_in = ", ""),
        //gaps_out: new Option("gaps_out", "Gaps out", "spin", null, "general:gaps_out = ", data.options.gaps_out, "", 0, 400),
        //gaps_workspaces: new Option("gaps_workspaces", "Gaps workspaces", "slider", null, "general:gaps_workspaces = ", data.options.gaps_workspaces, "", 0, 400),
        //rounding: new Option("rounding", "Rounding", "slider", null, "decoration:rounding = ", data.options.rounding, "", 0, 40),
        //blur: new Option("blur", "Blur", "switch", null, "decoration:blur:enabled = ", data.options.blur, "", 0, 40),
        //sensitivity: new Option("sensitivity", "Sensitivity", "slider", null, "input:sensitivity = ", data.options.sensitivity, "", -1, 1),
    }
    print("//////////////////////////Options.user")
    print(Options.user)
}


// Refreshes the contents of data
export function GetOptions() {
    // Read in user settings
    try {
        print(`Reading in ${configPath + configName}`)
        data = JSON.parse(Utils.readFile(configPath + configName))
        InitilizeOptions()
    } 

    // user setting file could not be read in, create default one
    catch (error) {
        print(`Could not read ${configPath + configName}`)
        print(error)
        const defaultConfigContents = readFile(defaultConfig)
        writeFileSync(defaultConfigContents, `${configPath + configName}`)
        // TODO: probably need to try again here
    }

}


export function ApplySettings(){

    // Contents to write to config file
    let contents = " \n"

    // Generate option -> config string literals
    for (let key in Options.user){
        //print("key = " + key)
        let opt = Options.user[key]
        let value = -1

        // Get current value from associated widget
        if (opt.type === "spin" || opt.type === "slider"){
            value = Options.user[key].widget.value
            print("///OPRION REF///////////////")
            print(Options.user[key].widget)
            print(value)
        }
        else if (opt.type === "switch"){
            value = Options.user[key].widget.active
        }
        else{
            print("ERROR: Invalid option type in ApplySettings()")
        }

        data.options[key] = value
        contents = contents.concat(opt.beforeStr + value + opt.afterStr + "\n")

        // User settings json
        let dataModified = JSON.stringify(data)

        // Write out user settings json
        Utils.writeFileSync(dataModified, `${App.configDir}/../../.cache/ags/UserSettings.json`)
    }
    //print("contents = " + contents)

    // Write out new settings file
    Utils.writeFile(contents, `${App.configDir}/../../.cache/hypr/userSettings.conf`)
        .then(file => print('Settings file updated'))
        .catch(err => print(err))

    // Reload hyprland config
    Hyprland.messageAsync(`reload`)
}


