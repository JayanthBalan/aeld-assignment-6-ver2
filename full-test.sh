#!/bin/bash

cd "$(dirname "$0")" || exit 1

logfile="full-test-run.log"
rm -f "$logfile"

# Run the original test, displaying output live and saving it.
bash ./full-test-inner.sh 2>&1 | tee "$logfile" &
test_pid=$!

# Wait until the final runqemu cleanup message appears.
while ! grep -q 'runqemu - INFO - Host uptime:' "$logfile" 2>/dev/null; do
    if ! kill -0 "$test_pid" 2>/dev/null; then
        break
    fi
    sleep 1
done

# Wait for the test to finish and propagate its status.
wait "$test_pid"
exit $?
