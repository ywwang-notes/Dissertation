s_folder=$(ls | grep ^[0-9])
local=$(pwd)
s_list=""
n_list=()

for s in $s_folder
do
        if [ ! -d $s ]; then
		echo $s' not a folder'
                continue
        fi

        cd $s

	count=$(ls GLM | grep ^beta | wc -l)
	if [[ "$count" -eq $1 ]]; then
		s_list="$s_list $s"
	else
		n_list+=($count)
	fi	

        cd ..
done

echo $s_list
echo ${n_list[@]}
