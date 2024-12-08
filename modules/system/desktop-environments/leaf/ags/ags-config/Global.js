import Gtk from 'gi://Gtk'

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
