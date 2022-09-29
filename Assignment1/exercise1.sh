#!/bin/bash
#Create a shell script which takes a name as command-line argument, and prints its characters.
#Ex: if I pass Alia as command line argument;
#it should print:
#A
#L
#I
#A

VARIABLE=$1
echo "$1" | grep -o .
