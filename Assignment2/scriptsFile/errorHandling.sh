#!/bin/bash
#Create variable to store String
STRING=$1
#Check the condition that is there any argument with script or not and if it is then print reverse string 
if [ "$STRING" != "" ]
then
	echo -n "Reverse Value is: "
	echo $STRING | rev
else
	echo -n "Pass some Argument"
fi
