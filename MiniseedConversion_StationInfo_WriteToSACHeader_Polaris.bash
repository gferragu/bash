#!/bin/bash

# May 10th 2018
# Script to run through all miniSEED or ".sd" files and use rdseed to append station information (lat, lon, etc) to the header

echo $PATH
rdseed="/Users/temp/rdseed/rdseed"


dir1="/Users/temp/Desktop/Canadian_Data/sd_files/"

dir2= "/Users/temp/Desktop/Canadian_Data/sac_files/"

PO="/Users/temp/Desktop/Canadian_Data/sd_files/PO.dataless"

CN="/Users/temp/Desktop/Canadian_Data/sd_files/CN.dataless"

cd $dir1

# Create list of directory contents

ls *.sd | awk '{print}' > sdlst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' sdlst.txt

#Run through list, append station information to header

while read sdnm
do

    $rdseed -d -o 1 -f $sdnm -g $PO

done < sdlst.txt

#mv *DSMN* $dir2

#mv *EDZN* $dir2

#mv *GALN* $dir2

#mv *ILKN* $dir2

#mv *ROMN* $dir2