#!/bin/bash

dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/event_data/800s_post_arrival-0.5-10HzFilter-2010-2016_shift/"

cd $dir1

#Create list of directory contents (event folders)

ls -d */ | awk '{print}' > evntlst.txt

num=$(ls -d */ | wc -l)

ecount=0
ficount=0

while read evntnm
do

    cd $evntnm

    ls *SAC > sac_list.txt

    finum=$(ls *SAC | wc -l)

    while read sacnm
    do
        t0time=$( dumpSHD $sacnm t0 | awk '{print $3}')

        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "P arrival for $sacnm is $t0time ..."
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo

        echo "r $sacnm" > tmp.in
        echo "ch allt -$t0time" >> tmp.in
        echo "wh" >> tmp.in
        echo "q" >> tmp.in

        sac < tmp.in
        rm tmp.in

        ficount=$((ficount +1 ))

        echo
        echo "The file count is $ficount / $finum"
        echo

    done < sac_list.txt

    ficount=0
    rm sac_list.txt

    echo "######################################"
    echo "Time shifted for $evntnm ..."
    echo "######################################"
    echo

    ecount = $((ecount + 1))

    echo
    echo "The event count is $ecount / $num"
    echo
    
    cd ..

done < evntlst.txt
