#!/bin/bash

DSMN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/DSMN_Reformat/'

EDZN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/EDZN_Reformat/'

GALN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/GALN_Reformat/'

ILKN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/ILKN_Reformat/'

ROMN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/ROMN_Reformat/'

all='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/All_Stations_Reformat/'

cd $DSMN_Reformat

# Create list of directory contents

ls | awk '{print}' > saclst.txt  #Argument list too long error with pattern recognition

#find -type f -name '*.SAC' | awk '{print}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' saclst.txt

echo "Non-catalog Event List" > NonCatalogEvents.txt

mv NonCatalogEvents.txt ../../TXT_Files/

count=0

while read sacnm
do

    count=$((count + 1))

    f1=0
    f2=0
    f3=0


    echo "---------------------------------------------------"
    echo " Working on file $sacnm ... Progress: $count / 8079"
    echo "---------------------------------------------------"

    evla_check=$(dumpSHD $sacnm evla | awk '{print $3}')

    echo $evla_check

    evlo_check=$(dumpSHD $sacnm evlo | awk '{print $3}')

    echo $evlo_check

    evdp_check=$(dumpSHD $sacnm evdp | awk '{print $3}')

    echo $evdp_check


    if [ "$evla_check" == "-12345.00000" ]
    then
        f1=1
    fi 

    if [ "$evlo_check" == "-12345.00000" ]
    then
        f2=1
    fi 

    if [ "$evdp_check" == "-12345.00000" ]
    then
        f3=1
    fi 
    

    if [ "$f1" -eq 1 ] || [ "$f2" -eq 1 ] || [ "$f3" -eq 1 ]
    then

        
        echo "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
        echo " Event $sacnm appears to not be in the catalog     "
        echo "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"


        # May 21st, modifying to copy non catalog events to another folder
        #mv $sacnm ../NonCatalog_Events/

        # May 21st, modifying to remove the non catalog events from the station folders

        #rm $sacnm
        
        #echo $sacnm >> ../../TXT_Files/NonCatalogEvents.txt
    else

        echo
        echo "----------------------------------------------------------"
        echo " Event $sacnm is in the catalog...                 "
        echo "----------------------------------------------------------"
        echo

    fi




done < saclst.txt