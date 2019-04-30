#!/bin/bash


# Script that will read sac and quickly plot files in directory it is called from
# Aliased as "view_sac"

read -p "Plotting sac files for overview ..."
read -p "Press enter to continue"

for f in *SAC
do
    
	echo "r $f" > tmp.in
	echo "p1" >> tmp.in
    read -p "Press enter to view next seismogram(s)"
    echo "q" >> tmp.in
    sac < tmp.in
	rm tmp.in

		
done	


