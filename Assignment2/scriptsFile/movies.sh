#!/bin/bash
#Getting title name from user
read -p "Enter your title: " title
#download data from imdb site with respective title
wget -O- -q https://imdb-api.com/en/API/SearchMovie/k_85zwk0au/$title > movie.json
#convert data into json format 
jq . movie.json
#remove json file
rm movie.json
