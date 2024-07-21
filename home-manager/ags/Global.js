import Gtk from 'gi://Gtk'

// Widget subclasses 
export const ComboBoxText = Widget.subclass(Gtk.ComboBoxText)
export const SearchEntry = Widget.subclass(Gtk.SearchEntry)

// Stack tabs
export const ControlPanelTab = Variable("main", {})
export const ControlPanelNetworkTab = Variable("networkMain", {})


// Window states
export const isLauncherOpen = Variable(false)
