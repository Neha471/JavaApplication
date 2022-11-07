#!/bin/bash
#Getting password from user
read -p "Enter your password: " passwrd
#display choices
echo "Algorithms: 
1. SHA1
2. SHA224
3. SHA512
4. SHA256
5. SHA384"
#Getting type of algorithm from user
read -p "Which type of algorithm you want: " algo
#switch case for different choices and convert passwords into respective choice
case "$algo" in
	1)
		echo '$passwrd' | openssl enc -aes-256-cbc -md sha1 -a -pbkdf2 -iter 100000 -salt -pass pass:'set-encryption-password ' > secret_vault.txt
		echo -n "Your encrypted password is: "
		cat secret_vault.txt
		echo "Alogo name: SHA-1"
		;;
	2)
		echo '$passwrd' | openssl enc -aes-256-cbc -md sha224 -a -pbkdf2 -iter 100000 -salt -pass pass:'set-encryption-password ' > secret_vault.txt
		echo -n "Your encrypted password is: "
		cat secret_vault.txt
		echo "Algo name: SHA-224"
		;;
	3)
		echo '$passwrd' | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:'set-encryption-password ' > secret_vault.txt
		echo -n "Your encrypted password is: "
		cat secret_vault.txt
		echo "Algo name: SHA-512"
		;;
	4)
		echo '$passwrd' | openssl enc -aes-256-cbc -md sha256 -a -pbkdf2 -iter 100000 -salt -pass pass:'set-encryption-password ' > secret_vault.txt
		echo -n "Your encrypted password is: "
		cat secret_vault.txt
		echo "Algo name: SHA-256"
		;;
	5)
		echo '$passwrd' | openssl enc -aes-256-cbc -md sha384 -a -pbkdf2 -iter 100000 -salt -pass pass:'set-encryption-password ' > secret_vault.txt
		echo -n "Your encrypted password is: "
		cat secret_vault.txt
		echo "Algo name: SHA-384"
		;;
	*)
		echo "Invalid Choice"
		exit 1
esac

