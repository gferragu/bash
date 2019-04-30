#!/bin/bash

# Updated for the data being backed up to an external drive
dir1="/Volumes/My_Passport/Google_Drive_Backup/USGS_Work/Saudi_Data/Events/event_data/800s_post_arrival-0.5-10HzFilter-2010-2016_shift"

#dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/event_data/800s_post_arrival-0.5-10HzFilter-2010-2016_shift"
#dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/event_data/800s_post_arrival-0.5-10HzFilter-2010-2016_shift_snrTest"

cd $dir1

win=20
tol=10

#Create list of directory contents (event folders)

ls -d */ | awk '{print}' > evntlst.txt

num=$(ls -d */ | wc -l)

ecount=0
ficount=0

while read evntnm
do

    cd $evntnm

	evntnm=$(echo $evntnm | awk -F/ '{print $1}' )
	echo
	echo "evntnm is :  $evntnm"
	echo

    #ls *SAC > sac_list.txt

    finum=$(ls *SAC | wc -l)

    ls *Z.D.SAC* > sac_list.txt

	#Check if directories and files exist and act appropriately
	if [[ ! -d "../../snr_$tol" ]]
	then
		mkdir ../../snr_$tol
		mkdir ../../snr_$tol/TXT_Files
	fi

    if [[ -e ../../snr_$tol/TXT_Files/sac_select_$tol_$evntnm.txt ]]
	then
		rm ../../snr_$tol/TXT_Files/sac_select_$tol_$evntnm.txt
	fi

	if [[ -e ../../snr_$tol/TXT_Files/evt_select_$tol_$evntnm.txt ]]
	then
		rm ../../snr_$tol/TXT_Files/evt_select_$tol_$evntnm.txt
	fi

    echo > ../../snr_$tol/TXT_Files/sac_select_$tol_$evntnm.txt
    echo > ../../snr_$tol/TXT_Files/evt_select_$tol_$evntnm.txt


    while read sacnm
	do	
		#Build SAC names based off conventions
		
		base=$(echo $sacnm | awk -F. '{print $1"."$2"."$3"."$4"."$5"."$6"."$7"."$8}')
		comp=$(echo $sacnm | awk -F. '{print $9}')
		comp12=$(echo $comp | awk '{ print substr($0,0,2)}' )

		echo
		echo "base: $base"
		echo
		echo "comp: $comp"
		echo 
		echo "comp12: $comp12"
		echo

		#Allows for variable components and bands
		sacnmZ="$base.$comp12 Z.D.SAC"
		sacnmZ=$(echo $sacnmZ | tr -d ' ')
		

		sacnmN="$base.$comp12 N.D.SAC"
		sacnmN=$(echo $sacnmN | tr -d ' ')
		

		sacnmE="$base.$comp12 E.D.SAC"
		sacnmE=$(echo $sacnmE | tr -d ' ')
		

		bZ=$(dumpSHD $sacnmZ b | awk '{print $3}')
		bN=$(dumpSHD $sacnmN b | awk '{print $3}')
		bE=$(dumpSHD $sacnmE b | awk '{print $3}')
	
		eZ=$(dumpSHD $sacnmZ e | awk '{print $3}')
		eN=$(dumpSHD $sacnmN e | awk '{print $3}')
		eE=$(dumpSHD $sacnmE e | awk '{print $3}')
		


		if [[ $(echo "$bZ<-20 && $bN<-20 && $bE<-20" | bc) -gt 0 ]]
		then

			if [[ $(echo "$eZ>20 && $eN>20 && $eE>20" | bc) -gt 0 ]]
			then
                
                echo
                echo "sacnm for Z is: $sacnmZ"
                echo
                echo "sacnm for N is: $sacnmN"
                echo
                echo "sacnm for E is: $sacnmE"
                echo


				snrZ=$(snrSAC -s $sacnmZ -T 0/$win -N -$win/0 | awk '{print $10}')
				snrN=$(snrSAC -s $sacnmN -T 0/$win -N -$win/0 | awk '{print $10}')
				snrE=$(snrSAC -s $sacnmE -T 0/$win -N -$win/0 | awk '{print $10}')
				
				echo "$snrN $snrE $snrZ" >> /Volumes/My_Passport/Google_Drive_Backup/USGS_Work/Saudi_Data/Events/event_data/all_event_3comp_snr.txt

				# Dec 2018, modifying to ouput SNR values on each component to a text file for plotting


				# if [[ $(echo "$snrZ>$tol && $snrN>$tol && $snrE>$tol" | bc) -gt 0 ]]
				# then
				# 	echo $sacnmZ >> ../../snr_$tol/TXT_Files/sac_select_$tol_$evntnm.txt	
				# 	echo $sacnmN >> ../../snr_$tol/TXT_Files/sac_select_$tol_$evntnm.txt	
				# 	echo $sacnmE >> ../../snr_$tol/TXT_Files/sac_select_$tol_$evntnm.txt
				# 	echo $evtnm >> ../../snr_$tol/TXT_Files/evt_select_$tol_$evntnm.txt

				# 	if [[ ! -d "../../snr_$tol/$evntnm" ]]
				# 	then
				# 		mkdir ../../snr_$tol/$evntnm
				# 	fi

				# 	cp ../../800s_post_arrival-0.5-10HzFilter-2010-2016/$evntnm/$sacnmZ ../../snr_$tol/$evntnm/
				# 	cp ../../800s_post_arrival-0.5-10HzFilter-2010-2016/$evntnm/$sacnmN ../../snr_$tol/$evntnm/
				# 	cp ../../800s_post_arrival-0.5-10HzFilter-2010-2016/$evntnm/$sacnmE ../../snr_$tol/$evntnm/

				# fi
			fi
		fi
	done < sac_list.txt

    rm sac_list.txt
    rm z_list.txt

	cd ..

done < evntlst.txt