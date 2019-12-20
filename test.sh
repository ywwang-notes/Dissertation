while IFS=$'\r' read -r line
do
   var=($line)

   if [ "$line" != "" ]; then
#      ls wrcorr_0/wrcorr_p_${var[0]}_b[${var[1]}]*.nii
	   mv -iv wrcorr_0/wrcorr_p_${var[0]}_b[${var[1]}]*.nii exclude
   fi
   
done < "$1"