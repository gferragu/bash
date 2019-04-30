#!/bin/bash

# May 22nd
# Script to take the contents of "/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records"
# and separate the data by channel code, as we are interested in broadband/high-broadband Saudi data
# 


dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/TXT_Files/"
dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/"
dir3="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records/"
dir4="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/Event_Data/"

cd $dir3

# Copy only the broadband and high broadband, or rather, particularly NOT the long period records to 
# new directories.

for f in *..B*
do
    
    cp $f ../Band-Broadband_HighBroadband_Records/

    echo " File $f copied to ../Band-Broadband_HighBroadband_Records"

done

for f in *..H*
do
    
    cp $f ../Band-Broadband_HighBroadband_Records/

    echo " File $f copied to ../Band-Broadband_HighBroadband_Records"

done

for f in *..V*
do
    
    cp $f ../Band-Long_Period_Records/

    echo " File $f copied to ../Band-Long_Period_Records"

done


