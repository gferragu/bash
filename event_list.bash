#!/bin/bash

# May 28th
# Script to take the contents of "/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records"
# and collect records at the same time into folders
# 


dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/TXT_Files"
dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/event_data/"

cut="800s_post_arrival-0.5-10HzFilter_mag"

cd $dir2$cut


echo "stnm stla stlo" > $dir1/stn_coords.txt
echo "evnm evla evlo evdp evmag" > $dir1/recorded_evnt_info.txt

while read evntlist
do 

    cd $evntlist

   ls *Z* | awk '{print}' > files.txt

    while read evnt
    do
        evnm=$(echo $evnt | awk -F. '{print $1"."$2"."$3"."$4"."$5}')

        evla=$(dumpSHD $evnt evla | awk '{print $3}')
        evlo=$(dumpSHD $evnt evlo | awk '{print $3}')
        evdp=$(dumpSHD $evnt evdp | awk '{print $3}')
        evmag=$(dumpSHD $evnt mag | awk '{print $3}')

        echo "$evnm" "$evla" "$evlo" "$evdp" "$evmag" >> $dir1/recorded_evnt_info.txt

        stla=$(dumpSHD $evnt stla | awk '{print $3}')
        stlo=$(dumpSHD $evnt stlo | awk '{print $3}')
        stnm=$(dumpSHD $evnt kstnm | awk '{print $3}')

        echo "$stnm" "$stla" "$stlo" >> $dir1/stn_coords.txt


    done < files.txt

    rm files.txt

    cd ..

done < $dir1/recorded_evntlist.txt
