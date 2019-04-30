#!/bin/bash

dir1="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/"

cd $dir1

while read stnm
do

    cd $dir1/$stnm
    echo
    echo $stnm
    echo

    ls *SAC > sac_list.txt

    while read sacnm
    do
        
        echo "r $sacnm" > tmp.in
        echo "rmean" >> tmp.in
        echo "rtrend" >> tmp.in
        echo "bp c 0.02 1" >> tmp.in
        echo "w over" >> tmp.in
        echo "q" >> tmp.in

        sac < tmp.in
        rm tmp.in

    done < sac_list.txt

    cd ..

done < /Users/temp/Google_Drive/USGS_Work/Canadian_Data/TXT_Files/stn_list.txt