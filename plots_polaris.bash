#!/bin/bash

# Generic script to run through plots
# June 5th, modifying to plot select Polaris data

#cd sac/

dir1="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/"
dir2="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/snr_2/cut_O=0/"


#src=snr_2_all_NEZ/
#src=snr_2_all_RTZ/
src=snr_2_all_NERTZ/
#src=All_select/
#src=snr_2_select/

#tar=snr_2_all_NEZ_figs/
#tar=snr_2_all_RTZ_figs/
tar=snr_2_all_NERTZ_figs/
#tar=All_select_figs/
#tar=snr_2_select_figs/

cd $dir2$src

tmp_dir=$(pwd)

echo "In directory: $tmp_dir ... "
 
ls *BHZ* | awk '{print}' > sac_lst.txt


while read sacnm
do

    key=$(echo $sacnm | awk -F. '{print $1"."$2}')

	echo "r $key*" > tmp.in
	echo "p1" >> tmp.in
	echo "saveimg $dir2$tar/$sacnm.pdf" >> tmp.in
	echo "q" >> tmp.in

	sac < tmp.in
	rm tmp.in
	
done < sac_lst.txt

rm sac_lst.txt


cd ..
