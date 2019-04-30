#Script to run through NEZ file and remove any events that lack all 3 components

st='YKW5_K_A_30km'
dir=seismograms/$st/NEZ/

cd $dir

#ls *.sac | awk '{print}' > saclst.txt

ls *BH* | awk -F. '{print $2}' > evtlst.txt

count=1
evtct=0

tmp1=""
tmp2=""
tmp3=""

while read evtnm
do
	echo ""
	echo "New Loop"
	echo ""

	if [ $count -eq 1 ]; then
		
		tmp1=$evtnm
		echo "-----------------------------------------------------------------"
		echo "Tmp1: $tmp1"
		echo "-----------------------------------------------------------------"


		evtct=1
	fi

	if [ $count -eq 2 ]; then
		
		tmp2=$evtnm
		echo "-----------------------------------------------------------------"
		echo "Tmp2: $tmp2"
		echo "-----------------------------------------------------------------"


		if [ $tmp2 != $tmp1 ]; then
			
			echo ""
			echo -e "\033[1;31m ----------------------------------------------------------------- \033[0m"
			echo -e "\033[1;31m This event tmp2 ($tmp2) does not match the previous event tmp1 ($tmp1) \033[0m"
			echo -e "\033[1;31m Event Count: $evtct \033[0m"
			echo -e "\033[1;31m Count: $count \033[0m"
			echo ""	

			echo ""
			echo -e "\033[1;31m Incomplete: $tmp1 ... Now removing incomplete event \033[0m"
			rm *"$tmp1"*
			echo -e "\033[1;31m ----------------------------------------------------------------- \033[0m"

			echo ""
			tmp1=$tmp2
			count=1;
			evtct=1;
			echo "-----------------------------------------------------------------"
			echo "Tmp1 set to: $tmp1"
			echo "Event Count: $evtct"
			echo "Count: $count"
			echo "-----------------------------------------------------------------"
			echo ""
			tmp2=""

		elif [ $tmp2 == $tmp1 ]; then
	
			evtct=$((evtct+1))
			echo ""
			echo "Evct incremented: $evtct"
			echo "Tmp1: $tmp1, Tmp2: $tmp2, Tmp3: $tmp3"
			echo ""		
		fi

	fi
				
	if [ $count -eq 3 ]; then
		
		tmp3=$evtnm;
		echo "-----------------------------------------------------------------"
		echo "Tmp3: $tmp3"
		echo "-----------------------------------------------------------------"

		if [ $tmp3 != $tmp2 ]; then
			
			echo ""
			echo -e "\033[1;31m ----------------------------------------------------------------- \033[0m"
			echo -e "\033[1;31m This event tmp2 ($tmp3) does not match the previous event tmp1 ($tmp2) \033[0m"
			echo -e "\033[1;31m Event Count: $evtct \033[0m"
			echo -e "\033[1;31m Count: $count \033[0m"
			echo ""	
	
			echo ""
			echo -e "\033[1;31m Incomplete: $tmp2 ... Now removing incomplete event \033[0m"
			rm *"$tmp2"*
			echo -e "\033[1;31m ----------------------------------------------------------------- \033[0m"

				
			
			echo ""
			tmp1=$tmp3
			count=1;
			evtct=1;
			echo "-----------------------------------------------------------------"
			echo "Tmp1 set to: $tmp1"
			echo "Event Count: $evtct"
			echo "Count: $count"
			echo "-----------------------------------------------------------------"
			echo ""
			tmp2=""

		elif [ $tmp3 == $tmp2 ]; then	
			
			evtct=$((evtct + 1)) 
			echo ""
			echo "-----------------------------------------------------------------"
			echo "Tmp1: $tmp1, Tmp2: $tmp2, Tmp3: $tmp3"
			echo "-----------------------------------------------------------------"
			echo ""	
		fi

		if [ $count != $evtct  ]; then

			echo "-----------------------------------------------------------------"
			echo "Count is not equal to event count"
			echo "Count: $count"
			echo "Event Count: $evtct"
			echo "-----------------------------------------------------------------"
			echo ""
				
		elif [ $count -eq 3 ] && [ $evtct -eq 3 ]; then

			echo ""
			echo "-----------------------------------------------------------------"
			echo "Event $tmp1  contains all 3 components, moving on..."
			echo "Event Count: $evtct"
			echo "Count: $count"
			echo ""
			tmp1=""
			tmp2=""
			tmp3=""
			count=0
			evtct=0

			echo "Tmp1: $tmp1"
			echo "Tmp2: $tmp2"
			echo "Tmp3: $tmp3"
			echo ""
			echo "Event Count: $evtct"
			echo "Count: $count"
			echo "-----------------------------------------------------------------"
			echo ""
			echo ""

		fi

		
	fi

	if [ $count -lt 4 ]; then

		count=$((count+1))
		echo "Count incremented by 1 for new loop: $count"
	
	fi
	
	echo "Count is $count"
	echo "Event count is: $evtct"
	echo "End of loop"
	echo ""
	
done<evtlst.txt

rm evtlst.txt
