#!/bin/bash

dir1=/Users/Gabriel/Desktop/best_30km_events_graphics

dir2=/Users/Gabriel/Desktop/best_30km_events_test

dir3=/Users/Gabriel/Desktop/Google_Drive/GD_IRIS_2017_Gabriel_Ferragut/data_select/all_records/kamchatka_azi/for_record_section/RTZ_30km

cd $dir1

ls  YKW* | awk -F_ '{print $1}' > saclst.txt


while read sacnm
do

cp $dir3/$sacnm* $dir2

done<saclst.txt




