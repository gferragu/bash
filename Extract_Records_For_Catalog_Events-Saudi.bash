#!/bin/bash

# Use Saudi earthquake catalog as a simple text file to search 30 minute windowed records
# Then make directory for each event, copy records into that directory, and alter sac headers.


dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/TXT_Files/"
dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/"
dir3="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records/"
dir4="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/Event_Data/"

cd $dir3

# Create list of all current SAC records from Saudi Network

ls | awk '{print}' > saclst.txt  #Argument list too long error with pattern recognition

#find -type f -name '*.SAC' | awk '{print}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' saclst.txt

# Flag for possible event-record match found
flag=0

#Run through list, append station information to header

while read ctlg
do
    echo "--------------------------------------------------"
    echo " Searching records for $ctlg ...                  "
    echo "--------------------------------------------------"           

    # Getting catalogged event time
    evnt_search=$(echo $ctlg | awk -F. '{print $1.$2.$3}')

    evnt_min=$(echo $ctlg | awk -F. '{print $4}')

    evnt_sec=$(echo $ctlg | awk -F. '{print $5}')

    # Search the folder of records for similar time frames

    while read recnm
    do 
        rec_search=$(echo $recnm | awk -F. '{print $1.$2.$3}')

        rec_min=$(echo $recnm | awk -F. '{print $4}')

        rec_sec=$(echo $recnm | awk -F. '{print $5}')

        if [ "$evnt_search" == "$rec_search" ]
        then
            ####
            # Maybe Tau P to calculate theoretical arrival time and see if it falls in the window?
            # Need lat lon of both station and event, then depth as well I think?
            ####

            t_dif=$( echo "$evnt_min.$event_sec - $rec_min.$rec_sec" | bc )


            if [ "$t_dif" -lt "20.00" ]
            then

                # Copy records into associated event folder for processing

                tmp_dir=$(echo $ctlg | awk -F. '{print $1-$2-$3-$4-$5}')

                if [ ! -d $dir4$tmp_dir ]
                then
                    mkdir $dir4$tmp_dir
                fi

                cp $recnm $dir4$tmp_dir

                # Create file that will carry sac commands to write to the header
                echo "r $sacnm" > tmp.in

                EVLA=$(echo $ctlg | awk '{print $2}') ; echo "ch evdp $EVDP" >> tmp.in
                EVLO=$(echo $ctlg | awk '{print $3}') ; echo "ch evla $EVLA" >> tmp.in
                EVDP=$(echo $ctlg | awk '{print $4}') ; echo "ch evlo $EVLO" >> tmp.in
                MAG=$(echo $ctlg | awk '{print $6}') ; echo "ch mag $MAG" >> tmp.in

                NZYEAR=$(echo $ctlg | awk '{print $1}') ; echo "ch nzyear $NZYEAR" >> tmp.in
                NZJDAY=$(echo $ctlg | awk '{print $2}') ; echo "ch nzjday $NZJDAY" >> tmp.in
                NZHOUR=$(echo $ctlg | awk '{print $3}') ; echo "ch nzhour $NZHOUR" >> tmp.in
                NZMIN=$(echo $ctlg | awk '{print $4}') ; echo "ch nzmin $NZMIN" >> tmp.in
                NZSEC=$(echo $ctlg | awk '{print $5}') ; echo "ch nzsec $NZSEC" >> tmp.in

                ####
                # Also need to alter date in copied file to reflect earthquake origin time
                # Reset o marker as well? 
                # Set time window beginning at origin time (if possible) and make o marker zero, probably easiest.
                # Or just ignore it for now!
                ####

                echo "wh" >> tmp.in
                echo "q" >> tmp.in
                        
                sac < tmp.in
                rm tmp.in

                echo "--------------------------------------------------------------------------"
                echo " EVDP: $EVDP "
                echo " EVLA: $EVLA "
                echo " EVLO: $EVLO "
                echo " MAG : $MAG "
                echo " Variables written to header ..."
                echo "--------------------------------------------------------------------------"

            fi


        fi












    done < record_list.txt





done < All_Event_Info_clean_search.txt