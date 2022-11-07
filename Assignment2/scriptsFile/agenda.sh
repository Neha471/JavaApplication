#!/bin/bash
#Create a variable for filename
filename=$1
#create variables to get and store the below line of particular date 
col1=$(awk '/1-03-2022|Today/{getline;print;}' $filename)
col2=$(awk '/Tomorrow|2March|2 March 2022/{getline;print;}' $filename)
printf "%-62s%-55s\n" "Today" "Tomorrow"
echo "----------------------------------------------------------------------------------------------"
#print the date of two variables in table format
pr -2 -t -d  --width=120 <<eof
$col1
$col2
eof
echo "-----------------------------------------------------------------------------------------------"
