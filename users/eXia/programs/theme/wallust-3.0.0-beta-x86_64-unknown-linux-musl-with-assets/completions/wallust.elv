
use builtin;
use str;

set edit:completion:arg-completer[wallust] = {|@words|
    fn spaces {|n|
        builtin:repeat $n ' ' | str:join ''
    }
    fn cand {|text desc|
        edit:complex-candidate $text &display=$text' '(spaces (- 14 (wcswidth $text)))$desc
    }
    var command = 'wallust'
    for word $words[1..-1] {
        if (str:has-prefix $word '-') {
            break
        }
        set command = $command';'$word
    }
    var completions = [
        &'wallust'= {
            cand -i 'Won''t send these colors sequences'
            cand --ignore-sequence 'Won''t send these colors sequences'
            cand -C 'Use FILE as the config file'
            cand --config-file 'Use FILE as the config file'
            cand -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --config-dir 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -q 'Don''t print anything'
            cand --quiet 'Don''t print anything'
            cand -s 'Skip setting terminal sequences'
            cand --skip-sequences 'Skip setting terminal sequences'
            cand -T 'Skip templating process'
            cand --skip-templates 'Skip templating process'
            cand -u 'Only update the current terminal'
            cand --update-current 'Only update the current terminal'
            cand -N 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --no-config 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -h 'Print help (see more with ''--help'')'
            cand --help 'Print help (see more with ''--help'')'
            cand -V 'Print version'
            cand --version 'Print version'
            cand run 'Generate a palette from an image'
            cand cs 'Apply a certain colorscheme'
            cand theme 'Apply a custom built in theme'
            cand migrate 'Migrate v2 config to v3 (might lose comments,)'
            cand debug 'Print information about the program and the enviroment it uses'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'wallust;run'= {
            cand -a 'Alpha *template variable* value, used only for templating (default is 100)'
            cand --alpha 'Alpha *template variable* value, used only for templating (default is 100)'
            cand -b 'Choose which backend to use (overwrites config)'
            cand --backend 'Choose which backend to use (overwrites config)'
            cand -c 'Choose which colorspace to use (overwrites config)'
            cand --colorspace 'Choose which colorspace to use (overwrites config)'
            cand -f 'Choose which fallback generation method to use (overwrites config)'
            cand --fallback-generator 'Choose which fallback generation method to use (overwrites config)'
            cand -p 'Choose which palette to use (overwrites config)'
            cand --palette 'Choose which palette to use (overwrites config)'
            cand --saturation 'Add saturation from 1% to 100% (overwrites config)'
            cand -t 'Choose a custom threshold, between 1 and 100 (overwrites config)'
            cand --threshold 'Choose a custom threshold, between 1 and 100 (overwrites config)'
            cand -i 'Won''t send these colors sequences'
            cand --ignore-sequence 'Won''t send these colors sequences'
            cand -C 'Use FILE as the config file'
            cand --config-file 'Use FILE as the config file'
            cand -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --config-dir 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -k 'Ensure a readable contrast by checking colors in reference to the background (overwrites config)'
            cand --check-contrast 'Ensure a readable contrast by checking colors in reference to the background (overwrites config)'
            cand -n 'Don''t cache the results'
            cand --no-cache 'Don''t cache the results'
            cand -w 'Generates colors even if there is a cache version of it'
            cand --overwrite-cache 'Generates colors even if there is a cache version of it'
            cand -q 'Don''t print anything'
            cand --quiet 'Don''t print anything'
            cand -s 'Skip setting terminal sequences'
            cand --skip-sequences 'Skip setting terminal sequences'
            cand -T 'Skip templating process'
            cand --skip-templates 'Skip templating process'
            cand -u 'Only update the current terminal'
            cand --update-current 'Only update the current terminal'
            cand -N 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --no-config 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -h 'Print help (see more with ''--help'')'
            cand --help 'Print help (see more with ''--help'')'
        }
        &'wallust;cs'= {
            cand -f 'Specify a custom format. Without this option, wallust will sequentially try to decode it by trying one by one'
            cand --format 'Specify a custom format. Without this option, wallust will sequentially try to decode it by trying one by one'
            cand -i 'Won''t send these colors sequences'
            cand --ignore-sequence 'Won''t send these colors sequences'
            cand -C 'Use FILE as the config file'
            cand --config-file 'Use FILE as the config file'
            cand -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --config-dir 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -q 'Don''t print anything'
            cand --quiet 'Don''t print anything'
            cand -s 'Skip setting terminal sequences'
            cand --skip-sequences 'Skip setting terminal sequences'
            cand -T 'Skip templating process'
            cand --skip-templates 'Skip templating process'
            cand -u 'Only update the current terminal'
            cand --update-current 'Only update the current terminal'
            cand -N 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --no-config 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -h 'Print help (see more with ''--help'')'
            cand --help 'Print help (see more with ''--help'')'
        }
        &'wallust;theme'= {
            cand -i 'Won''t send these colors sequences'
            cand --ignore-sequence 'Won''t send these colors sequences'
            cand -C 'Use FILE as the config file'
            cand --config-file 'Use FILE as the config file'
            cand -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --config-dir 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -p 'Only preview the selected theme'
            cand --preview 'Only preview the selected theme'
            cand -q 'Don''t print anything'
            cand --quiet 'Don''t print anything'
            cand -s 'Skip setting terminal sequences'
            cand --skip-sequences 'Skip setting terminal sequences'
            cand -T 'Skip templating process'
            cand --skip-templates 'Skip templating process'
            cand -u 'Only update the current terminal'
            cand --update-current 'Only update the current terminal'
            cand -N 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --no-config 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'wallust;migrate'= {
            cand -i 'Won''t send these colors sequences'
            cand --ignore-sequence 'Won''t send these colors sequences'
            cand -C 'Use FILE as the config file'
            cand --config-file 'Use FILE as the config file'
            cand -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --config-dir 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -q 'Don''t print anything'
            cand --quiet 'Don''t print anything'
            cand -s 'Skip setting terminal sequences'
            cand --skip-sequences 'Skip setting terminal sequences'
            cand -T 'Skip templating process'
            cand --skip-templates 'Skip templating process'
            cand -u 'Only update the current terminal'
            cand --update-current 'Only update the current terminal'
            cand -N 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --no-config 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'wallust;debug'= {
            cand -i 'Won''t send these colors sequences'
            cand --ignore-sequence 'Won''t send these colors sequences'
            cand -C 'Use FILE as the config file'
            cand --config-file 'Use FILE as the config file'
            cand -d 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --config-dir 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -q 'Don''t print anything'
            cand --quiet 'Don''t print anything'
            cand -s 'Skip setting terminal sequences'
            cand --skip-sequences 'Skip setting terminal sequences'
            cand -T 'Skip templating process'
            cand --skip-templates 'Skip templating process'
            cand -u 'Only update the current terminal'
            cand --update-current 'Only update the current terminal'
            cand -N 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand --no-config 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)'
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'wallust;help'= {
            cand run 'Generate a palette from an image'
            cand cs 'Apply a certain colorscheme'
            cand theme 'Apply a custom built in theme'
            cand migrate 'Migrate v2 config to v3 (might lose comments,)'
            cand debug 'Print information about the program and the enviroment it uses'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'wallust;help;run'= {
        }
        &'wallust;help;cs'= {
        }
        &'wallust;help;theme'= {
        }
        &'wallust;help;migrate'= {
        }
        &'wallust;help;debug'= {
        }
        &'wallust;help;help'= {
        }
    ]
    $completions[$command]
}
