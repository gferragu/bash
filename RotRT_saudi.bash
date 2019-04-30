#!/bin/bash

# Set ray parameters for SAC files of a specific event
# Easiest to copy NEZ foldler and rename one as RTZ

#dir="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/event_data/800s_post_arrival-0.5-10HzFilter-2010-2016"
#dir="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/event_data/800s_post_arrival-0.5-10HzFilter"
basedir="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/event_data/"
#dir="snr_2_rotTest"
dir="snr_10_rotTest"

cd $basedir
cd $dir

#Create list of directory contents (event folders)

ls | awk '{print}' > evntlst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' evntlst.txt

#Rotate N and E components to R and T components for a specific event, after ray parameters are set

dir_RTZ="$dir _RTZ"
dir_RTZ=$(echo $dir_RTZ | tr -d ' ')

mkdir ../$dir_RTZ

cp -r . ../$dir_RTZ

cd ..
cd $dir_RTZ/

#Create list of directory contents (event folders)
ls -d */ | awk '{print}' > evntlst.txt

#num=$(ls -d */ | wc -l)

ecount=0
ficount=0

#Do the rotation
while read evntnm
do
	cd $evntnm

	finum=$(ls *SAC | wc -l)

   	ls *Z.D.SAC* > sac_list.txt

	while read sacnm
	do

		base=$(echo $sacnm | awk -F. '{print $1"."$2"."$3"."$4"."$5"."$6"."$7"."$8}')
		comp=$(echo $sacnm | awk -F. '{print $9}')
		comp12=$(echo $comp | awk '{ print substr($0,0,2)}' )
	
		#Allows for variable components and bands
		sacnmZ=${base}.${comp12}Z.D.SAC
		echo $sacnmZ

		sacnmN=${base}.${comp12}N.D.SAC
		echo $sacnmN

		sacnmE=${base}.${comp12}E.D.SAC
		echo $sacnmE

		sacnmR=${base}.${comp12}R.D.SAC
		echo $sacnmR

		sacnmT=${base}.${comp12}T.D.SAC
		echo $sacnmT
	
		echo "r $sacnmE" > tmp.in 
		echo "ch cmpaz 90 cmpinc 90" >> tmp.in
		echo "wh" >> tmp.in
		echo "r $sacnmN" >> tmp.in
		echo "ch cmpaz 0 cmpinc 90" >> tmp.in
		echo "wh" >> tmp.in
		echo "r $sacnmE $sacnmN" >> tmp.in
		echo "rotate" >> tmp.in
		echo "w $sacnmR $sacnmT" >> tmp.in
		echo "q" >> tmp.in

		sac < tmp.in
		rm tmp.in

	done < sac_list.txt

	rm sac_list.txt
	cd ..

done < evntlst.txt


