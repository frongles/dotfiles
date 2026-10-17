# Give each machine its own prompt color so it's obvious which one a shell is on.
# starship.toml has one env_var segment per color, and only the PROMPT_HOST_<COLOR>
# set here renders. Its value is the label shown in the prompt.

if status is-interactive
    set -l colors mauve teal blue pink sky
    set -l host (prompt_hostname)
    set -l color

    switch $host
        case desk # Ubuntu desktop
            set color teal
        case air # M1 personal Mac
            set color mauve
        case work # M2 work Mac
            set color blue
        case box # Gigabyte server
            set color pink
        case '*'
            # Unlisted host: pick a stable color from a hash of the name.
            set -l h (echo $host | cksum | string split -f1 ' ')
            set color $colors[(math "$h % "(count $colors)" + 1")]
    end

    for c in $colors
        set -e PROMPT_HOST_(string upper $c)
    end
    set -gx PROMPT_HOST_(string upper $color) $host
end
