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
                onValueChanged: (self) => {
                    print(self.value)
                    print(self)
                },
            })
            break
        default:
            print("Invalid CreateOptionWidget() type")
            return null
    }
}


// Load in options as widgets to destination FlowBox
export const LoadOptionWidgets = (options, dst) => {

    print("Loading options into widgets...")

    // Iterate over each option in the provided options object
    for (let key in options){
        let option = options[key]                   // The given option
        let widget = CreateOptionWidget(option)     // Returns reference to widget created from option

        // Add ref of created widget to option object
        options[key].widget = widget 

        // Add widget to destination FlowBox
        dst.add(Widget.CenterBox({
            class_name: "option-container",
            startWidget: Widget.Label({
                label: option.name,
                hpack: "start",
            }),
            endWidget: widget,
        }))
    } 
}

// Initilize options with data from json config
function InitilizeOptions(){
    data = JSON.parse(Utils.readFile(configPath + configName))
    if (data == null){
        print("ERROR: Parsing UserSettings.json failed")
        return
    }
    print("Initing user options")

    /*
    Example:
    {
        id: "gaps_in",                      // Unique identifer to be able to retrieve option value from json
        name: "Gaps in",                    // Human readable name
        type: "spin",                       // Type of widget
        widget: null,                       // Reference to widget
        value: data.options.gaps_in,        // Option value 
        min: 0,                             // Option min value
        max: 400,                           // Option max value 
        context: "hyprland",                // Context in which the option is applied 
        beforeStr: "general:gaps_in = ",    // Option string before value
        afterStr: "",                       // Option string after value
    }
    */
    
    Options.user = {
        gaps_in: {
            id: "gaps_in", 
            name: "Gaps in", 
            type: "spin", 
            widget: null, 
            value: data.options.gaps_in, 
            min: 0,
            max: 400, 
            context: "hyprland", 
            beforeStr: "general:gaps_in = ", 
            afterStr: ""
        },
        /*
        gaps_out: new Option(
            id: "gaps_out", 
            "Gaps out", 
            "spin", 
            null, 
            data.options.gaps_out, 
            0, 400, true, "", "general:gaps_out = ", ""),
        gaps_workspaces: new Option("gaps_workspaces", "Gaps workspaces", "slider", null, data.options.gaps_workspaces, 0, 400, true, "", "general:gaps_workspaces = ", ""),
        rounding: new Option("rounding", "Rounding", "slider", null, data.options.rounding, 0, 40, true, "", "decoration:rounding = ", ""),
        */
        //blur: new Option("blur", "Blur", "switch", null, "decoration:blur:enabled = ", data.options.blur, "", 0, 40),
        //sensitivity: new Option("sensitivity", "Sensitivity", "slider", null, "input:sensitivity = ", data.options.sensitivity, "", -1, 1),
    }
    print("User options initilized:")
    print(JSON.stringify(Options.user))
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
        print("Are the applied options being seen?")
        print("key = " + key)
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
        print("\n// DATA MODIFIED //\n")
        print(dataModified)

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


