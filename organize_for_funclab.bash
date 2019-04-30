#!/bin/bash

# External Drive
# Note, there are multiple folders of different filters, paths must be adjusted accordingly

# Recalculate receiver functions with a new low pass value for Simon and Tianze
##### Alter the "base" path as needed to specify the correct receiver functions #####

RF="ReceiverFunctions-LP-0.05"
base="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/$RF/"

data="Events/"

mkdir $base/FuncLab
mkdir $base/FuncLab/RF
mkdir $base/FuncLab/Data

mkdir $base/FuncLab/RF/0.5
mkdir $base/FuncLab/RF/1.0
mkdir $base/FuncLab/RF/2.5

#func="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/$RF/FuncLab/RF/0.5"
#func="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/$RF/FuncLab/RF/1.0"
func="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/$RF/FuncLab/RF/2.5"

raw="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/$RF/FuncLab/Data"

cd $base

echo pwd

cd $data

echo pwd

ls -d */ > stn_list.txt

while read stnm
do
    cd $stnm

    echo "+++++++++++++++++++++++++++++++++++++++++"
    echo "Station name: $stnm"
    echo
    stnm=$(echo $stnm | cut -d '/' -f 1)
    echo
    echo "Station name: $stnm"
    echo "+++++++++++++++++++++++++++++++++++++++++"

    mkdir $func/$stnm
    mkdir $raw/$stnm

    ls -d */ > evnt_list.txt

    while read evntnm
    do

        echo "========================================="
        echo
        echo "Station name: $stnm"
        echo
        echo "========================================="

        evntnm=$(echo $evntnm | cut -d '/' -f 1)

        YYYY=$(echo $evntnm | awk -F- '{print $1}')
        JJJ=$(echo $evntnm | awk -F- '{print $2}')
        HH=$(echo $evntnm | awk -F- '{print $3}')
        MM=$(echo $evntnm | awk -F- '{print $4}')
        SS=$(echo $evntnm | awk -F- '{print $5}')

        evntnm_new=$YYYY"_"$JJJ"_"$HH"_"$MM"_"$SS

        mkdir $func/$stnm/Event_$evntnm_new
        mkdir $func/$stnm/Event_$evntnm_new/RESP

        mkdir $raw/$stnm/Event_$evntnm_new
        mkdir $raw/$stnm/Event_$evntnm_new/RESP

        echo "Event name: $evntnm"
        cd $evntnm
        
        sacnmZ=$stnm.$evntnm_new.z
		sacnmR=$stnm.$evntnm_new.r
		sacnmT=$stnm.$evntnm_new.t
		sacnmRZ=$stnm.$evntnm_new.eqr
		sacnmTZ=$stnm.$evntnm_new.eqt

        #sacnmZ=$stnm.z
		#sacnmR=$stnm.r
		#sacnmT=$stnm.t
		#sacnmRZ=$stnm.eqr
		#sacnmTZ=$stnm.eqt

        echo "Receiver function file names:"
        echo $sacnmZ
		echo $sacnmR
		echo $sacnmT
		echo $sacnmRZ
		echo $sacnmTZ
        echo

        echo
        echo "Copying Sac folder files to RESP in RF"
        echo
        cp Sac/*PO* $func/$stnm/Event_$evntnm_new/RESP/
        cp Sac/resp $func/$stnm/Event_$evntnm_new/RESP/

        echo
        echo "Copying Sac folder files to RESP in Data"
        echo
        cp Sac/*PO* $raw/$stnm/Event_$evntnm_new/RESP/
        cp Sac/resp $raw/$stnm/Event_$evntnm_new/RESP/

        echo
        echo "Copying original SAC files to RF "
        echo
        cp Sac/*E.SAC* $func/$stnm/Event_$evntnm_new/
        cp Sac/*N.SAC* $func/$stnm/Event_$evntnm_new/
        cp Sac/*Z.SAC* $func/$stnm/Event_$evntnm_new/

        echo
        echo "Copying original SAC files to Data "
        echo
        cp Sac/*E.SAC* $raw/$stnm/Event_$evntnm_new/
        cp Sac/*N.SAC* $raw/$stnm/Event_$evntnm_new/
        cp Sac/*Z.SAC* $raw/$stnm/Event_$evntnm_new/

        echo
        echo "Copying z, r, and t files to RF "
        echo
        echo "Copying z file to RF "
        cp Final/*Z $func/$stnm/Event_$evntnm_new/$sacnmZ
        echo "Copying r file to RF "
        cp Final/*R $func/$stnm/Event_$evntnm_new/$sacnmR
        echo "Copying t file to RF "
        cp Final/*T $func/$stnm/Event_$evntnm_new/$sacnmT

        # Change to grab different RFs with differnt gaussian widths
        echo
        echo "Copying RF files to RF"
        echo "Names: $sacnmRZ and $sacnmTZ"
        echo

        #### January 17th: Vary this between 0.5, 1.0, and 2.5 to copy different RFs ####
        #### ALSO CHANGE THE VARIABLE FUNC #####
        cp RFTN/R*2.5 $func/$stnm/Event_$evntnm_new/$sacnmRZ
        cp RFTN/T*2.5 $func/$stnm/Event_$evntnm_new/$sacnmTZ

        cd ..

        echo
        echo "Current working directory: "
        pwd
        echo



    done < evnt_list.txt
   
    rm evnt_list.txt

    cd ..

    echo
        echo "Should be in Events/ working directory: "
        pwd
        echo
    echo

done < stn_list.txt


rm stn_list.txt