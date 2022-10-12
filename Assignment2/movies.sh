#!/bin/bash
read -p "Enter your title: " title
wget -O- -q https://imdb-api.com/en/API/SearchMovie/k_85zwk0au/$title > movie.json
jq . movie.json
rm movie.json
