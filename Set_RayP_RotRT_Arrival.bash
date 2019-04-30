#!/bin/bash

# Set ray parameters for SAC files of a specific event
# Easiest to copy NEZ foldler and rename one as RTZ

dir=seismograms/all_records/kamchatka_azi/for_record_section/RTZ_100km

cd $dir

#Create list of directory conts

ls *.sac | awk '{print}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' saclst.txt

#Run through list, calculate and append ray parameter and depth in km to header
while read sacnm
do
	gcarc=$(dumpSHD $sacnm gcarc | awk '{print $3}')
	
	# Grab event depth
	evdp=$(dumpSHD $sacnm evdp | awk '{print $3}')

	# Check if depth in km (user4=1), if not, set it.
	k=$(dumpSHD $sacnm user4 | awk '{print $3/1}')
	echo "Flag for previous depth conversion is: $k"
	if [ $k -ne 1 ]; then
		evdp=$(echo "$evdp/1000.0"| bc)

		echo "r $sacnm" > tmp.in
		echo "ch evdp $evdp" >> tmp.in
		echo "ch user4 1" >> tmp.in
		echo "wh" >> tmp.in
                echo "q" >> tmp.in
		
		sac < tmp.in
		rm tmp.in
		echo "Depth converted to $evdp km, flag set to 1"
	fi

	angrayp=$(taup_time -h $evdp -deg $gcarc -ph S -rayp | sed -n "1p")
	horirayp=$(echo "scale=6;$angrayp * 180 / 6371 / 4 / a(1)" | bc -l)
	echo "Horizontal ray parameter calculated and set as $horirayp"

		echo "r $sacnm" >> tmp.in
		echo "ch user0 $horirayp user1 $angrayp" >> tmp.in
		echo "ch evdp $evdp" >> tmp.in 
		echo "wh" >> tmp.in
		echo "q" >> tmp.in

		sac < tmp.in
		rm tmp.in


	# For each sac file in the list, calculate theoretical S phase 
	# arrival time and assign it to header variable t8.
	taup_setsac -evdpkm -mod prem -ph S-8 $sacnm
	T8=$(dumpSHD $sacnm t8 | awk '{print $3}')
	echo "t8 has been set to $T8, the theoretical arrival time for the S-phase"

done<saclst.txt

rm saclst.txt


#Rotate N and E components to R and T components for a specific event, after ray parameters are set

mkdir ../RTZ

cp -r . ../RTZ

cd ..
cd RTZ

stnm=$(ls *BHZ* | awk -F. 'NR==1{print $1}')
echo $stnm

# First, make the list of all stations
ls *BHZ* | awk -F. '{print $1}' > stnlst.txt

# Make a list of all events
ls *BHZ* | awk -F. '{print $2}' > evtlst.txt

# Optionally, make a list of all events
ls *BHZ* | awk -F. '{print $1"."$2}' > lst.txt

#Do the rotation
while read evtnm
do
	echo "The station is $stnm"
	echo "The event is $evtnm"

	sacnm_e=${stnm}.${evtnm}.BHE.sac
	echo $sacnm_e

	sacnm_n=${stnm}.${evtnm}.BHN.sac
	echo $sacnm_n

	sacnm_r=${stnm}.${evtnm}.BHR.sac
	echo $sacnm_r	
	sacnm_t=${stnm}.${evtnm}.BHT.sac
	echo $sacnm_t
	
	echo "r $sacnm_e" > tmp.in 
	echo "ch cmpaz 90 cmpinc 90" >> tmp.in
	echo "wh" >> tmp.in
	echo "r $sacnm_n" >> tmp.in
	echo "ch cmpaz 0 cmpinc 90" >> tmp.in
	echo "wh" >> tmp.in
	echo "r $sacnm_e $sacnm_n" >> tmp.in
	echo "rotate" >> tmp.in
	echo "w $sacnm_r $sacnm_t" >> tmp.in
	echo "q" >> tmp.in
		
	sac < tmp.in
	rm tmp.in
done<evtlst.txt


