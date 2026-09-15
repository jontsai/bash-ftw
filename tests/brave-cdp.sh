#!/bin/bash
# Exercise process-selection safety without launching or killing real browsers.
set -u
repo=$(cd "$(dirname "$0")/.." && pwd)
source <(sed -n '/^function brave-cdp {$/,/^}$/p' "$repo/dotfiles/.bashrc.ftw.mac")
test_dir=$(mktemp -d)
trap 'rm -f "$test_dir/events" "$test_dir/output"; rmdir "$test_dir"' EXIT

function id { echo 501; }
function lsof {
    [[ "$*" == "-nP -t -iTCP:$expected_port -sTCP:LISTEN" ]] || { echo bad-lsof >> "$test_dir/events"; return 2; }
    case "$scenario" in
        fresh|noncdp) return 1 ;;
        mixed) printf '101\n102\n' ;;
        *) echo 101 ;;
    esac
}
function ps {
    if [[ "$4" == uid= ]]; then
        if [[ "$scenario" == foreign || "$2" == 102 ]]; then echo 502; else echo 501; fi
    elif [[ "$scenario" == unrelated ]]; then
        echo /usr/bin/python3
    else
        echo '/Applications/Brave Browser.app/Contents/MacOS/Brave Browser'
    fi
}
function pgrep { [[ "$scenario" == noncdp ]]; }
function kill {
    if [[ "$1" == -0 ]]; then [[ "$scenario" == stuck ]]; return; fi
    echo "$*" >> "$test_dir/events"
}
function sleep { :; }
function open {
    echo "open $*" >> "$test_dir/events"
    [[ "$scenario" != launchfail ]]
}
function curl {
    [[ "$*" == "--noproxy * -fsS --max-time 1 http://127.0.0.1:$expected_port/json/version" ]] || return 2
    [[ "$scenario" != timeout ]] || return 1
    echo '{"webSocketDebuggerUrl":"ws://127.0.0.1/devtools/browser/test"}'
}

function check {
    local label=$1 value=$2 expected_status=$3 expected_events=$4
    scenario=$5
    expected_port=$6
    : > "$test_dir/events"
    if [[ "$value" == unset ]]; then unset CDP_PORT; else CDP_PORT=$value; fi
    brave-cdp > "$test_dir/output" 2>&1
    local status=$?
    local events
    events=$(cat "$test_dir/events")
    if [[ "$status" != "$expected_status" || "$events" != "$expected_events" ]]; then
        echo "FAIL: $label (status $status)"
        cat "$test_dir/events" "$test_dir/output"
        exit 1
    fi
    echo "PASS: $label"
}
check fallback unset 0 $'-TERM 101\nopen -a Brave Browser --args --remote-debugging-port=9222' normal 9222
check empty-fallback '' 0 $'-TERM 101\nopen -a Brave Browser --args --remote-debugging-port=9222' normal 9222
check custom-port 9333 0 $'-TERM 101\nopen -a Brave Browser --args --remote-debugging-port=9333' normal 9333
check leading-zero 09222 0 $'-TERM 101\nopen -a Brave Browser --args --remote-debugging-port=9222' normal 9222
check fresh-start 9333 0 'open -a Brave Browser --args --remote-debugging-port=9333' fresh 9333
for invalid in 0 65536 999999 -1 abc '1+2'; do
    check "invalid-$invalid" "$invalid" 1 '' normal unused
done
check foreign-user 9222 1 '' foreign 9222
check unrelated-listener 9222 1 '' unrelated 9222
check validate-all-before-kill 9222 1 '' mixed 9222
check preserve-nontarget-brave 9222 1 '' noncdp 9222
check graceful-stop-timeout 9222 1 '-TERM 101' stuck 9222
check launch-failure 9222 1 $'-TERM 101\nopen -a Brave Browser --args --remote-debugging-port=9222' launchfail 9222
check readiness-timeout 9222 1 $'-TERM 101\nopen -a Brave Browser --args --remote-debugging-port=9222' timeout 9222
