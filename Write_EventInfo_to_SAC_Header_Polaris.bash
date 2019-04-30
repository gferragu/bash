#!/bin/bash

# May 18th
# I'm writing this script to run through the renamed Polaris data and pull catalog info from a file called 
# 'All_Events-SAC-Clean.txt' that is in the TXT folder a directory above this data folders in the Canadian_Data
# folder
#
# Alter paths as necessary

DSMN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/DSMN/'

EDZN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/EDZN/'

GALN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/GALN/'

ILKN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/ILKN/'

ROMN_Reformat='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/ROMN/'

all='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/All_Stations/'


#test='/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/test_Reformat/'

#Run through list, append event information to header

i=1

if [ $i -eq 1 ]
then 
    cd $all 
fi

if [ $i -eq 2 ]
then
    cd $DSMN_Reformat 
fi

if [ $i -eq 3 ]
then
    cd $EDZN_Reformat
fi

if [ $i -eq 4 ]
then
    cd $GALN_Reformat
fi

if [ $i -eq 5 ]
then
    cd $ILKN_Reformat
fi

if [ $i -eq 6 ]
then
    cd $ROMN_Reformat
fi

# Create list of directory contents

ls | awk '{print}' > saclst.txt  #Argument list too long error with pattern recognition

#find -type f -name '*.SAC' | awk '{print}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' saclst.txt


num_files=$(ls -1 | wc -l)

count=0

#echo "----------------------------------------------------------------"
#echo " Looping through directories, currently on $i "
#echo "----------------------------------------------------------------"
        

while read sacnm
do
    count=$((count + 1))

    echo "--------------------------------------------------------------------"
    echo " Working on file $sacnm ...    $count / $num_files"
    echo "--------------------------------------------------------------------"
        
    # search=$(echo $sacnm | awk -F. '{print $1"."$2}')

    # echo
    # echo $search
    # echo

    # stn=$(echo $sacnm | awk -F. '{print $1}')

    # echo
    # echo "Station is: $stn"
    # echo

    # date_time=$(echo $sacnm | awk -F. '{print $2}')

    # echo
    # echo $date_time
    # echo
        
    # yr=$(echo $date_time | awk -F- '{print $1}')

    # echo
    # echo $yr
    # echo

    # jDay=$(echo $date_time | awk -F- '{print $2}')

    # echo
    # echo $jDay
    # echo

    # hr=$(echo $date_time | awk -F- '{print $3}')

    # echo
    # echo $hr
    # echo

    # min=$(echo $date_time | awk -F- '{print $4}')

    # echo
    # echo $min
    # echo

    # sec=$(echo $date_time | awk -F- '{print $5}')

    # echo
    # echo $sec
    # echo

    # comp=$(echo $date_time | awk -F- '{print $10}')
        
    # echo
    # echo $comp
    # echo

    
    # Change SAC header variables based on catalog search
        
    # evnt_info=$(grep "$search" ../../../TXT_Files/All_Events-SAC-Clean.txt)

    # EVLA=$(echo $evnt_info | awk '{print $2}')
    # EVLO=$(echo $evnt_info | awk '{print $3}')
    # EVDP=$(echo $evnt_info | awk '{print $4}')
    # MAG=$(echo $evnt_info | awk '{print $5}')

    # echo "r $sacnm" > tmp.in
    # echo "ch evdp $EVDP" >> tmp.in
    # echo "ch evla $EVLA" >> tmp.in
    # echo "ch evlo $EVLO" >> tmp.in
    # echo "ch mag $MAG" >> tmp.in



    # echo "wh" >> tmp.in
    # echo "q" >> tmp.in
            
    # sac < tmp.in
    # rm tmp.in

    # echo "--------------------------------------------------------------------------"
    # echo " EVDP: $EVDP "
    # echo " EVLA: $EVLA "
    # echo " EVLO: $EVLO "
    # echo " MAG : $MAG "
    # echo " Variables written to header ..."
    # echo "--------------------------------------------------------------------------"

   
    # echo
    # echo "=========================================================================="
    # echo

    ########################################################################################################################
    # Apply other operations to data, modify as necessary
    # June 1st, adding functionality to remove meand and trend from data as well as apply bandpass filter
    ########################################################################################################################

    # Do some filtering

    echo "r *$sacnm*" > tmp.in
    echo "rmean" >> tmp.in
    echo "rtrend" >> tmp.in
    echo "bp c 0.02 1" >> tmp.in
    echo "ch O 0" >> tmp.in
    echo "ch IZTYPE IO" >>tmp.in

    echo "wh" >> tmp.in
    echo "q" >> tmp.in
            
    sac < tmp.in
    rm tmp.in

    ########################################################################################################################

    # Do some calculations 

    gcarc=$(dumpSHD $sacnm gcarc | awk '{print $3}')
	evdp=$(dumpSHD $sacnm evdp | awk '{print $3}')

    ## MAKE SURE TO CHOOSE CORRECT PHASE ##

	angrayp=$(taup_time -h $evdp -deg $gcarc -ph P -rayp | sed -n "1p")
	horirayp=$(echo "scale=6;$angrayp * 180 / 6371 / 4 / a(1)" | bc -l)

    # For each sac file in the list, calculate theoretical P and S phase 
	# arrival time and assign it to header variable A/T0, and T1.
	taup_setsac -evdpkm -mod prem -ph P-0 $sacnm
    taup_setsac -evdpkm -mod prem -ph S-1 $sacnm

	T0=$(dumpSHD $sacnm t0 | awk '{print $3}')
    T1=$(dumpSHD $sacnm t1 | awk '{print $3}')

	echo "r $sacnm" >> tmp.in
	echo "ch user0 $horirayp user1 $angrayp" >> tmp.in
    echo "ch A $T0" >> tmp.in
    echo "ch KA P" >> tmp.in
    echo "ch t0 -12345" >> tmp.in

	echo "wh" >> tmp.in
	echo "q" >> tmp.in

	sac < tmp.in
	rm tmp.in

    echo "Horizontal ray parameter calculated and set as $horirayp"
    echo

	echo "P arrival is $T0, the theoretical arrival time for the P-phase"
    echo
    echo "S arrival is $T1, the theoretical arrival time for the S-phase"

    ########################################################################################################################

done < saclst.txt

rm saclst.txt
