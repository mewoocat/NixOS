# Debugging
```
    quickshell --debug <PORT> --waitfordebug
```
and then using QtCreator, go to Debug > Start Debugging > Attach to QML port...

# Modifying log level
This will no print any debug logs
```
    quickshell --log-rules "*.debug=false"
```
These are in the QT_LOGGING_RULES format specified here: https://doc.qt.io/qt-6/qloggingcategory.html

# Credits
    Thanks to everyone whose helped :)

    Notably,
    - outfoxxed - for creating quickshell and all the examples
    - end-4 - for ideas and quickshell examples
    - Sora, Rexi - answering questions, and examples
    - E3nviction - for dyanmic grid ideas
