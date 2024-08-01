
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'wallust' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'wallust'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'wallust' {
            [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('--ignore-sequence', 'ignore-sequence', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('-C', 'C ', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('--config-file', 'config-file', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--config-dir', 'config-dir', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('--skip-sequences', 'skip-sequences', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('-T', 'T ', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('--skip-templates', 'skip-templates', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('--update-current', 'update-current', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('-N', 'N ', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('-V', 'V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Generate a palette from an image')
            [CompletionResult]::new('cs', 'cs', [CompletionResultType]::ParameterValue, 'Apply a certain colorscheme')
            [CompletionResult]::new('theme', 'theme', [CompletionResultType]::ParameterValue, 'Apply a custom built in theme')
            [CompletionResult]::new('migrate', 'migrate', [CompletionResultType]::ParameterValue, 'Migrate v2 config to v3 (might lose comments,)')
            [CompletionResult]::new('debug', 'debug', [CompletionResultType]::ParameterValue, 'Print information about the program and the enviroment it uses')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'wallust;run' {
            [CompletionResult]::new('-a', 'a', [CompletionResultType]::ParameterName, 'Alpha *template variable* value, used only for templating (default is 100)')
            [CompletionResult]::new('--alpha', 'alpha', [CompletionResultType]::ParameterName, 'Alpha *template variable* value, used only for templating (default is 100)')
            [CompletionResult]::new('-b', 'b', [CompletionResultType]::ParameterName, 'Choose which backend to use (overwrites config)')
            [CompletionResult]::new('--backend', 'backend', [CompletionResultType]::ParameterName, 'Choose which backend to use (overwrites config)')
            [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Choose which colorspace to use (overwrites config)')
            [CompletionResult]::new('--colorspace', 'colorspace', [CompletionResultType]::ParameterName, 'Choose which colorspace to use (overwrites config)')
            [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Choose which fallback generation method to use (overwrites config)')
            [CompletionResult]::new('--fallback-generator', 'fallback-generator', [CompletionResultType]::ParameterName, 'Choose which fallback generation method to use (overwrites config)')
            [CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'Choose which palette to use (overwrites config)')
            [CompletionResult]::new('--palette', 'palette', [CompletionResultType]::ParameterName, 'Choose which palette to use (overwrites config)')
            [CompletionResult]::new('--saturation', 'saturation', [CompletionResultType]::ParameterName, 'Add saturation from 1% to 100% (overwrites config)')
            [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterName, 'Choose a custom threshold, between 1 and 100 (overwrites config)')
            [CompletionResult]::new('--threshold', 'threshold', [CompletionResultType]::ParameterName, 'Choose a custom threshold, between 1 and 100 (overwrites config)')
            [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('--ignore-sequence', 'ignore-sequence', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('-C', 'C ', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('--config-file', 'config-file', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--config-dir', 'config-dir', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-k', 'k', [CompletionResultType]::ParameterName, 'Ensure a readable contrast by checking colors in reference to the background (overwrites config)')
            [CompletionResult]::new('--check-contrast', 'check-contrast', [CompletionResultType]::ParameterName, 'Ensure a readable contrast by checking colors in reference to the background (overwrites config)')
            [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'Don''t cache the results')
            [CompletionResult]::new('--no-cache', 'no-cache', [CompletionResultType]::ParameterName, 'Don''t cache the results')
            [CompletionResult]::new('-w', 'w', [CompletionResultType]::ParameterName, 'Generates colors even if there is a cache version of it')
            [CompletionResult]::new('--overwrite-cache', 'overwrite-cache', [CompletionResultType]::ParameterName, 'Generates colors even if there is a cache version of it')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('--skip-sequences', 'skip-sequences', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('-T', 'T ', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('--skip-templates', 'skip-templates', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('--update-current', 'update-current', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('-N', 'N ', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            break
        }
        'wallust;cs' {
            [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Specify a custom format. Without this option, wallust will sequentially try to decode it by trying one by one')
            [CompletionResult]::new('--format', 'format', [CompletionResultType]::ParameterName, 'Specify a custom format. Without this option, wallust will sequentially try to decode it by trying one by one')
            [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('--ignore-sequence', 'ignore-sequence', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('-C', 'C ', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('--config-file', 'config-file', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--config-dir', 'config-dir', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('--skip-sequences', 'skip-sequences', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('-T', 'T ', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('--skip-templates', 'skip-templates', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('--update-current', 'update-current', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('-N', 'N ', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            break
        }
        'wallust;theme' {
            [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('--ignore-sequence', 'ignore-sequence', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('-C', 'C ', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('--config-file', 'config-file', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--config-dir', 'config-dir', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'Only preview the selected theme')
            [CompletionResult]::new('--preview', 'preview', [CompletionResultType]::ParameterName, 'Only preview the selected theme')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('--skip-sequences', 'skip-sequences', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('-T', 'T ', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('--skip-templates', 'skip-templates', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('--update-current', 'update-current', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('-N', 'N ', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'wallust;migrate' {
            [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('--ignore-sequence', 'ignore-sequence', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('-C', 'C ', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('--config-file', 'config-file', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--config-dir', 'config-dir', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('--skip-sequences', 'skip-sequences', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('-T', 'T ', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('--skip-templates', 'skip-templates', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('--update-current', 'update-current', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('-N', 'N ', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'wallust;debug' {
            [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('--ignore-sequence', 'ignore-sequence', [CompletionResultType]::ParameterName, 'Won''t send these colors sequences')
            [CompletionResult]::new('-C', 'C ', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('--config-file', 'config-file', [CompletionResultType]::ParameterName, 'Use FILE as the config file')
            [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--config-dir', 'config-dir', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Don''t print anything')
            [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('--skip-sequences', 'skip-sequences', [CompletionResultType]::ParameterName, 'Skip setting terminal sequences')
            [CompletionResult]::new('-T', 'T ', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('--skip-templates', 'skip-templates', [CompletionResultType]::ParameterName, 'Skip templating process')
            [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('--update-current', 'update-current', [CompletionResultType]::ParameterName, 'Only update the current terminal')
            [CompletionResult]::new('-N', 'N ', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Uses DIR as the config directory, which holds both `wallust.toml` and the templates files (if existent)')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'wallust;help' {
            [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Generate a palette from an image')
            [CompletionResult]::new('cs', 'cs', [CompletionResultType]::ParameterValue, 'Apply a certain colorscheme')
            [CompletionResult]::new('theme', 'theme', [CompletionResultType]::ParameterValue, 'Apply a custom built in theme')
            [CompletionResult]::new('migrate', 'migrate', [CompletionResultType]::ParameterValue, 'Migrate v2 config to v3 (might lose comments,)')
            [CompletionResult]::new('debug', 'debug', [CompletionResultType]::ParameterValue, 'Print information about the program and the enviroment it uses')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'wallust;help;run' {
            break
        }
        'wallust;help;cs' {
            break
        }
        'wallust;help;theme' {
            break
        }
        'wallust;help;migrate' {
            break
        }
        'wallust;help;debug' {
            break
        }
        'wallust;help;help' {
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
