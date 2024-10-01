#!/bin/bash

LOGFILE="/tmp/.log_sshtrojan1.txt"

journalctl -f -u ssh | while read line; do
    if echo "$line" | grep "Accepted password" >/dev/null; then
        USER=$(echo "$line" | awk '{print $9}')
        echo "SSH Login Success - Username: $USER" >> $LOGFILE
    fi
done
