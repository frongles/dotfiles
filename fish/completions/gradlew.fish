# Load fish's current bundled completion rules.
status get-file completions/gradle.fish | source

# Override only task discovery to use the project's wrapper.
function __fish_gradle_get_task_completion
    __fish_gradle_contains_build_file; or return
    test -x ./gradlew; or return

    set -l cache_file \
        (__fish_gradle_create_completion_cache_file "{$PWD}-wrapper-tasks")

    mkdir -p (path dirname "$cache_file"); or return

    if not test -s "$cache_file"
        set -l tasks (./gradlew -q tasks --all --console=plain)
        or return

        printf '%s\n' $tasks \
            | string match --regex '^(?!-)[A-Za-z0-9:-]+(?: - .*)?$' \
            | string replace ' - ' \t \
            > "$cache_file"
    end

    string trim -- < "$cache_file"
end
