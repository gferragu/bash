#!/bin/bash

#dir1="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/snr_2/cut_test/"

#cd $dir1

base="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/snr_2/cut_O=0/"


#Directories to run through and cut
dir1=snr_2_all_NEZ
dir2=snr_2_all_RTZ
dir3=snr_2_all_NERTZ
dir4=cut_test

cd $base$dir3

#while read stnm
#do

    #cd $dir1/$stnm
    #echo $stnm

    ls *SAC > sac_list.txt

    while read sacnm
    do
        #atime=$( dumpSHD $sacnm a | awk '{print $3}')
        otime=$( dumpSHD $sacnm o | awk '{print $3}')
        atime=$( dumpSHD $sacnm a | awk '{print $3}')
        otime=$(echo "(-1)*$otime" | bc)
        echo "otime is : $otime"
        echo "atime is : $atime"

        echo "r $sacnm" > tmp.in

        echo "Pre Cut Header File"
        echo
        echo "lh" >> tmp.in

        #echo "ch allt -$atime" >> tmp.in
        echo "ch allt $otime" >> tmp.in
        #echo "ch allt $atime" >> tmp.in

        echo "Post Cut Header File"
        echo
        echo "lh" >> tmp.in

        echo "wh" >> tmp.in
        echo "q" >> tmp.in

        sac < tmp.in
        rm tmp.in

    done < sac_list.txt

    rm sac_list.txt

#done < /Users/temp/Google_Drive/USGS_Work/Canadian_Data/TXT_Files/stn_list.txt