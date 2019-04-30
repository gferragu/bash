#!/bin/bash

#
# Copy files (and associated components) that have anomalously low time windows into a new directory
# and remove the old ones.
#

dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/TXT_Files/"
dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/"
dir3="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records/"
dir4="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records_Unprocessed/"
dir5="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/Event_Data/"


# Create list of all current SAC records from Saudi Network

cd $dir4

# Get list of times, compare awk field(s) to "00" or "0000"

ls | awk '{print}' > anomlst.txt  #Argument list too long error with pattern recognition

lines=$( wc -l anomlst.txt | awk '{print $1}')
count=1

#Ensure newline at end of file
sed -i '' -e '$a\' anomlst.txt


while read anom
do
    echo "Checking file $count / $lines"

    search1=$(echo $anom | awk -F. '{print $5}')
    search2=$(echo $anom | awk -F. '{print $6}')

    if [ "$search1" -ne 00 ] || [ "$search2" -ne 0000 ]
    then

        yr=$(echo $anom | awk -F. '{print $1}')
        day=$(echo $anom | awk -F. '{print $2}')
        hour=$(echo $anom | awk -F. '{print $3}')

        station=$(echo $anom | awk -F. '{print $8}')
        chan1_2_3=$(echo $anom | awk -F. '{print $10}')
        chan1_2=$( echo $chan1_2_3 | awk '{print substr($1, 1, length($1)-1)}')
       

        cp $yr"."$day"."$hour*$station*$chan1_2* ../anomalous_start_time_records/

    fi

    count=$((count+1))
done < anomlst.txt

#rm anomlst.txt