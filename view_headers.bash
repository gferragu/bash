#!/bin/bash


# Script that will read sac headers of files in directory it is called from
# Aliased as "lsh"

#list_header()
#{
	for f in *SAC
	do
    
		echo "r $f" > tmp.in
		echo "lh" >> tmp.in
                echo "q" >> tmp.in
		
		sac < tmp.in
		rm tmp.in	
		
		read -p "Press enter to continue"
		
	
	done	

#}
