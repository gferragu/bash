#!/bin/bash

# Makes a list of events with information relevant to GMT plotting
# July 28th: Working and open to further adaption for different variables 
# September 7th: Copied to new Aleutian dataset folder and modified 

rm evntInfo.txt

dir=/Users/Gabriel/Desktop/Google_Drive/GD_IRIS_2017_Gabriel_Ferragut/data_select/best_records/aleutian_azi/best_30km_events_secondPass

cd $dir

echo Station / Event Time#.#Epi Dist#.#Back Azimuth#.#Depth#.#ArrT#.#Ray Parameter#.#Lon#.#Lat#.#Virtual Source Distance# | awk -F. '{print $1,$2,$3,$4,$5,$6,$7,$8,$9}' > evntInfo.txt


#Create list of directory conts

ls *BHZ* | awk '{print}' > evntlst.txt

ls *BHZ* | awk -F. '{print $1 "." $2}' > evntInfoTmp.txt

#Ensure newline at end of file
sed -i '' -e '$a\' evntlst.txt

#Run through list, calculate and append ray parameter and depth in km to header
while read evntnm
do
	# Grab azimuthal distance
	dumpSHD $evntnm gcarc | awk '{print $3}' >> gcarcTmp.txt

	# Grab back azimuth
	dumpSHD $evntnm baz | awk '{print $3}' >> bazTmp.txt
	
	# Grab event depth
	dumpSHD $evntnm evdp | awk '{print $3}' >> evdpTmp.txt

	# Grab the S phase arrival time	
	dumpSHD $evntnm t8 | awk '{print $3}' >> t8Tmp.txt 

	# Grab the ray parameter
	dumpSHD $evntnm user0 | awk '{print $3}' >> user0Tmp.txt 

	# Calculate the distance to virtual source
	
		# Vp from active source paper (km/s)
			Vp=6.5
			
		# Avg crustal thickness (km) from active source paper
			y=36.5

		# Ray parameter
			p=$(dumpSHD $evntnm user0 | awk '{print $3}') 
				
		# Calculate reflection angle
	
			p_x_Vp=$(echo "$p*$Vp" | bc -l)

			i=$(echo "a($p_x_Vp/sqrt(1-($p_x_Vp)^2))" | bc -l)	
			echo "Angle of reflection (radians): $i "
 
		# Calculate the straightline distance
			
			tan_i=$(echo "s($i)/c($i)" | bc -l)
			
			echo "Tan value is: $tan_i"
				
			virtSource=$(echo "36.5*2*($tan_i) " | bc -l)
			
			echo "Distance to virtual source is: $virtSource"
			
			echo $virtSource | awk '{print}' >> virtSourceTmp.txt

	# Grab the lon and lat of event
	#stlo=$(dumpSHD $evntnm evlo | awk '{print $3}')
	dumpSHD $evntnm evlo | awk '{print $3}' >> evloTmp.txt

	#stla=$(dumpSHD $evntnm evla | awk '{print $3}')
	dumpSHD $evntnm evla | awk '{print $3}' >> evlaTmp.txt

	
done<evntlst.txt


	paste -d " " evntInfoTmp.txt gcarcTmp.txt bazTmp.txt evdpTmp.txt t8Tmp.txt user0Tmp.txt evloTmp.txt evlaTmp.txt virtSourceTmp.txt >> evntInfo.txt

	mv evntInfo.txt ../../../../evntInfo.txt
	
	rm *Tmp*
	rm evntlst.txt

