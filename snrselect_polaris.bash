0#!/bin/bash

dir1="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/"

cd $dir1

win=20
tol=2

while read stnm
do
    
    cd $dir1/$stnm/
    echo
    echo $stnm
    echo

    stnm=$(echo $stnm | awk -F_ '{print $1}')

    ls *BHZ* > z_list.txt

    awk -F. '{print $2}' z_list.txt > evnt_list.txt

    if [[ -e sac_select_$tol_$stnm.txt ]]
	then
		rm sac_select_$tol_$stnm.txt
	fi

	if [[ -e evt_select_$tol_$stnm.txt ]]
	then
		rm evt_select_$tol_$stnm.txt
	fi

    echo > sac_select_$tol_$stnm.txt
    echo > evt_select_$tol_$stnm.txt


    while read evtnm
	do	
		sacnmZ=$stnm.$evtnm.BHZ.SAC
		sacnmN=$stnm.$evtnm.BHN.SAC
		sacnmE=$stnm.$evtnm.BHE.SAC
			
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
				

				if [[ $(echo "$snrZ>$tol && $snrN>$tol && $snrE>$tol" | bc) -gt 0 ]]
				then
					echo $sacnmZ >> sac_select_$tol_$stnm.txt	
					echo $sacnmN >> sac_select_$tol_$stnm.txt	
					echo $sacnmE >> sac_select_$tol_$stnm.txt
					echo $evtnm >> evt_select_$tol_$stnm.txt	
				fi
			fi
		fi
	done < evnt_list.txt

    rm evnt_list.txt
    rm z_list.txt


done < /Users/temp/Google_Drive/USGS_Work/Canadian_Data/TXT_Files/stn_list.txt