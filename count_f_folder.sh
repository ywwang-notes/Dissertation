current=$(pwd)

cd ~/Documents/GoogleDrive/SystemSwitch/UP2Smoothed/
subject=$1

cd $subject
echo $subject

for folder in cmrr*
do 
	if [ ! -d $folder ]; then
		continue
	fi

	cd $folder

	# do not write: echo *.nii
	# instead, write: echo "*.nii"
	# lack of quote marks will force ls output to std

	# no space before and after `=' !!!
	f=$(ls| grep ^f.*nii |wc -l)
	uf=$(ls| grep ^uf.*nii |wc -l)
	suf=$(ls| grep ^suf.*nii |wc -l)

	if [ $f != $uf ] || [ $f != $suf ];
	then
		echo $folder
		echo -e "\t f.nii \t $f"
		echo -e "\t uf.nii \t $uf"
		echo -e "\t suf.nii \t $suf"
	else 
		echo -e "$folder complete $uf"
	fi

	cd ..
done


cd $current
