#!/bin/bash


# Script that will read sac headers of files in directory it is called from
# Aliased as "set_sac"

read -p "Make sure to list arguments as EVLA, EVLO, EVDP, MAG, and <filename>"
read -p "To set event information in all local SAC files, press enter"

for f in *SAC
do

    EVLA=$1
    EVLO=$2
    EVDP=$3
    MAG=$4
    file=$5

    echo "r $f" > tmp.in
	echo "ch evla $EVLA" >> tmp.in
    echo "ch evlo $EVLO" >> tmp.in
    echo "ch evdp $EVDP" >> tmp.in
    echo "ch mag $MAG" >> tmp.in

    echo "wh" >> tmp.in
    echo "q" >> tmp.in
		
    sac < tmp.in
	rm tmp.in	
	
done