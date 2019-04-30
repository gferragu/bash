#!/bin/bash

# Set ray parameters for SAC files of a specific event
# Easiest to copy NEZ foldler and rename one as RTZ

#dir=/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/snr_2/snr_2_all_NEZ
dir=/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/snr_2/Output_test/DSMN/
cd $dir

#Create list of directory conts

ls *SAC | awk '{print}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' saclst.txt

#Rotate N and E components to R and T components for a specific event, after ray parameters are set

#mkdir ../snr_2_all_RTZ

#cp -r . ../snr_2_all_RTZ

#cd ..
#cd snr_2_all_RTZ/

mkdir ../snr_2_test_RTZ

cp -r . ../snr_2_test_RTZ

cd ..
cd snr_2_test_RTZ/

#cd ..
#cd snr_2_all_RTZ/

stnm=$(ls *BHZ* | awk -F. 'NR==1{print $1}')
echo $stnm

# First, make the list of all stations
ls *BHZ* | awk -F. '{print $1}' > stnlst.txt

# Make a list of all events
ls *BHZ* | awk -F. '{print $2}' > evtlst.txt

# Optionally, make a list of all events
ls *BHZ* | awk -F. '{print $1"."$2}' > lst.txt

#Do the rotation
while read stn_evtnm
do

	stnm=$(echo $stn_evtnm | awk -F. '{print $1}')
	evtnm=$(echo $stn_evtnm | awk -F. '{print $2}')
	
	echo
	echo "The station is $stnm"
	echo "The event is $evtnm"
	echo

	sacnm_e=${stnm}.${evtnm}.BHE.SAC
	echo $sacnm_e

	sacnm_n=${stnm}.${evtnm}.BHN.SAC
	echo $sacnm_n

	sacnm_r=${stnm}.${evtnm}.BHR.SAC
	echo $sacnm_r	
	sacnm_t=${stnm}.${evtnm}.BHT.SAC
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
done < lst.txt


