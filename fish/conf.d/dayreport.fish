# Daily journal. The 08:03 launchd job writes yesterday's report, then the first
# interactive shell of the day shows a short summary of it.

set -g __journal_dir $HOME/journal
set -g __dayreport_dir $HOME/.local/share/dayreport

# BSD date (macOS) takes -v, GNU date (Linux) takes -d.
function __dayreport_yesterday
    date -v-1d +%F 2>/dev/null; or date -d yesterday +%F
end

function dayreport --description "Generate the day report, defaults to yesterday"
    sh $__dayreport_dir/run.sh $argv
end

function journal --description "Open a day's report, defaults to yesterday"
    set -l day (test -n "$argv[1]"; and echo $argv[1]; or __dayreport_yesterday)
    if test -f $__journal_dir/$day.md
        nvim $__journal_dir/$day.md
    else
        echo "No report for $day. Run: dayreport $day"
    end
end

function __dayreport_morning
    set -l today (date +%F)
    set -l yesterday (__dayreport_yesterday)
    set -l report $__journal_dir/$yesterday.md
    set -l marker $__dayreport_dir/last-shown

    # Show once a day, only after the report exists, never in a nested or dumb shell.
    if not test -f $report; or test "$(cat $marker 2>/dev/null)" = $today
        return
    end
    if not status is-interactive; or test -n "$CLAUDECODE"
        return
    end

    mkdir -p $__dayreport_dir
    echo $today > $marker

    set_color --bold
    echo ""
    echo "  Yesterday ($yesterday)"
    set_color normal
    sed -n '3,6p' $report | sed 's/^/  /'
    set_color brblack
    echo "  full report: journal"
    set_color normal
    echo ""
end

if status is-interactive
    __dayreport_morning
end
