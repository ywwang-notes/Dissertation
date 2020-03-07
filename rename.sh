current=$(pwd)

for subject in "$@"
do
	cd $subject
	pwd

	mv mean*.nii mean_$subject.nii

	mv t1*/s*.json t1_$subject.json
	mv t1*/s*.nii t1_$subject.nii
	rmdir t1_m*

	mv t2*/s*.json t2_$subject.json
	mv t2*/s*.nii t2_$subject.nii
	rmdir t2w*

	cd ..
done

cd $current
