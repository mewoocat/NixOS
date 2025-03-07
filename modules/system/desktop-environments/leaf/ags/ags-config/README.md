# Developing
Run ags for the config instance within the flake instead of rebuilding after each change

Typescript example
```sh
bun build /home/eXia/NixOS/modules/system/desktop-environments/leaf/ags/ags-config/main.ts \
    --outdir /tmp/ags/js \
    --external "resource://*" \
    --external "gi://*"
ags -b testing -c /tmp/ags/js/main.js
```

The scss entry point is hard coded to the .config dir so the ags css file must be manually regenerated
```
sassc NixOS/modules/system/desktop-environments/leaf/ags/ags-config/Style/style.scss ~/.config/leaf-de/ags.css
```

For running with changes to additional ags windows spawned via `ags -t <window_name>`, run them instead via the cli and specify the config file.  
Otherwise, it will run it with the default config.
For example, assuming that the Typescript has been already transpiled to Javascript at `/tmp/ags/js/main.js`
```sh
ags -c /tmp/ags/js/main.js -t ControlPanel
```

Running lockscreen
```sh
bun build /home/eXia/NixOS/modules/system/desktop-environments/leaf/ags/ags-config/Lockscreen.js \
    --outdir /tmp/ags/js \
    --external "resource://*" \
    --external "gi://*"
ags -b lockscreen -c /tmp/ags/js/Lockscreen.js
```


# Credits
ty to Aylur and Kotontrion:)
and everyone else along the way

