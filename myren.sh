# usage: in the target folder, type: myren "old_sub_string" "new_sub_string"
# whitespace is OK

for f in *"$1"*; do
    newname=${f/$1/$2}
    mv -v $f $newname
done
