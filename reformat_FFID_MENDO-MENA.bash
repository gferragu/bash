#!/bin/bash
################################################################################################################################
# March 4th
# Anne provided millisecond accurate shot times for ~18 or 19 shot lines as separate files
# I'm writing this to parse the information out of them, and assign the MENA specifci FFID scheme
# to them based on the line. Hopefully this will then match the data and tlPicker will be able to read everything in.
################################################################################################################################

# Change dir as needed
sv_path='/Volumes/research/users/gferragu/MTJ/TXT'
src_path='/Volumes/research/users/gferragu/MTJ/TXT/ewing.nav/'

cd $src_path
echo $'\n##########################################################################'
echo "                           Current directory"
pwd
echo $'##########################################################################\n'


# Create list of directory contents (the shot lines)
#ls *.dat | awk '{print}' > shot_line_lst.txt
ls *.txt| awk '{print}' > shot_line_lst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' shot_line_lst.txt

echo "FFID time lon lat line" | awk '{print}' > $sv_path/reformatted_shot_times/all_lines.txt

#Run through list, format naming/entries
while read shot
do
    echo "#####################################"
    echo "  Working on shot line file: $shot   "
    echo $'#####################################\n'

    shotnm=$(echo $shot | awk -F. '{print $1}')

    echo "#####################################"
    echo "       Line name: $shotnm      "
    echo $'#####################################\n'

    awk '{print $1}' $shot > t_yr.tmp

    awk -F'[+-]' '{print $2}' t_yr.tmp > t_jday_hr_min_sec_ms.tmp

    awk '{print $2}' $shot > FFID_orig.tmp

    echo "Beep boop, I'm about to get the lon lat minutes and seconds "

    awk '{printf("%.5f\n",(-1)*( $7 + ($8 / 60)))}' $shot > lon.tmp
    awk '{printf("%.5f\n",( $4 + ($5 / 60)))}' $shot > lat.tmp

    awk '{print $9}' $shot > linenm.tmp

    
    if [ "$shotnm" == "mcs-1b" ]
    then
        awk '{print $1 + 10000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-1c" ]
    then
        awk '{print $1 + 20000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "wa-1" ]
    then
        awk '{print $1 + 30000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-11" ]
    then
        awk '{print $1 + 40000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-10a" ]
    then
        awk '{print $1 + 50000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-2" ]
    then
        awk '{print $1 + 60000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-10" ]
    then
        awk '{print $1 + 70000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-7" ]
    then
        awk '{print $1 + 80000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-7a" ]
    then
        awk '{print $1 + 90000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "er-bna" ]
    then
        awk '{print $1 + 100000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-12" ]
    then
        awk '{print $1 + 110000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-3" ]
    then
        awk '{print $1 + 120000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-4" ]
    then
        awk '{print $1 + 130000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-5" ]
    then
        awk '{print $1 + 140000}' FFID_orig.tmp > FFID_new.tmp
    fi
    if [ "$shotnm" == "mcs-8" ]
    then
        awk '{print $1 + 150000}' FFID_orig.tmp > FFID_new.tmp
    fi
    if [ "$shotnm" == "er-ana" ]
    then
        awk '{print $1 + 160000}' FFID_orig.tmp > FFID_new.tmp
    fi
    if [ "$shotnm" == "wa-6a" ]
    then
        awk '{print $1 + 170000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "mcs-6a" ]
    then
        awk '{print $1 + 180000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "er-as" ]
    then
        awk '{print $1 + 190000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "rand-1" ]
    then
        awk '{print $1 + 200000}' FFID_orig.tmp > FFID_new.tmp
    fi

    if [ "$shotnm" == "er-bs" ]
    then
        awk '{print $1 + 210000}' FFID_orig.tmp > FFID_new.tmp
    fi


    if [ "$shotnm" == "mcs-7b" ]
    then
        awk '{print $1 + 220000}' FFID_orig.tmp > FFID_new.tmp
    fi


    if [ "$shotnm" == "mcs-13" ]
    then
        awk '{print $1 + 230000}' FFID_orig.tmp > FFID_new.tmp
    fi


    if [ "$shotnm" == "mcs-14" ]
    then
        awk '{print $1 + 240000}' FFID_orig.tmp > FFID_new.tmp
    fi

    echo "FFID time lon lat line" | awk '{print}' > $sv_path/reformatted_shot_times/$shotnm.txt

    paste -d " " FFID_new.tmp t_jday_hr_min_sec_ms.tmp lon.tmp lat.tmp linenm.tmp >> $sv_path/reformatted_shot_times/$shotnm.txt
    paste -d " " FFID_new.tmp t_jday_hr_min_sec_ms.tmp lon.tmp lat.tmp linenm.tmp >> $sv_path/reformatted_shot_times/all_lines.txt
    rm *.tmp

done < shot_line_lst.txt

rm shot_line_lst.txt

################################################################################################################################