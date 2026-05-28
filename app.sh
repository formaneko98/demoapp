#!/usr/bin/env bash

hodina=$(date +%H%M)
tajne="anus"
tajnoucke="pipinka"


if [ "$hodina" -gt 1200  ]; then
	while true; do
		echo "demoapp VERSION 2 is running at $(date) a smrdí ti $tajne"
		sleep 5
	done

else
	 while true; do
               echo "demoapp VERSION 2 is running at $(date) a smrdí ti $tajnoucke"
               sleep 5
       done
fi
