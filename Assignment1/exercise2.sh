#!/bin/bash
#List the files for a particular date or date range
echo "1. Lists of particular date
2. List of date range i.e. (1 day before, 2 day before etc...)
3. List of date range i.e. (from this particular date to another particular date)"
read -p "Enter your choice: " CHOICE
case "$CHOICE" in
	1)
		read -p "Enter date(yyyy-mm-dd): " DATE
		echo "List the files of particular date:"
		echo "---------------------------------------------------------------------------------------------------"
		ls --full-time | grep "$DATE"
		;;
	2)
		read -p "Enter your days: " DAYS 
		echo "List of files are:"
		echo "---------------------------------------------------------------------------------------------------"
		find $pwd -type f -mtime -$DAYS -ls
		;;
	3)
		read -p "Enter your First date(yyyy-mm-dd): " DATE1
		read -p "Enter your second date(yyyy-mm-dd): " DATE2
		echo "List of files are: "
		echo "---------------------------------------------------------------------------------------------------"
		NEXT_DATE=$(date +%Y-%m-%d -d "$DATE2 + 1 day")
		find $pwd -newermt "$DATE1" ! -newermt "$NEXT_DATE" -ls
		;;
	*)
		echo "Invalid Choice"
		;;
esac
