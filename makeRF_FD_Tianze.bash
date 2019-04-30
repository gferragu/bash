Dir=/Users/tianze/Research/WorkingDirectory/NC4_RF

b=-20
e=40
k=0.01
a=5 ## Gaussian width

cd $Dir/Output

while read evtnm
do
	cd $Dir/Output/$evtnm
	
	while read stnm
	do	
		sacnmZ=$stnm.$evtnm.z
		sacnmR=$stnm.$evtnm.r
		sacnmT=$stnm.$evtnm.t
		sacnmRZ=$stnm.$evtnm.eqr
		sacnmTZ=$stnm.$evtnm.eqt

		#echo $sacnmZ
		#echo $sacnmR
		#echo $sacnmT
		#echo $sacnmRZ
		#echo $sacnmTZ	
		FDdeconv -S $sacnmZ -F $sacnmR -f $b -t $e -k $k -s 0 -G -a $a -o $sacnmRZ
		FDdeconv -S $sacnmZ -F $sacnmT -f $b -t $e -k $k -s 0 -G -a $a -o $sacnmTZ
	done<stn.lst
done<evt.lst

echo "## Water-level deconvolution ##" > $Dir/Output/decon.para	
echo "b $b" >> $Dir/Output/decon.para
echo "e $e" >> $Dir/Output/decon.para
echo "k $k" >> $Dir/Output/decon.para
echo "a $a" >> $Dir/Output/decon.para

