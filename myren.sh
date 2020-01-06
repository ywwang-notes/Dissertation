# usage: in the target folder, type: myren old_sub_string new_sub_string

for f in $(ls | grep $1); do
    newname=${f/$1/$2}
    mv -v $f $newname
done
