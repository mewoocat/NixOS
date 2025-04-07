import Gtk from 'gi://Gtk'
import GLib from 'gi://GLib'

export const leafConfigDir = `${GLib.get_home_dir()}/.config/leaf-de`
export const leafDir = `${GLib.get_home_dir()}/.config/ags`

// Widget subclasses 
export const ComboBoxText = Widget.subclass(Gtk.ComboBoxText)
export const SearchEntry = Widget.subclass(Gtk.SearchEntry)
export const Grid = Widget.subclass(Gtk.Grid)

// Stack tabs
export const ControlPanelTab = Variable("main", {})
export const ControlPanelNetworkTab = Variable("main", {})
export const ControlPanelBluetoothTab = Variable("main", {})


// Window states
export const isLauncherOpen = Variable(false)
