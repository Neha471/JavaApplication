#!/bin/bash
#Write a shell script that prompts the user for a name of a file or directory and reports if it is a regular file, a directory, or othertype of file.
read -p "Eneter the path of a file" FILE
if [ -f $FILE ]
then
	echo "It is a regular file"
elif [ -d $FILE ]
then
	echo "It is a Directory"
else
	echo "It is a other type of file"
fi

