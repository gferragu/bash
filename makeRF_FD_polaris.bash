#!/bin/bash

Dir=/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/snr_2/

b=-20
e=40
k=0.01
a=5 ## Gaussian width

Dir2=Output_test

cd $Dir/$Dir2


ls | awk '{print}' > stnlst.txt

while read stnm
do
    echo "Entering station directory"
    echo
    
	cd $Dir/$Dir2/$stnm
	
    ls *SAC | awk -F. '{print $2}' > evntlst.txt

	while read evtnm
	do	
        echo "Calculating receiver functions..."
        echo

		#sacnmZ=$stnm.$evtnm.z
		#sacnmR=$stnm.$evtnm.r
		#sacnmT=$stnm.$evtnm.t
		#sacnmRZ=$stnm.$evtnm.eqr
		#sacnmTZ=$stnm.$evtnm.eqt

        sacnmZ=$stnm.$evtnm.BHZ.SAC
		sacnmR=$stnm.$evtnm.BHR.SAC
		sacnmT=$stnm.$evtnm.BHT.SAC
		sacnmRZ=$stnm.$evtnm.eqr.SAC
		sacnmTZ=$stnm.$evtnm.eqt.SAC

		echo $sacnmZ
		echo $sacnmR
		echo $sacnmRZ
		echo $sacnmTZ
        echo

		#FDdeconv -S $sacnmZ -F $sacnmR -f $b -t $e -k $k -s 0 -G -a $a -o $sacnmRZ
		#FDdeconv -S $sacnmZ -F $sacnmT -f $b -t $e -k $k -s 0 -G -a $a -o $sacnmTZ
        echo "FDdeconv being applied ... "
        
        FDdeconv -S $sacnmZ -F $sacnmR -f $b -t $e -k $k -s 0 -G -a $a -o $sacnmRZ
		FDdeconv -S $sacnmZ -F $sacnmT -f $b -t $e -k $k -s 0 -G -a $a -o $sacnmTZ

	done < evntlst.txt

    cd ..

done < stnlst.txt



echo "## Water-level deconvolution ##" > $Dir/$Dir2/decon.para	
echo "b $b" >> $Dir/$Dir2/decon.para
echo "e $e" >> $Dir/$Dir2/decon.para
echo "k $k" >> $Dir/$Dir2/decon.para
echo "a $a" >> $Dir/$Dir2/decon.para

