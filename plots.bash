#!/bin/bash

cd sac/

for f in *SAC
do

	echo "r $f" > tmp.in
	echo "plot" >> tmp.in
	echo "saveimg ../pdf/$f.pdf" >> tmp.in
	echo "q" >> tmp.in

	sac < tmp.in
	rm tmp.in
	
	

done


cd ..
