#!/bin/bash

# Copies select data from signal to noise ratio checking

# Format stn_list as "station_processed ......."

dir1="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/"

cd $dir1

while read stnm
do
    cd $dir1/$stnm
    echo
    echo $stnm
    echo

    stnm=$(echo $stnm | awk -F_ '{print $1}')

    while read sacnm
    do

        #cp_name=$(echo $stnm | awk '{print $1"_select"}')
        cp_name=All_select

        echo
        echo "Copying to directory: $cp_name"
        echo

        cp $sacnm ../$cp_name

    done < sac_select_2_$stnm.txt #sac_select_5_$stnm.txt


done < /Users/temp/Google_Drive/USGS_Work/Canadian_Data/TXT_Files/stn_list.txt