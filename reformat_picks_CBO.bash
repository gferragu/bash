#!/bin/bash
################################################################################################################################
# February 5th
# Writing this script to reformat the picks that Tom Brocher provided for the 
# Cap Blanco 1994 experiment such that tlPicker can read them in.
################################################################################################################################

# Change dir as needed
#dir='/Volumes/research/users/gferragu/From_Tom/90s/Brocher_1994_Cape_Blanco_Survey/pick_reformat_test/'
dir='/Users/gabriel/Desktop/pick_reformat_test/' # For testing off Newberry, but on iMac still
save_dir='/Volumes/research/users/gferragu/CBO/picks/'
cd $dir

# Create list of directory contents
ls N?.txt | awk '{print}' > stnlst.txt
#Ensure newline at end of file
sed -i '' -e '$a\' stnlst.txt

### Picking Parameters Used ####
filt_low=$(echo 3)
filt_high=$(echo 12)
chan=$(echo 0)
pick_phase=$(echo 'P')
t_scale=$(echo 1000.0)
t_vred_used=$(echo 8.0)
################################

format="%6s%2i%8i%8s%10.4f%7.4f%5.1f%5.1f%2i%2i%10.2e%10s%17.5f%2i%38s%-80s\n" # From m-file save_tlPick
#format="%6s %2i %8i %8s %10.4f %7.4f %5.1f %5.1f %2i %2i %10.2e %10s %17.5f %2i %38s %-80s\n"

#Run through list, format naming/entries
while read stn
do
    echo "#####################################"
    echo "   Working on station file: $stn "
    echo $'#####################################\n'

    stnm=$(echo $stn | awk -F. '{print $1}')

    echo "#####################################"
    echo "   Station name: $stnm "
    echo $'#####################################\n'

    nname=$(echo "tlPick_$stnm"_"$pick_phase.dat")
    awk '{print}' > $nname

    echo "#####################################"
    echo "   New pick file: $nname "
    echo $'#####################################\n'

    awk '{print}' $stn > pick_lst.txt
    #sed 's/\r//' pick_lst.txt > pick_lst_unix.txt #Still getting a ^M error in the bc calculation, even with this.

    while read pick
    do

        station=$(echo $stn | awk -F. '{print $1}')
        channel=$(echo $chan)

        eventid_decimal=$(echo $pick | awk '{print $1}')
        eventid=$(echo ${eventid_decimal%.*})

        echo "###########################################"
        echo " Working on pick for trace: $eventid "
        echo $'###########################################\n'

        phase=$(echo $pick_phase)

        t_ms=$(echo $pick | awk '{print $3}')
        t_s=$(echo "scale=4; $t_ms / $t_scale" | tr -d '\r' | bc -l) #Maybe double check to ensure rounding is appropriate
        #echo "This is time in milliseconds $t_ms"
        #echo "This is time in seconds $t_s"
        time=$(echo $t_s)

        unc=$(echo 0.0220)

        filtLim0=$(echo $filt_low)
        filtLim1=$(echo $filt_high)
        filtOrder=$(echo 0)
        filtZeroPhase=$(echo 0)

        scale=$(echo 0.1)

        user=$(echo 'brocher')

        ddate=$(echo 1000000000.00000)

        use=$(echo 1)
        space=$(echo " ")
        comment=$(echo " ")

        printf "$format" \
        "$station" "$channel" "$eventid" "$phase" "$time" "$unc" \
        "$filtLim0" "$filtLim1" "$filtOrder" "$filtZeroPhase" \
        "$scale" "$user" "$ddate" "$use" "$space" "$comment" >> $nname

    done < pick_lst.txt

    cp $nname $save_dir

done < stnlst.txt



################################################################################################################################