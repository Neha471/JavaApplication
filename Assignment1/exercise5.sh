#!/bin/bash
FILE=/var/log/docker.log
if ! grep "error" "$FILE" > neha.txt; then
	    echo "No error in last 30 minutes" >&2
fi
