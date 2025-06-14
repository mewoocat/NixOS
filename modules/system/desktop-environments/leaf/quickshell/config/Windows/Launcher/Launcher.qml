pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

import "../../" as Root
import "../../Modules/Common" as Common
import "../../Modules" as Modules
import "../../Services" as Services

Common.PopupWindow {
    // Doesn't seem to force focus
    //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    id: launcher
    name: "launcher"
    // Stores the current search
    property string searchText: ""
    
    closeWindow: () => {
        Root.State.launcherVisibility = false
        searchText = "" 
        textField.text = ""
        listView.currentIndex = 0
    }

    toggleWindow: () => {
        Root.State.launcherVisibility = !Root.State.launcherVisibility
        searchText = "" 
        textField.text = ""
        listView.currentIndex = 0
    }


    function launchApp(app: DesktopEntry) {
        console.log(`Launching app: ${app.id}`)
        Services.Applications.incrementFreq(app.id) // Update it's frequency
        app.execute()
        launcher.closeWindow() // Needs to be after the execute since this will reset the current index?
    }

    visible: Root.State.launcherVisibility
    anchors {
        top: true
        left: true
    }
    focusable: true // Enable keyboard focus
    implicitWidth: 400
    implicitHeight: 460
    color: "transparent"
    margins {
        left: 16
        top: 16
    }
    content: Rectangle {
        anchors.fill: parent
        //color: "#aa000000"
        color: palette.window
        radius: 12
        RowLayout {
            spacing: 0
            anchors.fill: parent

            // Left side panel
            ColumnLayout {
                Layout.margins: 4
                Layout.fillHeight: true
                spacing: 0

                //Rectangle {implicitWidth: 32;Layout.fillHeight: true;color: "red"}
                // Top
                // Pinned apps
                ColumnLayout { 
                    spacing: 0
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.fillHeight: true
                    Repeater {
                        model: Root.State.config.pinnedApps
                        delegate: SidePanelItem {
                            id: item
                            required property string modelData
                            property alias appId: item.modelData // Aliasing a sibling property requires accessing via an id?
                            property DesktopEntry desktopEntry: Services.Applications.findDesktopEntryById(appId)
                            Component.onCompleted: console.log(`comp app id: ${appId}`)
                            imgPath: Quickshell.iconPath(desktopEntry.icon)
                            action: desktopEntry.execute
                        }
                    }
                }
                Item {Layout.fillHeight: true;} // Idk why, but needed to push the siblings to the top and bottom
                // Bottom
                ColumnLayout {
                    spacing: 0
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    

                    // Power options popup menu
                    // TODO: refractor this into it's own file
                    // TODO: wrap in loader so that popup is only loaded when it needs to be seen
                    // TODO: Fix issue with moving mouse too slow from button to popupwindow where the popup window 
                    //       doesn't receive focus right away and thus gets hidden before it can be hovered
                    PopupWindow {
                        id: popup

                        /////////////////////////////////////////////////////////////////////////
                        // Close on click away:
                        // Create a timer that sets the grab active state after a delay
                        // Used to workaround a race condition with HyprlandFocusGrab where the onVisibleChanged
                        // signal for the window occurs before the window is actually created
                        // This would cause the grab to not find the window
                        Timer {
                            id: delay
                            triggeredOnStart: false
                            interval: 100
                            repeat: false
                            onTriggered: {
                                console.log('popup grab triggered')
                                Root.State.popupActive = true
                                grab.active = popup.visible
                            }
                        }
                        // Connects to the launcher onVisibleChanged signal
                        // Starts a small delay which then sets the grab active state to match the 
                        Connections {
                            target: popup
                            function onVisibleChanged() {
                                // Only start grab if popup was just made visible
                                if (popup.visible) {
                                    delay.start()
                                }
                            }
                        }
                        HyprlandFocusGrab {
                            id: grab
                            active: false
                            windows: [ 
                                popup, // Self
                            ]
                            // Function to run when the Cleared signal is emitted
                            onCleared: () => {
                                console.log('cleared popup')
                                popup.visible = false
                                Root.State.popupActive = false
                            }
                        }

                        anchor {
                            window: launcher
                            item: power
                            edges: Edges.Bottom | Edges.Right
                            gravity: Edges.Top | Edges.Right
                            /*
                            rect.y: 1 // Push the window down a pixel to not have it skip between hoving
                                      // the button and popup
                            */
                        }
                        //visible: power.containsMouse || popupArea.containsMouse
                        visible: false
                        //TODO: causes crash
                        onVisibleChanged: {
                            console.log('on vis change')
                            // If just became visible
                            if (popup.visible) {
                                Root.State.focusGrabIgnore.push(popup) // Add the popup to the ignore list, so that it can receive mouse focus
                            }
                            // Else just hidden
                            /*
                            else {
                                // Remove self from the ignore list
                                const popupIndex = Root.State.focusGrabIgnore.indexOf(popup)
                                Root.State.focusGrabIgnore.splice(popupIndex, 1)
                            }
                            */
                        }
                        implicitWidth: popupArea.width
                        implicitHeight: popupArea.height
                        color: "transparent"
                        WrapperMouseArea {
                            id: popupArea
                            enabled: true
                            focus: true
                            hoverEnabled: true
                            onEntered: { console.log("entered") }
                            onExited: { console.log("exited") }
                            WrapperRectangle {
                                id: box
                                //color: palette.window
                                color: "#aa111111"
                                radius: 8
                                margin: 8
                                ColumnLayout {
                                    PopupMenuItem { text: "Shutdown"; action: ()=>{}; iconName: "system-shutdown-symbolic"}
                                    PopupMenuItem { text: "Hibernate"; action: ()=>{}; iconName: "system-shutdown-symbolic"}
                                    PopupMenuItem { text: "Restart"; action: ()=>{}; iconName: "system-restart-symbolic"}
                                    PopupMenuItem { text: "Sleep"; action: ()=>{}; iconName: "system-suspend-symbolic"}
                                }
                            }
                        }
                    }
                    SidePanelItem {
                        id: power
                        imgPath: Quickshell.iconPath('system-shutdown-symbolic')
                        imgSize: 22
                        action: () => {
                            popup.visible = true
                        }
                    }
                    SidePanelItem {
                        onClicked: Root.State.settings.openWindow()
                        imgPath: Quickshell.iconPath('systemsettings')
                    }
                    ProfilePictureItem {}
                }
            }

            // Search and app list
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Search field
                Rectangle {
                    color: "transparent"
                    implicitHeight: 48
                    Layout.fillWidth: true
                    //Layout.fillHeight: true
                    TextField {
                        id: textField
                        focus: true // Make this have focus by default
                        placeholderText: "Search..."
                        anchors.margins: 8
                        anchors.fill: parent
                        leftPadding: 12
                        rightPadding: 12
                        background: Rectangle {
                            color: palette.active.base
                            radius: 16
                        }
                        onTextChanged: () => {
                            launcher.searchText = text
                            listView.currentIndex = 0
                        }
                        Keys.onUpPressed: {
                            listView.decrementCurrentIndex()
                        }
                        Keys.onDownPressed: {
                            listView.incrementCurrentIndex()
                        }
                        Keys.onReturnPressed: launchApp(listView.currentItem.modelData)
                    }
                }

                // Application list
                ListView {
                    highlightMoveDuration: 0
                    clip: true // Ensure that scrolled items don't go outside the widget
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    //cacheBuffer: 0
                    maximumFlickVelocity: 1000 // Increases bound overshoot?
                    id: listView
                    keyNavigationEnabled: true
                    model: ScriptModel {
                        values: DesktopEntries.applications.values
                            // Filter by search text
                            .filter(app => {
                                const formattedSearchText = searchText.toLowerCase()
                                if (app.name.toLowerCase().includes(formattedSearchText)) {
                                    return true
                                }
                                if (app.genericName.toLowerCase().includes(formattedSearchText)) {
                                    return true
                                }
                                app.categories.forEach(category => {
                                    if (category.toLowerCase().includes(formattedSearchText)) {
                                        return true
                                    }
                                })
                                return false
                            })
                            // Sort by most frequently launched
                            .sort((appA, appB) => {
                                const appFreqMap = Services.Applications.appFreqMap 
                                const appAFreq = appFreqMap[appA.id] ? appFreqMap[appA.id] : 0
                                const appBFreq = appFreqMap[appB.id] ? appFreqMap[appB.id] : 0
                                if (appAFreq > appBFreq) {
                                    return -1
                                }
                                if (appAFreq < appBFreq) {
                                    return 1
                                }
                                return 0 // They are equal
                            })
                            //.filter(app => true)
                    }

                    snapMode: ListView.SnapToItem
                    // Add a scroll bar to the list
                    // idk where this ScrollBar.vertical property is defined
                    ScrollBar.vertical: ScrollBar { }

                    delegate: MouseArea {
                        id: mouseArea
                        required property DesktopEntry modelData
                        height: 60
                        width: listView.width
                        hoverEnabled: true
                        onClicked: launchApp(modelData)
                        Rectangle {
                            anchors.fill: parent
                            anchors {
                                leftMargin: 16
                                rightMargin: 16
                                topMargin: 4
                                bottomMargin: 4
                            }
                            color: mouseArea.containsMouse || mouseArea.focus ? palette.highlight : "transparent"
                            radius: 10
                            RowLayout {
                                anchors.fill: parent
                                IconImage {
                                    Layout.leftMargin: 8
                                    id: icon
                                    implicitSize: 32
                                    source: Quickshell.iconPath(mouseArea.modelData.icon)
                                }
                                Text{
                                    Layout.fillWidth: true
                                    leftPadding: 8
                                    rightPadding: 8
                                    elide: Text.ElideRight // Truncate with ... on the right
                                    text: mouseArea.modelData.name
                                    color: palette.text
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


