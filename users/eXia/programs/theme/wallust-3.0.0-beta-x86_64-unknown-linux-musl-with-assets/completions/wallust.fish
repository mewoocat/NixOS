complete -c wallust -n "__fish_use_subcommand" -s i -l ignore-sequence -d 'Won\'t send these colors sequences' -r -f -a "{background	'',foreground	'',cursor	'',color0	'',color1	'',color2	'',color3	'',color4	'',color5	'',color6	'',color7	'',color8	'',color9	'',color10	'',color11	'',color12	'',color13	'',color14	'',color15	''}"
complete -c wallust -n "__fish_use_subcommand" -s C -l config-file -d 'Use FILE as the config file' -r -F
complete -c wallust -n "__fish_use_subcommand" -s d -l config-dir -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)' -r -F
complete -c wallust -n "__fish_use_subcommand" -s q -l quiet -d 'Don\'t print anything'
complete -c wallust -n "__fish_use_subcommand" -s s -l skip-sequences -d 'Skip setting terminal sequences'
complete -c wallust -n "__fish_use_subcommand" -s T -l skip-templates -d 'Skip templating process'
complete -c wallust -n "__fish_use_subcommand" -s u -l update-current -d 'Only update the current terminal'
complete -c wallust -n "__fish_use_subcommand" -s N -l no-config -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
complete -c wallust -n "__fish_use_subcommand" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c wallust -n "__fish_use_subcommand" -s V -l version -d 'Print version'
complete -c wallust -n "__fish_use_subcommand" -f -a "run" -d 'Generate a palette from an image'
complete -c wallust -n "__fish_use_subcommand" -f -a "cs" -d 'Apply a certain colorscheme'
complete -c wallust -n "__fish_use_subcommand" -f -a "theme" -d 'Apply a custom built in theme'
complete -c wallust -n "__fish_use_subcommand" -f -a "migrate" -d 'Migrate v2 config to v3 (might lose comments,)'
complete -c wallust -n "__fish_use_subcommand" -f -a "debug" -d 'Print information about the program and the enviroment it uses'
complete -c wallust -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c wallust -n "__fish_seen_subcommand_from run" -s a -l alpha -d 'Alpha *template variable* value, used only for templating (default is 100)' -r
complete -c wallust -n "__fish_seen_subcommand_from run" -s b -l backend -d 'Choose which backend to use (overwrites config)' -r -f -a "{full	'Read and return the whole image pixels (more precision, slower)',resized	'Resizes the image before parsing, mantaining it\'s aspect ratio',wal	'Uses image magick `convert` to generate the colors, like pywal',thumb	'Faster algo hardcoded to 512x512 (no ratio respected)',fastresize	'A much faster resize algo that uses SIMD. For some reason it fails on some images where `resized` doesn\'t, for this reason it doesn\'t *replace* but rather it\'s a new option',kmeans	'Kmeans is an algo that divides and picks pixels all around the image, Requires more tweaking and more in depth testing but, for the most part, "it just werks"'}"
complete -c wallust -n "__fish_seen_subcommand_from run" -s c -l colorspace -d 'Choose which colorspace to use (overwrites config)' -r -f -a "{lab	'Uses Cie L*a*b color space',labmixed	'Variant of `lab` that mixes the colors gathered, if not enough colors it fallbacks to usual lab (not recommended in small images)',lch	'CIE Lch, you can understand this color space like LAB but with chrome and hue added. Could help when sorting',lchmixed	'CIE Lch, you can understand this color space like LAB but with chrome and hue added. Could help when sorting'}"
complete -c wallust -n "__fish_seen_subcommand_from run" -s f -l fallback-generator -d 'Choose which fallback generation method to use (overwrites config)' -r -f -a "{interpolate	'uses [`interpolate`]',complementary	'uses [`complementary`]'}"
complete -c wallust -n "__fish_seen_subcommand_from run" -s p -l palette -d 'Choose which palette to use (overwrites config)' -r -f -a "{dark	'8 dark colors, dark background and light contrast',dark16	'Same as `dark` but uses the 16 colors trick',darkcomp	'This is a `dark` variant that changes all colors to it\'s complementary counterpart, giving the feeling of a \'new palette\' but that still makes sense with the image provided',darkcomp16	'16 variation of the dark complementary variant',harddark	'Same as `dark` with hard hue colors',harddark16	'Harddark with 16 color variation',harddarkcomp	'complementary colors variation of harddark scheme',harddarkcomp16	'complementary colors variation of harddark scheme',light	'Light bg, dark fg',light16	'Same as `light` but uses the 16 color trick',lightcomp	'complementary colors variation of light',lightcomp16	'complementary colors variation of light with the 16 color variation',softdark	'Variant of softlight, uses the lightest colors and a dark background (could be interpreted as `dark` inversed)',softdark16	'softdark with 16 color variation',softdarkcomp	'complementary variation for softdark',softdarkcomp16	'complementary variation for softdark with the 16 color variation',softlight	'Light with soft pastel colors, counterpart of `harddark`',softlight16	'softlight with 16 color variation',softlightcomp	'softlight with complementary colors',softlightcomp16	'softlight with complementary colors with 16 colors'}"
complete -c wallust -n "__fish_seen_subcommand_from run" -l saturation -d 'Add saturation from 1% to 100% (overwrites config)' -r
complete -c wallust -n "__fish_seen_subcommand_from run" -s t -l threshold -d 'Choose a custom threshold, between 1 and 100 (overwrites config)' -r
complete -c wallust -n "__fish_seen_subcommand_from run" -s i -l ignore-sequence -d 'Won\'t send these colors sequences' -r -f -a "{background	'',foreground	'',cursor	'',color0	'',color1	'',color2	'',color3	'',color4	'',color5	'',color6	'',color7	'',color8	'',color9	'',color10	'',color11	'',color12	'',color13	'',color14	'',color15	''}"
complete -c wallust -n "__fish_seen_subcommand_from run" -s C -l config-file -d 'Use FILE as the config file' -r -F
complete -c wallust -n "__fish_seen_subcommand_from run" -s d -l config-dir -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)' -r -F
complete -c wallust -n "__fish_seen_subcommand_from run" -s k -l check-contrast -d 'Ensure a readable contrast by checking colors in reference to the background (overwrites config)'
complete -c wallust -n "__fish_seen_subcommand_from run" -s n -l no-cache -d 'Don\'t cache the results'
complete -c wallust -n "__fish_seen_subcommand_from run" -s w -l overwrite-cache -d 'Generates colors even if there is a cache version of it'
complete -c wallust -n "__fish_seen_subcommand_from run" -s q -l quiet -d 'Don\'t print anything'
complete -c wallust -n "__fish_seen_subcommand_from run" -s s -l skip-sequences -d 'Skip setting terminal sequences'
complete -c wallust -n "__fish_seen_subcommand_from run" -s T -l skip-templates -d 'Skip templating process'
complete -c wallust -n "__fish_seen_subcommand_from run" -s u -l update-current -d 'Only update the current terminal'
complete -c wallust -n "__fish_seen_subcommand_from run" -s N -l no-config -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
complete -c wallust -n "__fish_seen_subcommand_from run" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c wallust -n "__fish_seen_subcommand_from cs" -s f -l format -d 'Specify a custom format. Without this option, wallust will sequentially try to decode it by trying one by one' -r -f -a "{pywal	'uses the wal colorscheme format, see <https://github.com/dylanaraps/pywal/tree/master/pywal/colorschemes>',terminal-sexy	'uses <https://terminal.sexy> JSON export',wallust	'cached wallust files'}"
complete -c wallust -n "__fish_seen_subcommand_from cs" -s i -l ignore-sequence -d 'Won\'t send these colors sequences' -r -f -a "{background	'',foreground	'',cursor	'',color0	'',color1	'',color2	'',color3	'',color4	'',color5	'',color6	'',color7	'',color8	'',color9	'',color10	'',color11	'',color12	'',color13	'',color14	'',color15	''}"
complete -c wallust -n "__fish_seen_subcommand_from cs" -s C -l config-file -d 'Use FILE as the config file' -r -F
complete -c wallust -n "__fish_seen_subcommand_from cs" -s d -l config-dir -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)' -r -F
complete -c wallust -n "__fish_seen_subcommand_from cs" -s q -l quiet -d 'Don\'t print anything'
complete -c wallust -n "__fish_seen_subcommand_from cs" -s s -l skip-sequences -d 'Skip setting terminal sequences'
complete -c wallust -n "__fish_seen_subcommand_from cs" -s T -l skip-templates -d 'Skip templating process'
complete -c wallust -n "__fish_seen_subcommand_from cs" -s u -l update-current -d 'Only update the current terminal'
complete -c wallust -n "__fish_seen_subcommand_from cs" -s N -l no-config -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
complete -c wallust -n "__fish_seen_subcommand_from cs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c wallust -n "__fish_seen_subcommand_from theme" -s i -l ignore-sequence -d 'Won\'t send these colors sequences' -r -f -a "{background	'',foreground	'',cursor	'',color0	'',color1	'',color2	'',color3	'',color4	'',color5	'',color6	'',color7	'',color8	'',color9	'',color10	'',color11	'',color12	'',color13	'',color14	'',color15	''}"
complete -c wallust -n "__fish_seen_subcommand_from theme" -s C -l config-file -d 'Use FILE as the config file' -r -F
complete -c wallust -n "__fish_seen_subcommand_from theme" -s d -l config-dir -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)' -r -F
complete -c wallust -n "__fish_seen_subcommand_from theme" -s p -l preview -d 'Only preview the selected theme'
complete -c wallust -n "__fish_seen_subcommand_from theme" -s q -l quiet -d 'Don\'t print anything'
complete -c wallust -n "__fish_seen_subcommand_from theme" -s s -l skip-sequences -d 'Skip setting terminal sequences'
complete -c wallust -n "__fish_seen_subcommand_from theme" -s T -l skip-templates -d 'Skip templating process'
complete -c wallust -n "__fish_seen_subcommand_from theme" -s u -l update-current -d 'Only update the current terminal'
complete -c wallust -n "__fish_seen_subcommand_from theme" -s N -l no-config -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
complete -c wallust -n "__fish_seen_subcommand_from theme" -s h -l help -d 'Print help'
complete -c wallust -n "__fish_seen_subcommand_from migrate" -s i -l ignore-sequence -d 'Won\'t send these colors sequences' -r -f -a "{background	'',foreground	'',cursor	'',color0	'',color1	'',color2	'',color3	'',color4	'',color5	'',color6	'',color7	'',color8	'',color9	'',color10	'',color11	'',color12	'',color13	'',color14	'',color15	''}"
complete -c wallust -n "__fish_seen_subcommand_from migrate" -s C -l config-file -d 'Use FILE as the config file' -r -F
complete -c wallust -n "__fish_seen_subcommand_from migrate" -s d -l config-dir -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)' -r -F
complete -c wallust -n "__fish_seen_subcommand_from migrate" -s q -l quiet -d 'Don\'t print anything'
complete -c wallust -n "__fish_seen_subcommand_from migrate" -s s -l skip-sequences -d 'Skip setting terminal sequences'
complete -c wallust -n "__fish_seen_subcommand_from migrate" -s T -l skip-templates -d 'Skip templating process'
complete -c wallust -n "__fish_seen_subcommand_from migrate" -s u -l update-current -d 'Only update the current terminal'
complete -c wallust -n "__fish_seen_subcommand_from migrate" -s N -l no-config -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
complete -c wallust -n "__fish_seen_subcommand_from migrate" -s h -l help -d 'Print help'
complete -c wallust -n "__fish_seen_subcommand_from debug" -s i -l ignore-sequence -d 'Won\'t send these colors sequences' -r -f -a "{background	'',foreground	'',cursor	'',color0	'',color1	'',color2	'',color3	'',color4	'',color5	'',color6	'',color7	'',color8	'',color9	'',color10	'',color11	'',color12	'',color13	'',color14	'',color15	''}"
complete -c wallust -n "__fish_seen_subcommand_from debug" -s C -l config-file -d 'Use FILE as the config file' -r -F
complete -c wallust -n "__fish_seen_subcommand_from debug" -s d -l config-dir -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)' -r -F
complete -c wallust -n "__fish_seen_subcommand_from debug" -s q -l quiet -d 'Don\'t print anything'
complete -c wallust -n "__fish_seen_subcommand_from debug" -s s -l skip-sequences -d 'Skip setting terminal sequences'
complete -c wallust -n "__fish_seen_subcommand_from debug" -s T -l skip-templates -d 'Skip templating process'
complete -c wallust -n "__fish_seen_subcommand_from debug" -s u -l update-current -d 'Only update the current terminal'
complete -c wallust -n "__fish_seen_subcommand_from debug" -s N -l no-config -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
complete -c wallust -n "__fish_seen_subcommand_from debug" -s h -l help -d 'Print help'
complete -c wallust -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from cs; and not __fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from migrate; and not __fish_seen_subcommand_from debug; and not __fish_seen_subcommand_from help" -f -a "run" -d 'Generate a palette from an image'
complete -c wallust -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from cs; and not __fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from migrate; and not __fish_seen_subcommand_from debug; and not __fish_seen_subcommand_from help" -f -a "cs" -d 'Apply a certain colorscheme'
complete -c wallust -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from cs; and not __fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from migrate; and not __fish_seen_subcommand_from debug; and not __fish_seen_subcommand_from help" -f -a "theme" -d 'Apply a custom built in theme'
complete -c wallust -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from cs; and not __fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from migrate; and not __fish_seen_subcommand_from debug; and not __fish_seen_subcommand_from help" -f -a "migrate" -d 'Migrate v2 config to v3 (might lose comments,)'
complete -c wallust -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from cs; and not __fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from migrate; and not __fish_seen_subcommand_from debug; and not __fish_seen_subcommand_from help" -f -a "debug" -d 'Print information about the program and the enviroment it uses'
complete -c wallust -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from cs; and not __fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from migrate; and not __fish_seen_subcommand_from debug; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
