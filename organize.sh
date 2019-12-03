s_folder=$(ls | grep ^[0-9])

for folder in $s_folder
# for folder in "$@"

do
	if [ -d $folder ]; then

# for checking specific files
#               if [ -f $folder/t2*/y_* ]; then # if found
#                       echo $folder
#               fi
#
#                if [ ! -f $folder/GLM/SPM.mat ]; then # if not found
#                        echo $folder
#                fi

#		if [ -f $folder/ROI/rwSN_L* ]; then
#			mv $folder/ROI/rwSN_L* $folder/ROI/rwSN_L.nii
#			mv $folder/ROI/rwSN_R* $folder/ROI/rwSN_R.nii
#		fi

# for reporting subfolders
#		for item in $folder/*
#		do
#			if [ -d $item ]; then
#				echo $item
#			fi
#		done

# for removing a specified file or folder
#		rm -r $folder/GLM2
#		echo $folder

# for zipping files and clean up
#                zip $folder/GLM/rbeta_$folder $folder/GLM/rbeta*.nii
#		rm $folder/GLM/rbeta*.nii
		
# for creating subfolder 
#		cd $folder
#		mkdir ROI
#		pwd
#		cd ..

# for copy data from or to mini
# -----
#		mkdir $1/MVPA/$folder
#		cp -v $folder/G1STN/STN* $1/MVPA/$folder
# -----
		target=$(ls $1 | grep ^[0-9].*$folder)
# -----
#		if [ ! -z $target ]; then
#			files=$(ls $1/$target/GLM3/ | grep HC.*mat)
#			if [ ! -z "$files" ]; then
#				cp -v $1/$target/GLM3/HC*.mat $folder/GLM
#				cp -v $1/$target/GLM3/HC*.mat $folder/GLM3
#			fi
#		fi
# -----
#		subfolder="GLM1s10"
#		if [ ! -z "$target" ] && [ -d "$1/$target/$subfolder" ]; then
#		if [ ! -z "$target" ]; then
#			cp -av "$1/$target/$subfolder" $folder
#			mkdir "$1/$target/GLM3"
#			cp -v "$folder/ROI/mask_HC.nii" "$1/$target/"
#		fi
# -----
#		if [ -d "$folder/GLM1_STN" ]; then
#			mv $folder/GLM1_STN $folder/G1STN
#		fi

# for looking for empty folders
#		target=$(ls $folder | grep GLM2)
#		if [ -z "$target" ]; then
#			echo $folder
#		fi
#
#

# for rename
#		for oldname in $(ls $folder/GLM3 | grep _uf); do
#    			newname=${oldname/_uf/_suf}
#    			mv -v $folder/GLM3/$oldname $folder/GLM3/$newname
#			mv -v $folder/GLM/$oldname $folder/GLM/$newname
#		done

	fi # loop thru subject folders


done
