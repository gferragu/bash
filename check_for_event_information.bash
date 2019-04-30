#!/bin/bash

dir1="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/"
dir2="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/All_Stations/"
dir3="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/DSMN/"
dir4="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/EDZN/"
dir5="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/GALN/" 
dir6="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/ILKN/"
dir7="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/ROMN/" #Needs Processing

#Change directory and "filename" as desired
cd $dir7

filename="no_event_info_ROMN"

# Create list of directory contents

ls | awk '{print}' > saclst.txt  #Argument list too long error with pattern recognition

#find -type f -name '*.SAC' | awk '{print}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' saclst.txt

num_files=$(ls -1 | wc -l)

echo "" > ../../../TXT_Files/$filename.txt

count=0

while read sacnm
do

    count=$((count + 1))

    f1=0
    f2=0
    f3=0


    echo "--------------------------------------------------------------------"
    echo " Working on file $sacnm ... Progress: $count/$num_files"
    echo "--------------------------------------------------------------------"

    evla_check=$(dumpSHD $sacnm evla | awk '{print $3}')

    echo $evla_check

    evlo_check=$(dumpSHD $sacnm evlo | awk '{print $3}')

    echo $evlo_check

    evdp_check=$(dumpSHD $sacnm evdp | awk '{print $3}')

    echo $evdp_check
    echo
    echo


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

        
        #echo "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
        #echo " Event $sacnm appears to not be in the catalog     "
        #echo "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"


        # May 21st, modifying to copy non catalog events to another folder
        #mv $sacnm ../NonCatalog_Events/

        # May 21st, modifying to remove the non catalog events from the station folders

        #rm $sacnm
        
        #echo $sacnm >> ../../TXT_Files/NonCatalogEvents.txt

        # May 31st, modifying to run through events and double check they have event information written.

        echo -e "\033[1;31m +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+  \033[0m"
        echo -e "\033[1;31m Event $sacnm has default header information    \033[0m"
        echo -e "\033[1;31m +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+  \033[0m"

        echo $sacnm >> ../../../TXT_Files/$filename.txt

    else

        echo
        echo -e "\033[1;34m ------------------------------------------------------------------------ \033[0m"
        echo -e "\033[1;34m    Event $sacnm has the correct header information...                 \033[0m"
        echo -e "\033[1;34m ------------------------------------------------------------------------ \033[0m"
        echo

    fi




done < saclst.txt

rm saclst.txt
