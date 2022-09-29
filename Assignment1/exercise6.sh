#!/bin/bash
read -p "Enter your file name which you want to read: " FILE
LINE_NUM=1
while read LINE
do
	echo "${LINE_NUM}: ${LINE}"
	((LINE_NUM++))
done < $FILE
read -p "Enter the second file name which you want to write from the first file: " FILE2
cp $FILE $FILE2



