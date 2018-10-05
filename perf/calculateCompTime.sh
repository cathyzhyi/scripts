dir=$1


for file in $(find $dir -name 'output.txt' 2> /dev/null);
do
   echo $file
   fileDir=$(dirname "${file}")
   echo $fileDir
   grep 'Time spent in compilation thread =' $file | cut -d'=' -f2 | awk '{ SUM += $1} END { print SUM }' > $fileDir/compTime.txt
done

for config in $dir/*/
do
   echo "config: $config"
   #grep -r 'Time spent in compilation thread =' $config | cut -d'=' -f2 | awk '{ SUM += $1} END { print SUM }' > $fileDir/compTime.txt
   cat $config*/compTime.txt | awk '{thr[NR-1]=$1; s+=$1; sq+=$1*$1}END{avg=s/NR; std=sqrt(sq/NR - (s/NR)**2); print "mean: ",avg; print "std: ",std,"  ",std/avg*100, "%"; print "raw compile time"; for (i in thr) print substr(thr[i], 1, length(thr[i])-1)}'
done
