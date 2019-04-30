#!/bin/bash

# May 10th 2018
# Script to run through all SEED files and use rdseed to append station information (lat, lon, etc) to the header ( and hopefully event information too)

rdseed="/Users/temp/rdseed/rdseed"


dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/seed_files/"

dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/"

dir3="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records"


cd $dir1

# Create list of directory contents

ls | awk '{print}' > evntlst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' evntlst.txt

#Run through list, append station information to header

while read evntnm
do
    echo "--------------------------------------------"
    echo " Working on $evntnm ...    "
    echo "--------------------------------------------"

    cd $evntnm

    # Unpack seed volumes
    #$rdseed -d -o 1 -f FullSeed_event.seed

    # Adding funcitonality to remove sac files, rename, and replace in separate folders

    cp *SAC $dir3

    cd $dir1

done < evntlst.txt

rm evntlst.txt
rm sdlst.txt