#!/bin/bash

# External Drive
#base="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/ReceiverFunctions/"

base="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/ReceiverFunctions/"


data="Events/"
#data="EventsTest/"

cd $base

pwd

cd $data

#pwd

ls -d */ > stn_list.txt

while read stnm
do
    cd $stnm

    echo "Station name: $stnm"

    mkdir ../../RF_Figs-$stnm

    mkdir ../../RF-$stnm

    ls -d */ > evnt_list.txt

    while read evntnm
    do

        echo "Event name: $evntnm"

        fig_nm=$(echo $evntnm | cut -d '/' -f 1)

        echo "Fig_nm : $fig_nm"

        cd $evntnm
        cd "Sac"

        ../IDOEVT

        cd ../GOOD

        ../IDOROT

        cd ..

        DORFTN

        cd RFTN

        echo "r *" > tmp.in
        echo "fileid name" >> tmp.in
        echo "bg plt" >> tmp.in
        echo "p" >> tmp.in
        echo "plotnps -F7 -W10 -EPS -K < P001.PLT > P001.eps" >> tmp.in
        echo "convert -trim P001.eps $fig_nm.png" >> tmp.in
        echo "quit" >> tmp.in

        gsac < tmp.in
        rm tmp.in


        cp $fig_nm.png ../../../../RF_Figs-$stnm/

        cp_nm=$(echo $stnm | cut -d '/' -f 1)

        cp *$cp_nm* ../../../../RF-$stnm/

        cd ../../

        echo
        echo "Current working directory: "
        pwd
        echo



    done < evnt_list.txt
   
    rm evnt_list.txt

    cd ..

done < stn_list.txt


rm stn_list.txt