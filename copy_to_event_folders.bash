#!/bin/bash

# May 28th
# Script to take the contents of "/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records"
# and collect records at the same time into folders
# 


dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/TXT_Files"
dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/seed_files/"
dir3="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records/"
dir4="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/Band-Broadband_HighBroadband_Records/"
dir5="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/Band-Broadband_HighBroadband_Records/seismometer_records/"

cd $dir2

# Copy only the broadband and high broadband, or rather, particularly NOT the long period records to 
# new directories.

#echo "" > record_folder_list.txt

#while read list
#do
    
    #cd $list

    #ls | head -1 | awk -F. '{print $1"."$2"."$3"."$4"."$5}' >> ../record_folder_list.txt

    #echo " Event $f added to list "

    #cd ..

#done < $dir1/seed_folder_list.txt

#mv record_folder_list.txt $dir1

cd $dir5

while read list
do

    echo " Searching for $list ..."

    files=( $list* )

    tmp=$(echo "${files[0]}")

    echo $tmp

    if [ -e $tmp ] && [ ! -d $list ]
    then
        mkdir $list

        echo " Directory $list made ..."

        cp $list* $list/

    else

        echo "No files matching $list found, no directory made"

    fi

done < $dir1/record_folder_list.txt
