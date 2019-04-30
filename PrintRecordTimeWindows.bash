#!/bin/bash

#
# Print record time window length
#

dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/TXT_Files/"
dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/"
dir3="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records/"
dir4="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/Event_Data/"


# Create list of all current SAC records from Saudi Network

cd $dir3

ls | awk '{print}' > reclst.txt  #Argument list too long error with pattern recognition

#find -type f -name '*.SAC' | awk '{print}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' reclst.txt

echo " Windows less than 5 min" > WindowsLT5min.txt

while read recnm
do

    # Number of data points in time window
    npts=$(dumpSHD $recnm npts | awk '{print $3}')

    echo
    echo " The number of points is $npts    "
    echo

    delta=$(dumpSHD $recnm delta | awk '{print $3}')

    echo
    echo " Delta is $delta    "
    echo

    time=$( echo "($npts * $delta) / 60" | bc)

    # Append time window info to "user0"###############
    
    k=$(dumpSHD $recnm user5 | awk '{print $3/1}')

    if [ $k -ne 1 ]
    then
        echo "r $recnm" > tmp.in
        echo "ch user0 $time" >> tmp.in
        echo "ch user5 1" >> tmp.in

        echo "wh" >> tmp.in
        echo "q" >> tmp.in

        sac < tmp.in
        rm tmp.in

        echo " Time window $time appended to SAC header in position user0"
        echo

    else
        echo " Time window information already in user0"
        t = $(dumpSHD $recnm user0 | awk '{print $3}')
        echo " Time window is: $t min "

    fi
    ###################################################

    if [ "$time" -lt "5" ]
    then

        echo "$recnm $time min" >> WindowsLT5min.txt

    fi


    echo "----------------------------------"
    echo "----------------------------------"
    echo "----------------------------------"
    echo "----------------------------------"
    echo "----------------------------------"
    echo "----------------------------------"
    echo "----------------------------------"
    echo 
    echo " Time window is $time min"
    echo 
    echo "----------------------------------"
    echo "----------------------------------"
    echo "----------------------------------"
    echo "----------------------------------"
    echo "----------------------------------"








done < reclst.txt