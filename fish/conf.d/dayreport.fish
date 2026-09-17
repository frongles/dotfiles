# Daily journal. The 08:03 launchd job writes yesterday's report, then the first
# interactive shell of the day shows it and asks what today is for.

set -g __journal_dir $HOME/journal
set -g __dayreport_dir $HOME/.local/share/dayreport

function dayreport --description "Generate the day report, defaults to yesterday"
    sh $__dayreport_dir/run.sh $argv
end

function journal --description "Open a day's report, defaults to yesterday"
    set -l day (test -n "$argv[1]"; and echo $argv[1]; or date -v-1d +%F)
    if test -f $__journal_dir/$day.md
        nvim $__journal_dir/$day.md
    else
        echo "No report for $day. Run: dayreport $day"
    end
end

function goals --description "Write or edit today's goals"
    mkdir -p $__journal_dir/goals
    nvim $__journal_dir/goals/(date +%F).md
end

function __dayreport_morning
    set -l today (date +%F)
    set -l yesterday (date -v-1d +%F)
    set -l goalfile $__journal_dir/goals/$today.md
    set -l marker $__journal_dir/goals/.asked-$today
    set -l report $__journal_dir/$yesterday.md

    # Ask once a day, only after the report exists, never in a nested or dumb shell.
    if test -e $goalfile; or test -e $marker; or not test -f $report
        return
    end
    if not status is-interactive; or test -n "$CLAUDECODE"
        return
    end

    mkdir -p $__journal_dir/goals
    touch $marker

    set_color --bold
    echo ""
    echo "  Yesterday ($yesterday)"
    set_color normal
    sed -n '3,6p' $report | sed 's/^/  /'
    echo ""
    set_color brblack
    echo "  full report: journal    skip: press enter"
    set_color normal
    echo ""

    set -l lines
    while true
        read -P "  goal for today > " -l line
        if test -z "$line"
            break
        end
        set -a lines "- $line"
    end

    if test (count $lines) -gt 0
        # printf over the list, not string join. A goal line starts with "- ",
        # which string join parses as an option.
        begin
            printf '# Goals %s\n\n' $today
            printf '%s\n' $lines
        end > $goalfile
        if test -s $goalfile
            set_color green
            echo "  saved "(count $lines)" goals to "(string replace $HOME '~' $goalfile)
        else
            set_color red
            echo "  failed to write $goalfile"
        end
        set_color normal
    end
    echo ""
end

if status is-interactive
    __dayreport_morning
end
