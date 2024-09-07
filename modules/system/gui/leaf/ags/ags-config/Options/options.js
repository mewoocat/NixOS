import GLib from 'gi://GLib';
import { exec, writeFile, writeFileSync, readFile } from 'resource:///com/github/Aylur/ags/utils.js'
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Gtk from 'gi://Gtk'
import { GenerateCSS } from '../Style/style.js'

// Configure animations
// I think this only applys the option to the default window
Gtk.Settings.get_default().gtk_enable_animations = true

let homeDir = GLib.get_home_dir()
let defaultConfig = `${App.configDir}/defaultUserSettings.json`
let configPath = `${homeDir}/.cache/ags/`
let configName = `UserSettings.json`

export const settingsChanged = Variable(false, {}) 
export var data = null;     // Json data

// Export an object which contains all option widgets
export var Options = {
    // Static system options
    system: {
        xsmall: "2",
        small: "4",
        medium: "6",
        large: "8",
        xlarge: "10",
        defaultMonitor: 1,
    },
    // User options read from json file
    user: null,
} 


// Create widget from option
export function CreateOptionWidget(option){
    switch(option.type){
        case "slider":
            return Widget.Slider({
                onChange: ({ value }) => {
                    settingsChanged.value = true
                    print(value)
                },
                hexpand: true,
                min: option.min,
                max: option.max,
                step: 1, // Only works for keybinds?
                value: data.options[option.id],
            })
            break
        case "switch":
            return Widget.Switch({
                onActivate: () => {
                    settingsChanged.value = true
                },
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
                    settingsChanged.value = true
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
    //data = JSON.parse(Utils.readFile(configPath + configName))
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

        gaps_out: {
            id: "gaps_out", 
            name: "Gaps out", 
            type: "spin", 
            widget: null, 
            value: data.options.gaps_out, 
            min: 0,
            max: 400, 
            context: "hyprland", 
            beforeStr: "general:gaps_out = ", 
            afterStr: ""
        },
        gaps_workspaces: {
            id: "gaps_workspaces",
            name: "Gaps workspaces",
            type: "spin",
            widget: null,
            value: data.options.gaps_workspaces,
            min: 0,
            max: 400, 
            context: "hyprland", 
            beforeStr: "general:gaps_workspaces = ", 
            afterStr: ""
        },
        rounding: {
            id: "rounding",
            name: "Rounding",
            type: "spin",
            widget: null,
            value: data.options.rounding,
            min: 0,
            max: 100, 
            context: "hyprland", 
            beforeStr: "decoration:rounding = ", 
            afterStr: ""
        },
        border_size: {
            id: "border_size",
            name: "Border size",
            type: "spin",
            widget: null,
            value: data.options.border_size,
            min: 0,
            max: 100, 
            context: "hyprland", 
            beforeStr: "general:border_size = ", 
            afterStr: ""
        },
        animations: {
            id: "animations",
            name: "Animations",
            type: "switch",
            widget: null,
            value: data.options.animations,
            min: null,
            max: null, 
            context: "hyprland", 
            beforeStr: "animations:enabled = ", 
            afterStr: ""
        },
        ags_animations: {
            id: "ags_animations",
            name: "Ags animations",
            type: "switch",
            widget: null,
            value: data.options.ags_animations,
            context: "ags", 
            callback: function () {
                // Set animation state to state of associated switch widget
                Gtk.Settings.get_default().gtk_enable_animations = this.widget.active
            }
        },
        default_monitor: {
            id: "default_monitor",
            name: "Default monitor",
            type: "spin",
            widget: null,
            value: data.options.default_monitor,
            min: 0,
            max: 10, 
            context: "ags", 
            callback: function () {

            }
        },
        ags_opacity: {
            id: "ags_opacity",
            name: "Ags opacity (stub)",
            type: "spin",
            widget: null,
            value: data.options.ags_opacity,
            min: 0,
            max: 100, 
            context: "ags", 
            callback: function () {
                print(`this.value = ${this.widget.value}`)
                // Modify variables.scss  
                let content = `
                    $mediumOpacity: ${this.widget.value / 100};
                `
                writeFileSync(content, `${App.configDir}/Style/variables.scss`)

                // Reload CSS
                GenerateCSS()

            }
        }
        //sensitivity: new Option("sensitivity", "Sensitivity", "slider", null, "input:sensitivity = ", data.options.sensitivity, "", -1, 1),
    }
    print("User options initilized:")
    print(JSON.stringify(Options.user, null, 4))
}


// Refreshes the contents of data
export function GetOptions() {
    // Read in user settings
    try {
        print(`Reading in ${configPath + configName}`)
        data = JSON.parse(Utils.readFile(configPath + configName))
        print(`Successfully read in ${configPath + configName}`)
        InitilizeOptions()
    } 

    // User setting file could not be read in, create default one and try again
    catch (error) {
        print(error)
        print(`Could not read ${configPath + configName}`)

        // Backup existing UserSettings.json
        print(`Backing up current UserSettings.json to ${configPath + configName + ".bak"}`)
        exec(`cp ${configPath + configName} ${configPath + configName + ".bak"}`)

        // Create default UserSettings.json
        const defaultConfigContents = readFile(defaultConfig)
        writeFileSync(defaultConfigContents, `${configPath + configName}`)

        // Retry loading in options
        try{
            print(`Retrying reading in ${configPath + configName}`)
            data = JSON.parse(Utils.readFile(configPath + configName))
            InitilizeOptions()
            print(`Successfully read in ${configPath + configName}`)
        }
        catch (error) {
            print(error)
            print("Something really really bad happened...")
            App.quit()
        }
    }
}


export function ApplySettings(){

    // Hyprland config contents to write to config file
    let hyprlandConfig = " \n"

    // Generate option -> config string literals
    for (let key in Options.user){
        let opt = Options.user[key]
        let value = -1

        // Get current value from associated widget
        if (opt.type === "spin" || opt.type === "slider"){
            value = Options.user[key].widget.value
        }
        else if (opt.type === "switch"){
            value = Options.user[key].widget.active
        }
        else{
            print("ERROR: Invalid option type in ApplySettings()")
        }

        // Set the updated value in the json cache
        data.options[key] = value

        if (opt.context == "ags"){
            opt.callback()  
        }     

        // Generates hyprland config literal
        else if (opt.context == "hyprland"){
            hyprlandConfig = hyprlandConfig.concat(opt.beforeStr + value + opt.afterStr + "\n")
        }

    }

    // Write out Hyprland settings files
    writeFile(hyprlandConfig, `${App.configDir}/../../.cache/hypr/userSettings.conf`)
        .then(file => print('LOG: Hyprland settings file updated'))
        .catch(err => print(err))
    // Reload hyprland config
    Hyprland.messageAsync(`reload`)

    // Modified user settings json
    let dataModified = JSON.stringify(data, null, 4)
    // Write out to UserSettings.json
    writeFileSync(dataModified, `${App.configDir}/../../.cache/ags/UserSettings.json`)
        .then(file => print('LOG: User settings file updated'))
        .catch(err => print(err))
}

// Reverts any changed options to their original values since the last apply
export function RevertSettings(){
    for (let key in Options.user){
        const option = Options.user[key]
        const widget = option.widget // Gets a reference to the given option's widget
        const previousValue = data.options[option.id]

        if (option.type == "spin"){
            widget.value = previousValue
        }
        else if (option.type == "switch"){
            widget.active = previousValue
        }
    }
    settingsChanged.value = false 
}
