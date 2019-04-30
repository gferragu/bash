#!/bin/bash

# External Drive
base="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/Reformatted/snr_2/"

resp="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/Reformatted/RESP"

#data="cut_O=0/snr_2_all_NEZ/"
data="snr_2_all_NEZ-cutO=0/"
#data="snr_2_all_NEZ/"

cd $base

cd $data

mkdir ../../../ReceiverFunctions

mkdir ../../../ReceiverFunctions/all

cp *SAC ../../../ReceiverFunctions/all

cd ../../../ReceiverFunctions/all/

cp -R $resp ../

#ls *SAC > sac_list.txt

#while read stnm
#do

    #Rename with *sac* not *SAC*

    #base_nm=$(echo $stnm | awk -F. '{print $1"."$2"."$3}')

    #echo 
    #echo "The base name: $base_nm"
    #echo

    #ext=$(echo "sac")

    #new_nm=$(echo $base_nm"."$ext)

    #mv $stnm $new_nm
   

#done < sac_list.txt

#rm sac_list.txt

mkdir ../Events

mkdir ../Events/DSMN
mkdir ../Events/EDZN
mkdir ../Events/GALN
mkdir ../Events/ILKN
mkdir ../Events/ROMN

#ls *Z.sac > evnt_list.txt
ls *Z.SAC > evnt_list.txt

while read evntnm
do

    stn_nm=$(echo $evntnm | awk -F. '{print $1}')
    copy=$(echo $evntnm | awk -F. '{print $1"."$2}')
    new_dir=$(echo $evntnm | awk -F. '{print $2}')

    if [ "$stn_nm" = "DSMN" ]; then

        mkdir ../Events/DSMN/$new_dir

        mkdir ../Events/DSMN/$new_dir/Sac

        mkdir ../Events/DSMN/$new_dir/TEMP

        cp $copy* ../Events/DSMN/$new_dir/Sac/

        cp ../RESP/*$stn_nm* ../Events/DSMN/$new_dir/Sac/

        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOEVT ../Events/DSMN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOROT ../Events/DSMN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/DORFTN ../Events/DSMN/$new_dir/

        echo 
        echo "Files $copy* copied to event folder: ../Events/$new_dir"
        echo
    fi

    if [ "$stn_nm" = "EDZN" ]; then

        mkdir ../Events/EDZN/$new_dir

        mkdir ../Events/EDZN/$new_dir/Sac

        mkdir ../Events/EDZN/$new_dir/TEMP

        cp $copy* ../Events/EDZN/$new_dir/Sac/

        cp ../RESP/*$stn_nm* ../Events/EDZN/$new_dir/Sac/

        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOEVT ../Events/EDZN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOROT ../Events/EDZN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/DORFTN ../Events/EDZN/$new_dir/

        echo 
        echo "Files $copy* copied to event folder: ../Events/$new_dir"
        echo

    fi

    if [ "$stn_nm" = "GALN" ]; then

        mkdir ../Events/GALN/$new_dir

        mkdir ../Events/GALN/$new_dir/Sac

        mkdir ../Events/GALN/$new_dir/TEMP

        cp $copy* ../Events/GALN/$new_dir/Sac/

        cp ../RESP/*$stn_nm* ../Events/GALN/$new_dir/Sac/

        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOEVT ../Events/GALN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOROT ../Events/GALN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/DORFTN ../Events/GALN/$new_dir/

        echo 
        echo "Files $copy* copied to event folder: ../Events/$new_dir"
        echo

    fi

    if [ "$stn_nm" = "ILKN" ]; then

        mkdir ../Events/ILKN/$new_dir

        mkdir ../Events/ILKN/$new_dir/Sac

        mkdir ../Events/ILKN/$new_dir/TEMP

        cp $copy* ../Events/ILKN/$new_dir/Sac/

        cp ../RESP/*$stn_nm* ../Events/ILKN/$new_dir/Sac/

        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOEVT ../Events/ILKN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOROT ../Events/ILKN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/DORFTN ../Events/ILKN/$new_dir/

        echo 
        echo "Files $copy* copied to event folder: ../Events/$new_dir"
        echo

    fi

    if [ "$stn_nm" = "ROMN" ]; then

        mkdir ../Events/ROMN/$new_dir

        mkdir ../Events/ROMN/$new_dir/Sac

        mkdir ../Events/ROMN/$new_dir/TEMP

        cp $copy* ../Events/ROMN/$new_dir/Sac/

        cp ../RESP/*$stn_nm* ../Events/ROMN/$new_dir/Sac/

        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOEVT ../Events/ROMN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/IDOROT ../Events/ROMN/$new_dir/
        cp /Users/gabriel/PROGRAMS.330/RF_scripts/DORFTN ../Events/ROMN/$new_dir/


        echo 
        echo "Files $copy* copied to event folder: ../Events/$new_dir"
        echo

    fi
   

done < evnt_list.txt

rm evnt_list.txt