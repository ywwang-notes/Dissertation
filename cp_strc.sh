s_folder=$(ls | grep ^[0-9])
local=$(pwd)

# for s in $s_folder
for s in "$@"
do
        if [ ! -d $s ]; then
		echo $s' not a folder'
                continue
        fi

        cd $s
	pwd

	cp Strc2MNI/mean*.nii GLM/mean.nii
	cp Strc2MNI/t2*.nii GLM/t2.nii
	cp Strc2MNI/y_rt1*.nii GLM/y_rt1.nii

        cd ..
done
