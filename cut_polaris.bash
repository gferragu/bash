#!/bin/bash

# Generic script to run through data
# June 26th, modifying to cut select Polaris data


base="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/snr_2/cut_O=0/"


#Directories to run through and cut
dir1=snr_2_all_NEZ
dir2=snr_2_all_RTZ
dir3=snr_2_all_NERTZ
dir4=cut_test

cd $base$dir3

tmp_dir=$(pwd)

echo "In directory: $tmp_dir ... "
 
ls *SAC| awk '{print}' > sac_lst.txt


while read sacnm
do
    echo "r $sacnm" > tmp.in

    echo "Pre Cut Header File"
    echo
    echo "lh" >> tmp.in

    O=$(dumpSHD $sacnm O | awk '{print $3}')
    echo " OMARKER time: $O"

    arr=$(dumpSHD $sacnm a | awk '{print $3}')
    echo "Arrival time used in cutting: $arr"

    cutmin=$(echo "$arr - 20.0" | bc )
    echo
    echo "start cut is : $cutmin"
    echo
    cutmax=$(echo "$arr + 60.0" | bc )
    echo
    echo "end cut is : $cutmax"
    echo

    #echo "cutim A -20 A 60" >> tmp.in
    #echo "cutim O $cutmin O $cutmax" >> tmp.in
    
    echo "cut A -20 A 60" >> tmp.in
    #echo "cutim O $cutmin O $cutmax" >> tmp.in

    echo "read" >> tmp.in


    echo "Post Cut Header File"
    echo
    echo "lh" >> tmp.in

    echo "w over" >> tmp.in
    echo "q" >> tmp.in

	sac < tmp.in
	rm tmp.in
	
done < sac_lst.txt

rm sac_lst.txt


cd ..
