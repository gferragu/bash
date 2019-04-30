#/bin/bash

dir1=/Users/Gabriel/Desktop/Google_Drive/GD_IRIS_2017_Gabriel_Ferragut/data_select/best_records/aleutian_azi/best_30km_events_improvedGraphics_secondPass 

dir2=/Users/Gabriel/Desktop/Google_Drive/GD_IRIS_2017_Gabriel_Ferragut/data_select/best_records/aleutian_azi/best_30km_events_secondPass

#dir3=/Users/Gabriel/Desktop/Google_Drive/GD_IRIS_2017_Gabriel_Ferragut/data_select/all_records/kamchatka_azi/for_record_section/RTZ_30km

dir3=/Users/Gabriel/Desktop/Google_Drive/GD_IRIS_2017_Gabriel_Ferragut/data_select/best_records/aleutian_azi/best_30km_events_firstPass

cd $dir1

ls  YKW* | awk -F_ '{print $1}' > saclst.txt


while read sacnm
do

cp $dir3/$sacnm* $dir2

done<saclst.txt




