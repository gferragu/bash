#!/bin/bash

# Script to rename newly unpacked SEED volumes from POLARIS data to our previous naming convention
# Current naming convention ex: 2004.218.01.46.47.0000.PO.DSMN..BHZ.D.SAC
# Converted to new naming convention:DSMN.2004-218-01-46-47.BHZ.SAC

# Will make copies of the data, leaving the original convention as well.


DSMN='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/DSMN/'

EDZN='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/EDZN/'

GALN='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/GALN/'

ILKN='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/ILKN/'

ROMN='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/ROMN/'


#test='/Users/temp/Desktop/Canadian_Data/sac_files/test/'

all='/Users/temp/Desktop/Canadian_Data/sac_files/All_Stations/'

cd $all

# Create list of directory contents

ls | awk '{print}' > saclst.txt  #Argument list too long error with pattern recognition

#find -type f -name '*.SAC' | awk '{print}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' saclst.txt

#Run through list, format naming

while read sacnm
do

    stn=$(echo $sacnm | awk -F. '{print $8}')

    yr=$(echo $sacnm | awk -F. '{print $1}')

    jDay=$(echo $sacnm | awk -F. '{print $2}')

    hr=$(echo $sacnm | awk -F. '{print $3}')

    min=$(echo $sacnm | awk -F. '{print $4}')

    sec=$(echo $sacnm | awk -F. '{print $5}')

    comp=$(echo $sacnm | awk -F. '{print $10}')

    #name=$(awk '{print $stn "." $yr '-' $jDay '-' $hr '-' $min '-' $sec "." $comp ".SAC"}' | echo)

    name=$(echo $stn"."$yr'-'$jDay'-'$hr'-'$min'-'$sec"."$comp".SAC")

    echo
    echo $name
    echo

    if [ "$stn" == "DSMN" ]
    then
        cp $sacnm ../DSMN_Reformat/

        mv ../DSMN_Reformat/$sacnm ../DSMN_Reformat/$name

        echo "File has been renamed "$name" and placed in the appropriate Reformat folder"

    fi

    if [ "$stn" == "EDZN" ]
    then
        cp $sacnm ../EDZN_Reformat/

        mv ../EDZN_Reformat/$sacnm ../EDZN_Reformat/$name

        echo "File has been renamed "$name" and placed in the appropriate Reformat folder"

    fi

    if [ "$stn" == "GALN" ]
    then
        cp $sacnm ../GALN_Reformat/

        mv ../GALN_Reformat/$sacnm ../GALN_Reformat/$name

        echo "File has been renamed "$name" and placed in the appropriate Reformat folder"

    fi

    if [ "$stn" == "ILKN" ]
    then
        cp $sacnm ../ILKN_Reformat/

        mv ../ILKN_Reformat/$sacnm ../ILKN_Reformat/$name

        echo "File has been renamed "$name" and placed in the appropriate Reformat folder"

    fi

    if [ "$stn" == "ROMN" ]
    then
        cp $sacnm ../ROMN_Reformat/

        mv ../ROMN_Reformat/$sacnm ../ROMN_Reformat/$name

        echo "File has been renamed "$name" and placed in the appropriate Reformat folder"

    fi




done < saclst.txt