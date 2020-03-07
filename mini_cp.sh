f_list=("" -1 -2 -3 -4 -5 -6 -7)
# f_list=("")

for i in "${f_list[@]}"
do
	target=/Volumes/gregashby$i/Documents/MATLAB/Experiments/Yiwen/SystemSwitch
	# ls $target

#  copy results from mini
#	cp -nv $target/corr*.nii SVM
#	cp -nv $target/s*.nii SVM/for_debug
#	mv -v $target/*.nii $target/SVM

# copy file to mini
#	cp -nv svm_job.m $target
done
