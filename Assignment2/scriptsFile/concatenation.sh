#!/bin/bash
#carete an array variable and store the value
array=('ab' 'cd' 'ef')
#create a function swap1 which swap 1st and 2nd element
swap1() {
	var=${array[1]}
	array[1]=${array[0]}
	array[0]=$var
}
#create a funtion which swap2 which swap 1st and third element
swap2() {
	var=${array[2]}
	array[2]=${array[0]}
	array[0]=$var
}
#Run for loop which run both swap function and print different combination of array 
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
