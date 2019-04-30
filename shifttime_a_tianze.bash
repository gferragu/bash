#!/bin/bash

dir1="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/"
dir2="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/All_Stations/"
dir3="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/DSMN/"
dir4="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/EDZN/"
dir5="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/GALN/" 
dir6="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/ILKN/"
dir7="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/ROMN/"

cd $dir1

while read stnm
do
	cd $dir1/$stnm
	echo $stnm
	ls *SAC > sac.lst

	while read sacnm
	do

		atime=$(dumpSHD $sacnm a | awk '{print $3}')

		echo "r $sacnm" > tmp.in
		echo "ch allt -$atime" >> tmp.in
		echo "wh" >> tmp.in
		echo "q" >> tmp.in

		sac < tmp.in
		rm tmp.in

	done < sac.lst

done < /Users/temp/Google_Drive/UGSS_Work/Canadian_Data/TXT_Files/stn.lst
