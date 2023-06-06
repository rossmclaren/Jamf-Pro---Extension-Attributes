#!/bin/bash

# Check if the Adobe Creative Cloud app is installed
if [ -d "/Applications/Adobe Creative Cloud" ]; then
    echo "Adobe Creative Cloud app found. Checking Remote Update Manager installation status..."
    
    # Check if the Adobe Remote Update Manager (AUSST) is installed
    if [ ! -e "/usr/local/bin/RemoteUpdateManager" ]; then
        echo "Adobe Remote Update Manager (AUSST) not found."
        
        # Call a custom trigger policy to install Remote Update Manager
        /usr/local/bin/jamf policy -trigger install_remote_update_manager
        
        exit 1
    else
        echo "Adobe Remote Update Manager (AUSST) is installed."
    fi
else
    echo "Adobe Creative Cloud app not found."
    exit 0
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
