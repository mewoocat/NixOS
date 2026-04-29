# Debugging
```
    quickshell --debug <PORT> --waitfordebug
```
and then using QtCreator, go to Debug > Start Debugging > Attach to QML port...

# Modifying log level
This will not print any debug, info, or warning logs
```
    quickshell --log-rules "*.debug=false;*.info=false;*.warning=false"
```
The `*` can be replaced with a particular logging category to apply the rule to.

These are in the QT_LOGGING_RULES format specified here: https://doc.qt.io/qt-6/qloggingcategory.html#configuring-categories

# Credits
    Thanks to everyone whose helped :)

    Notably,
    - outfoxxed - for creating quickshell and all the examples
    - end-4 - for ideas and quickshell examples
    - Sora, Rexi - answering questions, and examples
    - E3nviction - for dyanmic grid ideas
    - M7moud El-zayat - for anwsering my questions
