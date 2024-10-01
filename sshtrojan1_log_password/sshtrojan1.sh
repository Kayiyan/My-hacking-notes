#!/bin/bash

LOGFILE="/tmp/.log_sshtrojan1.txt"

touch $LOGFILE
chmod 600 $LOGFILE  
tail -f $LOGFILE
