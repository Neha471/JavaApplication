#!/bin/bash
array=('ab' 'cd' 'ef')
swap1() {
	var=${array[1]}
	array[1]=${array[0]}
	array[0]=$var
}
swap2() {
	var=${array[2]}
	array[2]=${array[0]}
	array[0]=$var
}
for  ((  i=0 ; i<6; i++ ))
do
	echo ${array[0]}${array[1]}${array[2]}
	if [ `expr $i % 2` == 0 ]
	then
		swap1
	else
		swap2
	fi
done
