#!/bin/bash
STRING=$1
if [ "$STRING" != "" ]
then
	echo -n "Reverse Value is: "
	echo $STRING | rev
else
	echo -n "Pass some Argument"
fi
