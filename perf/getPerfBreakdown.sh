#!/bin/bash
set -e
# Given a perf.data or its location, generate a breakdown file
# using perf-hottest and perf

error_exit() {
   echo "Error: $1"
   exit 1
}

work_dir=$1
if [[ -f $work_dir ]]; then
   work_dir=$(dirname "${work_dir}")
fi

result_file="breakdown.txt"

if [ $# -eq 2 ]; then
   pid=$2
   result_file="breakdown-${pid}.txt"
   extra_perf_option="--pid $pid"
fi

this_file_name=`basename "$0"`
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # Directory of this file
usage="$this_file_name <location of perf.data or /path/to/perf.data>"
orig_dir=$PWD
perf_hottest="$script_dir/perf-hottest"


cd $work_dir

#if [ ! -f "extract.sh" ]; then
#   error_exit "Expect extract.sh in $work_dir"
#fi
#./extract.sh

cp -f perf-*.map /tmp/

perf script -G -F comm,tid,ip,sym,dso $extra_perf_option | $perf_hottest sym > hottest-sym
perf script -G -F comm,tid,ip,sym,dso $extra_perf_option | $perf_hottest so > hottest-so

tail -n+2 hottest-so | grep -o -E '[^ ]+$' > solist.txt
head -n 1 hottest-sym > $result_file
printf "\n" >> $result_file
echo "Module break down:" >> $result_file
tail -n+2 hottest-so >> $result_file
while IFS= read -r line; do
  printf "\n" >> $result_file
  echo "Symbol break down:" >> $result_file
  grep -F "$line" hottest-so >> $result_file
  grep -F "$line" hottest-sym | sed -r 's/\s+\S+$//' >> $result_file
done < "solist.txt"

rm -f solist.txt hottest-sym hottest-so

cd $orig_dir
