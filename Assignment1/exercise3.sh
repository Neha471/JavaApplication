#!/bin/bash
#Create a file and give it below permissions. Also, list User owner and Group of this file. 
#Read and write permissions
#Read and execute permissions
#Read ,Write and Execute permissions

read -p "Do you want to create file(Type 'y' for yes or 'n' for no):" ANSWER
if [ $ANSWER == 'y' ]
then
	read -p "Enter the name of a file with extension: " FILE
	touch $FILE
	echo "Which type of operation you want to perform:-
	1. Read and write permissions			
	2. Read and execute permissions		
	3. Read ,Write and Execute permissions"
	read -p "Enter your choice: " CHOICE
	case "$CHOICE" in
		1)
			echo "Whom you want to give permission:
			a. User
			b. Group
			c. Other
			d. All"
			read -p "Enter: " CHOICE2
			case "$CHOICE2" in
				a)
					chmod 600 $FILE
					echo "Permission has given to USER of Read and Write"
					;;
				b)
					chmod 060 $FILE
					echo "Permission has given to GROUP of Read and Write"
					;;
				c)
					chmod 006 $FILE
					echo "Permission has given to OTHER of Read and Write"
					;;
				d)
					chmod 666 $FILE
					echo "Permission has given to all of Read and Write"
					;;
				*)
					echo "Invalid choice"
					;;
			esac
			;;
		2)
			echo "Whom you want to give permission:
			a. User
			b. Group
			c. Other
			d. All"
			read -p "Enter: " CHOICE2
			case "$CHOICE2" in
				a) 
					chmod 500 $FILE
					echo "Permission has given to USER of Read and Execute"
					;;
				b)
					chmod 050 $FILE
					echo "Permission has given to GROUP of Read and Execute"
					;;
				c)
					chmod 005 $FILE
					echo "Permission has given to OTHER of Read and Execute"
					;;
				d)
					chmod 555 $FILE
					echo "Permission has given to all of Read and Execute"
					;;
			esac
			;;
		3)
			echo "Whom you want to give permission:
			a. User
			b. Group
			c. Other
			d. All"
			read -p "Enter: " CHOICE2
			case "$CHOICE2" in
				a)
					chmod u+rwx $FILE
					echo "Permission has given to USER of Read, Write and Execute"
					;;
				b)
					chmod 070 $FILE
					echo "Permission has given to GROUP of Read, Write and Execute"
					;;
				c)
					chmod 007 $FILE
					echo "Permission has given to OTHER of Read, Write and Execute"
					;;
				d)
					chmod u=rwx,g=rwx,o=wx $FILE
					echo "Permission has given to all of Read, Write and Execute"
					;;
			esac
			;;
	esac
			

else
	echo "OK"
fi
stat -c "Owner is:%U Group name is: %G" $FILE
