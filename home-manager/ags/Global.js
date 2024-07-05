import Gtk from 'gi://Gtk'

// Widget subclasses 
export const ComboBoxText = Widget.subclass(Gtk.ComboBoxText)
export const SearchEntry = Widget.subclass(Gtk.SearchEntry)

export const ControlPanelTab = Variable("main", {})


// Window states
export const isLauncherOpen = Variable(false)