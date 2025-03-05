# Developing
Run ags for the config instance within the flake instead of rebuilding after each change

For running with changes to additional ags windows spawned via `ags -t <window_name>`, run them instead via the cli and specify the config file.  
Otherwise, it will run it with the default config.
For example
```sh
ags -c ~/NixOS/modules/system/desktop-environments/leaf/ags/ags-config/config.js -t ControlPanel
```

Or if using typescript
```sh
bun build /home/eXia/NixOS/modules/system/desktop-environments/leaf/ags/ags-config/main.ts \
    --outdir /tmp/ags/js \
    --external "resource://*" \
    --external "gi://*"
ags -b testing -c /tmp/ags/js/main.js
```

# Credits
ty to Aylur and Kotontrion:)
and everyone else along the way

