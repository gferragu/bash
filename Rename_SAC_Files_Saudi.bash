#!/bin/bash

####### Adopted from a script for renaming Polaris Data #########

# Script to rename newly unpacked SEED volumes from Saudi data to a previous naming convention
# Current naming convention ex: 2004.218.01.46.47.0000.PO.DSMN..BHZ.D.SAC
# Converted to new naming convention:DSMN.2004-218-01-46-47.BHZ.SAC

# Will make copies of the data, leaving the original convention as well.

dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/seed_files/"

dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/"

dir3="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records"

cd $dir3

# Create list of directory contents

ls | awk '{print}' > saclst.txt  #Argument list too long error with pattern recognition

#find -type f -name '*.SAC' | awk '{print}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' saclst.txt

#Run through list, append station information to header

while read sacnm
do

    stn=$(echo $sacnm | awk -F. '{print $8}')

    yr=$(echo $sacnm | awk -F. '{print $1}')

    jDay=$(echo $sacnm | awk -F. '{print $2}')

    hr=$(echo $sacnm | awk -F. '{print $3}')

    min=$(echo $sacnm | awk -F. '{print $4}')

    sec=$(echo $sacnm | awk -F. '{print $5}')

    comp=$(echo $sacnm | awk -F. '{print $10}')

    name=$(echo $stn"."$yr'-'$jDay'-'$hr'-'$min'-'$sec"."$comp".SAC") # By station


    #name=$(echo $stn"."$yr'-'$jDay'-'$hr'-'$min'-'$sec"."$comp".SAC") # By event

    echo
    echo $name
    echo

    cp $sacnm ../By_Station/

    cd ../By_Station/

    mv $sacnm $name

    cd $dir3

done < saclst.txt