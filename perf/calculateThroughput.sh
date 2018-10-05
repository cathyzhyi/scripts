
dir=$1

for config in $dir/*/
do
   echo "config: $config"
   grep -r -m1 '^throughput of' $config | awk '{thr[NR-1]=$4; s+=$4; sq+=$4*$4}END{avg=s/NR; std=sqrt(sq/NR - (s/NR)**2); print "mean: ",avg; print "std: ",std,"  ",std/avg, "%"; print "raw throughput"; for (i in thr) print substr(thr[i], 1, length(thr[i])-1)}'
done
