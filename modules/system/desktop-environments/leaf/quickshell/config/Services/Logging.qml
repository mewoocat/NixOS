pragma Singleton

import QtQuick
import Quickshell
import QtQml

Singleton {
    /*
    property LoggingCategory category: LoggingCategory {
        name: "default"
        defaultLogLevel: LoggingCategory.Warning
    }
    */
    property LoggingCategory category: LoggingCategory {
        id: category
        name: "com.qt.category"
        defaultLogLevel: LoggingCategory.Critical
    }
}
