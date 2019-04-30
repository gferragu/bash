#!/bin/bash

# May 22nd
# Script to take the contents of "/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records"
# and separate the data by channel code, as we are interested in broadband/high-broadband Saudi data
# 


dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/TXT_Files/"
dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/"
dir3="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records/"
dir4="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/Band-Broadband_HighBroadband_Records/"
dir5="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/Band-Broadband_HighBroadband_Records/seismometer_records/"
dir6="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/Band-Broadband_HighBroadband_Records/accelerometer_records/"

cd $dir4

# Copy only the broadband and high broadband, or rather, particularly NOT the long period records to 
# new directories.

for f in *..BH*
do
    
    cp $f $dir5

    echo " File $f copied to $dir5"

done

for f in *..HH*
do
    
    cp $f $dir5

    echo " File $f copied to $dir5"

done

for f in *..HN*
do
    
    cp $f $dir6

    echo " File $f copied to $dir6"

done