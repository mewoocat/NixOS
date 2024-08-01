_wallust() {
    local i cur prev opts cmd
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${cmd},${i}" in
            ",$1")
                cmd="wallust"
                ;;
            wallust,cs)
                cmd="wallust__cs"
                ;;
            wallust,debug)
                cmd="wallust__debug"
                ;;
            wallust,help)
                cmd="wallust__help"
                ;;
            wallust,migrate)
                cmd="wallust__migrate"
                ;;
            wallust,run)
                cmd="wallust__run"
                ;;
            wallust,theme)
                cmd="wallust__theme"
                ;;
            wallust__help,cs)
                cmd="wallust__help__cs"
                ;;
            wallust__help,debug)
                cmd="wallust__help__debug"
                ;;
            wallust__help,help)
                cmd="wallust__help__help"
                ;;
            wallust__help,migrate)
                cmd="wallust__help__migrate"
                ;;
            wallust__help,run)
                cmd="wallust__help__run"
                ;;
            wallust__help,theme)
                cmd="wallust__help__theme"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        wallust)
            opts="-i -q -s -T -u -C -d -N -h -V --ignore-sequence --quiet --skip-sequences --skip-templates --update-current --config-file --config-dir --no-config --help --version run cs theme migrate debug help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --ignore-sequence)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                --config-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__cs)
            opts="-f -i -q -s -T -u -C -d -N -h --format --ignore-sequence --quiet --skip-sequences --skip-templates --update-current --config-file --config-dir --no-config --help <FILE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --format)
                    COMPREPLY=($(compgen -W "pywal terminal-sexy wallust" -- "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -W "pywal terminal-sexy wallust" -- "${cur}"))
                    return 0
                    ;;
                --ignore-sequence)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                --config-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__debug)
            opts="-i -q -s -T -u -C -d -N -h --ignore-sequence --quiet --skip-sequences --skip-templates --update-current --config-file --config-dir --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --ignore-sequence)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                --config-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__help)
            opts="run cs theme migrate debug help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__help__cs)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__help__debug)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__help__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__help__migrate)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__help__run)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__help__theme)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__migrate)
            opts="-i -q -s -T -u -C -d -N -h --ignore-sequence --quiet --skip-sequences --skip-templates --update-current --config-file --config-dir --no-config --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --ignore-sequence)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                --config-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__run)
            opts="-a -b -c -f -k -n -p -t -w -i -q -s -T -u -C -d -N -h --alpha --backend --colorspace --fallback-generator --check-contrast --no-cache --palette --saturation --threshold --overwrite-cache --ignore-sequence --quiet --skip-sequences --skip-templates --update-current --config-file --config-dir --no-config --help <FILE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --alpha)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -a)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --backend)
                    COMPREPLY=($(compgen -W "full resized wal thumb fastresize kmeans" -- "${cur}"))
                    return 0
                    ;;
                -b)
                    COMPREPLY=($(compgen -W "full resized wal thumb fastresize kmeans" -- "${cur}"))
                    return 0
                    ;;
                --colorspace)
                    COMPREPLY=($(compgen -W "lab labmixed lch lchmixed" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "lab labmixed lch lchmixed" -- "${cur}"))
                    return 0
                    ;;
                --fallback-generator)
                    COMPREPLY=($(compgen -W "interpolate complementary" -- "${cur}"))
                    return 0
                    ;;
                -f)
                    COMPREPLY=($(compgen -W "interpolate complementary" -- "${cur}"))
                    return 0
                    ;;
                --palette)
                    COMPREPLY=($(compgen -W "dark dark16 darkcomp darkcomp16 harddark harddark16 harddarkcomp harddarkcomp16 light light16 lightcomp lightcomp16 softdark softdark16 softdarkcomp softdarkcomp16 softlight softlight16 softlightcomp softlightcomp16" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "dark dark16 darkcomp darkcomp16 harddark harddark16 harddarkcomp harddarkcomp16 light light16 lightcomp lightcomp16 softdark softdark16 softdarkcomp softdarkcomp16 softlight softlight16 softlightcomp softlightcomp16" -- "${cur}"))
                    return 0
                    ;;
                --saturation)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --threshold)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -t)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ignore-sequence)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                --config-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        wallust__theme)
            opts="-p -i -q -s -T -u -C -d -N -h --preview --ignore-sequence --quiet --skip-sequences --skip-templates --update-current --config-file --config-dir --no-config --help dkeg-petal base16-paraiso sexy-s3r0-modified sexy-rasi solarized-dark sexy-muse base16-rebecca base16-classic-dark dkeg-leaf dkeg-harbing base16-atelier-forest-light sexy-simple_rainbow base16-bright base16-embers base16-chalk dkeg-flapr sexy-tangoesque base16-twilight sexy-visibone base16-brewer sexy-x-dotshare sexy-astromouse dkeg-bulb base16-summerfruit-light dkeg-chaires base16-black-metal-funeral base16-black-metal-burzum base16-codeschool base16-cupcake tempus_autumn dkeg-link sexy-gslob-nature-suede sexy-hybrid base16-materialer-dark dkeg-view dkeg-blumune base16-zenburn base16-gruvbox-pale dkeg-sprout sexy-mikado dkeg-scag base16-macintosh base16-black-metal-khold base16-atelier-plateau-dark base16-unikitty-light base16-google-light base16-materialer-light base16-pop base16-flat base16tooth base16-black-metal-venom base16-atelier-sulphurpool-dark base16-atelier-estuary-light sexy-zenburn base16-eighties sexy-eqie6 base16-3024 sexy-dwmrob base16-black-metal-marduk dkeg-brownstone dkeg-escen sexy-user-77-mashup-colors base16-mocha base16-mexico tempus_dusk base16-grayscale-light dkeg-novmbr dkeg-urban tempus_rift sexy-thwump dkeg-transposet tempus_future dkeg-stv base16-railscasts sexy-mikazuki base16-tomorrow base16-unikitty-dark sexy-jasonwryan dkeg-tealights base16-solarflare dkeg-raild sexy-invisibone base16-material-palenight dkeg-scape base16-black-metal-gorgoroth base16-solarized-light base16-black-metal-bathory base16-outrun dkeg-bark dkeg-spire sexy-sexcolors base16-woodland dkeg-simplicity base16-monokai base16-mellow-purple base16-xcode-dusk base16-porple base16-isotope dkeg-fendr dkeg-sundr sexy-nancy base16-classic-light dkeg-5725 base16-atelier-lakeside-dark sexy-navy-and-ivory 3024-light monokai base16-oceanicnext sexy-euphrasia sexy-visibone-alt-2 dkeg-mattd base16-atelier-seaside-light base16-atelier-savanna-light base16-atelier-heath-light dkeg-vans dkeg-coco sexy-gjm sexy-kasugano base16-atelier-sulphurpool-light base16-nord base16-black-metal-nile base16-tomorrow-night sexy-material base16-cupertino sexy-tlh srcery base16-phd base16-github tempus_summer base16-gruvbox-soft-dark base16-bespin sexy-rydgel dkeg-forst dkeg-slate sexy-theme2 base16-marrakesh sexy-colorfulcolors sexy-neon dkeg-diner base16-apathy sexy-gnometerm sexy-parker_brothers sexy-mostly-bright sexy-doomicideocean base16-atelier-dune-light zenburn sexy-rezza dkeg-relax ashes-light dkeg-provrb dkeg-skigh base16-tube dkeg-amiox sexy-numixdarkest base16-atelier-forest-dark sexy-pretty-and-pastel sexy-splurge base16-irblack base16-materia base16-gruvbox-hard-light dkeg-owl base16-atelier-heath-dark sexy-insignificato gruvbox darktooth sexy-trim-yer-beard sexy-dotshare dkeg-designr dkeg-poly base16-brushtrees base16-dracula base16-atelier-lakeside-light tempus_totus base16-atelier-cave-dark sexy-hund tempus_fugit base16-black-metal-mayhem base16-default-light dkeg-shade base16-default-dark vscode base16-atelier-plateau-light base16-hopscotch base16-grayscale-dark base16-atelier-estuary-dark base16-icy 3024-dark sexy-cloud rose-pine sexy-phrak1 base16-snazzy rose-pine-moon sexy-deafened dkeg-fury dkeg-blok base16-summerfruit-dark base16-pico sexy-sweetlove sexy-belge dkeg-victory sexy-bitmute base16-spacemacs sexy-orangish tempus_dawn dkeg-blend dkeg-book github base16-circus base16-gruvbox-medium-dark dkeg-prevail dkeg-depth base16-black-metal-immortal dkeg-soundwave sexy-gotham base16-atelier-seaside-dark tempus_warp base16-onedark dkeg-pastely base16-harmonic-light sexy-vacuous2 tempus_winter base16-atelier-savanna-dark base16-ashes rose-pine-dawn sexy-swayr sexy-digerati base16-google-dark sexy-monokai dkeg-branch dkeg-squares sexy-tartan tempus_spring base16-one base16-black-metal tempus_past base16-gruvbox-medium-light dkeg-bluetype base16-atelier-cave-light dkeg-subtle solarized-light base16-gruvbox-hard-dark base16-atelier-dune-dark sexy-tango dkeg-wintry base16-greenscreen base16-harmonic-dark base16-ocean dkeg-parkd sexy-derp dkeg-paints ashes-dark dkeg-kit base16-solarized-dark base16-seti sexy-dawn base16-gruvbox-soft-light hybrid-material dkeg-corduroy dkeg-traffic base16-shapeshifter base16-material random"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --ignore-sequence)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                -i)
                    COMPREPLY=($(compgen -W "background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15" -- "${cur}"))
                    return 0
                    ;;
                --config-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -C)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

if [[ "${BASH_VERSINFO[0]}" -eq 4 && "${BASH_VERSINFO[1]}" -ge 4 || "${BASH_VERSINFO[0]}" -gt 4 ]]; then
    complete -F _wallust -o nosort -o bashdefault -o default wallust
else
    complete -F _wallust -o bashdefault -o default wallust
fi
