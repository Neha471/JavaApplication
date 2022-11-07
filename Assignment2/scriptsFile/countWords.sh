#!/bin/bash
#Desc: Find out frequency of words in a file
#check the condition is there any file with script or not
if [ $# -ne 1 ];
then
	echo "Usage: $0 filename";
	exit -1
fi

#create variable for filename
filename=$1
#converts all words of uppercase in lowercase and returns the word
tr '[:upper:]' '[:lower:]' <dummy.txt|egrep -o "\b[[:alpha:]]+\b" | \

awk '{ count[$0]++ }
END {printf("%-14s%s\n","Word","Count") ;
PROCINFO["sorted_in"] = "@val_num_desc"
for(ind in count)
	{ printf("%-14s%d\n",ind,count[ind]); }
}'
