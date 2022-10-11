#!/bin/bash
filename=$1
col1=$(awk '/1-03-2022|Today/{getline;print;}' $filename)
col2=$(awk '/Tomorrow|2March|2 March 2022/{getline;print;}' $filename)
printf "%-62s%-55s\n" "Today" "Tomorrow"
echo "----------------------------------------------------------------------------------------------"
pr -2 -t -d  --width=120 <<eof
$col1
$col2
eof
echo "-----------------------------------------------------------------------------------------------"
