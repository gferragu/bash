#!/bin/bash


# Script that will read sac headers of files in directory it is called from
# Aliased as "rst_sac"

read -p "To reset event information in all local SAC files, press enter"
read -p "Are you sure? This cannot be undone. If certain, press enter again"

for f in *SAC
do

    echo "r $f" > tmp.in
	echo "ch evla -12345.00000" >> tmp.in
    echo "ch evlo -12345.00000" >> tmp.in
    echo "ch evdp -12345.00000" >> tmp.in
    echo "ch mag -12345.00000" >> tmp.in
    echo "ch dist -12345.00000" >> tmp.in
    echo "ch az -12345.00000" >> tmp.in
    echo "ch baz -12345.00000" >> tmp.in
    echo "ch gcarc -12345.00000" >> tmp.in
    echo "wh" >> tmp.in
    echo "q" >> tmp.in
		
    sac < tmp.in
	rm tmp.in	
	
done