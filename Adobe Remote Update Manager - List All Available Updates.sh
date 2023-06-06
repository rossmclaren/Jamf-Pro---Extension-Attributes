#!/bin/bash

# Check if the Adobe Remote Update Manager (AUSST) is installed
if [ ! -e "/usr/local/bin/RemoteUpdateManager" ]; then
    echo "<result>Adobe Remote Update Manager (AUSST) not found.</result>"
    exit 1
fi

# Run the Adobe Remote Update Manager and capture the output
output=$(sudo /usr/local/bin/RemoteUpdateManager --action=list)

# Check if no updates are available
if echo "$output" | grep -q "No new applicable Updates. Seems like all products are up-to-date."; then
    echo "<result>No new applicable Updates. Seems like all products are up-to-date.</result>"
else
    # Filter and print the available updates
    updates=$(echo "$output" | grep -o "\([A-Z]\+\)\/[0-9.]\+\/[a-zA-Z0-9-]\+" | grep -E "ACR|PS|AI|ID|AE|PR|AU|DW|FL|ILST|PSST|IDSN|AICY|PSCC|IDCC|AECC")
    if [ -n "$updates" ]; then
        echo "<result>$updates</result>"
    else
        echo "<result>Unable to retrieve update information.</result>"
    fi
fi
