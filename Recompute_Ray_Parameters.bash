#!/bin/bash

# External Drive
base="/Volumes/My_Passport/Canadian_UPDATE-work_from_home/Reformatted/snr_2/"

# This one doesn't exist
#data="cut_O=0/snr_2_all_NEZ/"
# 

#data="snr_2_all_NEZ-cutO=0/"
#data="snr_2_all_NEZ/"
data="snr_2_all_RTZ/"
#data="snr_2_all_NERTZ"

cd $base

cd $data

ls *.SAC > evnt_list.txt

while read sacnm
do

    echo "SAC file name: "

    # Do some calculations 

    gcarc=$(dumpSHD $sacnm gcarc | awk '{print $3}')
    echo "gcarc: $gcarc"

	evdp=$(dumpSHD $sacnm evdp | awk '{print $3}')
    echo "evdp: $evdp"

	angrayp=$(taup_time -h $evdp -deg $gcarc -ph P -rayp | sed -n "1p")
	horirayp=$(echo "scale=6;$angrayp * 180 / 6371 / 4 / a(1)" | bc -l)

    echo "Beginning SAC file edits ..."
    echo "r $sacnm" > tmp.in
    echo "ch user0 -12345 " >> tmp.in
	echo "ch user1 $horirayp user2 $angrayp" >> tmp.in

	echo "wh" >> tmp.in
	echo "q" >> tmp.in

	sac < tmp.in
	rm tmp.in

    echo
    echo "SAC file edits completed ..."
    echo

    echo "Angular ray parameter calculated and set as $angrayp"
    echo

    echo "Horizontal ray parameter calculated and set as $horirayp"
    echo


done < evnt_list.txt

rm evnt_list.txt