#!/bin/bash

dir1="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/"

cd $dir1

while read stnm
do

    cd $dir1/$stnm
    echo $stnm
    ls *SAC > sac_list.txt

    while read sacnm
    do
        atime=$( dumpSHD $sacnm a | awk '{print $3}')

        echo "r $sacnm" > tmp.in
        echo "ch allt -$atime" >> tmp.in
        echo "wh" >> tmp.in
        echo "q" >> tmp.in

        sac < tmp.in
        rm tmp.in

    done < sac_list.txt


done < /Users/temp/Google_Drive/USGS_Work/Canadian_Data/TXT_Files/stn_list.txt