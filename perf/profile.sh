#!/bin/bash
#set -x

profileType=$1
profilePath=$2
START=$3
DURATION=$4
PERF_MAP_DIR=$5


pid=`pgrep java`
PERF_RECORD_FREQ=999
PERF_DATA_FILE="/tmp/perf-$pid.data"

#. setrunenv;

if [ ! -d "$profilePath" ]; then
   mkdir -p "$profilePath"
fi

cd "$profilePath"

case "$profileType" in
   "tprof")
   /opt/Dpiperf/bin/run.tprof -s $START -r $DURATION; 
   ;;
   "tprof-l3r-miss")
   /opt/Dpiperf/bin/run.tprof -m event -e L3_READ_MISS -c 4000 -s $START -r $DURATION; 
   ;;
   "jlm")
   rtdriver -a 127.0.0.1 -c jlmstart $START -c jlmdump 0 -c jlmstop $DURATION
   ;;
   "scs")
   rtdriver -a 127.0.0.1 -c start $START -c end $DURATION
   ;;
   "cpi")
   echo "******Wait for $START s to start perf stat**********"
   sleep $START
   echo "******Start perf stat*********"
   perf stat -a -e cycles,instructions,cache-misses,cpu-clock,task-clock,cache-references,branch-misses,branches,context-switches -o stat.out -x, sleep $DURATION 
   #perf stat -einstructions,cache-misses,cycles,task-clock,cache-references,branch-misses,branches -e r0280 -C 0,1,2,3 -p $pid -o stat.out -- sleep $DURATION 
   #perf stat -e instructions,cycles,cache-misses,cache-references,branch-misses,branches,page-faults,context-switches,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-dcache-prefetches,L1-dcache-prefetch-misses,L1-icache-loads,L1-icache-load-misses,L1-icache-prefetches,L1-icache-prefetch-misses,LLC-loads,LLC-load-misses,LLC-sotres,LLC-store-misses,r0180,r0280,r0380,r0480 -C 0,1,2,3 -p $pid -o stat.out -x, sleep $DURATION 
   #perf stat -e instructions,cycles,cache-misses,cache-references,branch-misses,branches,page-faults,context-switches,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-dcache-prefetches,L1-dcache-prefetch-misses,L1-icache-loads,L1-icache-load-misses,L1-icache-prefetches,L1-icache-prefetch-misses,LLC-loads,LLC-load-misses,LLC-sotres,LLC-store-misses -C 0,1,2,3 -p $pid -o stat.out -x, sleep $DURATION 
   #perf stat -a -e r81d0,r82d0,r01d1,r02d1,r04d1,r08d1,r10d1,r20d1,r0180,r0280,r0380,instructions,cycles,cache-misses,cache-references,branch-misses,branches,minor-faults,context-switches -C 0,1,2,3 -o stat.out -x, sleep $DURATION 
   #perf stat -a -e r81d0,r82d0,r01d1,r02d1,r04d1,r08d1,r10d1,r20d1,r0180,r0280,r0380,instructions,cycles,cache-misses,cache-references,branch-misses,branches,minor-faults,context-switches,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores,branch-load-misses,branch-loads,dTLB-load-misses,dTLB-loads,dTLB-store-misses,dTLB-stores,iTLB-load-misses,iTLB-loads -o stat.out -x, sleep $DURATION 
   #perf stat -a -e cycles,instructions,cpu/event=0x3c,umask=0x01,name=UNHALTED_REF_CYCLES/,cpu/event=0x0e,umask=0x01,name=UOPS_ISSUED.ANY/,cpu/event=0x0e,umask=0x01,cmask=1,inv=1,name=UOPS_ISSUED.STALL_CYCLES/,cpu/event=0xa3,umask=0x10,cmask=16,name=CYCLE_ACTIVITY.CYCLES_MEM_ANY/,cpu/event=0xa3,umask=0x14,cmask=20,name=CYCLE_ACTIVITY.STALLS_MEM_ANY/,cpu/event=0xa3,umask=0x04,cmask=4,name=CYCLE_ACTIVITY.STALLS_TOTAL/,cpu/event=0x00,umask=0x01,name=INST_RETIRED.ANY/ -o stat.out -x, sleep $DURATION
   #perf stat -a -e cycles,instructions,cpu/event=0x3c,umask=0x01,name=UNHALTED_REF_CYCLES/,cpu/event=0x0e,umask=0x01,name=UOPS_ISSUED.ANY/,cpu/event=0x0e,umask=0x01,cmask=1,inv=1,name=UOPS_ISSUED.STALL_CYCLES/,cpu/event=0xa3,umask=0x10,cmask=16,name=CYCLE_ACTIVITY.CYCLES_MEM_ANY/,cpu/event=0xa3,umask=0x14,cmask=20,name=CYCLE_ACTIVITY.STALLS_MEM_ANY/,cpu/event=0xa3,umask=0x04,cmask=4,name=CYCLE_ACTIVITY.STALLS_TOTAL/,cpu/event=0xa3,umask=0x14,name=CYCLE_ACTIVITY.STALLS_MEM_ANY/,cpu/event=0xa6,umask=0x01,name=EXE_ACTIVITY.EXE_BOUND_0_PORTS/,cpu/event=0xa6,umask=0x02,name=EXE_ACTIVITY.1_PORTS_UTIL/,cpu/event=0xa6,umask=0x04,name=EXE_ACTIVITY.2_PORTS_UTIL/,cpu/event=0xa6,umask=0x08,name=EXE_ACTIVITY.3_PORTS_UTIL/,cpu/event=0xa6,umask=0x10,name=EXE_ACTIVITY.4_PORTS_UTIL/,cpu/event=0xa6,umask=0x40,name=EXE_ACTIVITY.BOUND_ON_STORES/,cpu/event=0x28,umask=0x07,name=CORE_POWER.LVL0_TURBO_LICENSE/,cpu/event=0x28,umask=0x18,name=CORE_POWER.LVL1_TURBO_LICENSE/,cpu/event=0x28,umask=0x20,name=CORE_POWER.LVL2_TURBO_LICENSE/,cpu/event=0x28,umask=0x40,name=CORE_POWER.THROTTLE/ -o stat.out -x, sleep $DURATION
   #perf stat -a -e cycles,instructions,cpu/event=0x28,umask=0x07,name=CORE_POWER.LVL0_TURBO_LICENSE/,cpu/event=0x28,umask=0x18,name=CORE_POWER.LVL1_TURBO_LICENSE/,cpu/event=0x28,umask=0x20,name=CORE_POWER.LVL2_TURBO_LICENSE/,cpu/event=0xc7,umask=0x01,name=FP_ARITH_INST_RETIRED.SCALAR_DOUBLE/,cpu/event=0xc7,umask=0x02,name=FP_ARITH_INST_RETIRED.SCALAR_SINGLE/,cpu/event=0xc7,umask=0x04,name=FP_ARITH_INST_RETIRED.128B_PACKED_DOUBLE/,cpu/event=0xc7,umask=0x08,name=FP_ARITH_INST_RETIRED.128B_PACKED_SINGLE/,cpu/event=0xc7,umask=0x10,name=FP_ARITH_INST_RETIRED.256B_PACKED_DOUBLE/,cpu/event=0xc7,umask=0x20,name=FP_ARITH_INST_RETIRED.256B_PACKED_SINGLE/,cpu/event=0xc7,umask=0x40,name=FP_ARITH_INST_RETIRED.512B_PACKED_DOUBLE/,cpu/event=0xc7,umask=0x80,name=FP_ARITH_INST_RETIRED.512B_PACKED_SINGLE/ -o stat.out -x, sleep $DURATION

   #perf stat -einstructions,cache-misses,cycles,task-clock,cache-references,branch-misses,branches,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-dcache-prefetches,L1-dcache-prefetch-misses,L1-icache-loads,L1-icache-load-misses,L1-icache-prefetches,L1-icache-prefetch-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,LLC-prefetches,LLC-prefetch-misses -e r0280 -C 0,1,2,3 -p $pid -o stat.out -- sleep $DURATION 
   echo "******End perf stat*********"
   ;;
   "perf")
   echo "************perf: call graph, sleeping for $START seconds**************"
   sleep $START
   echo "Recording events for $DURATION seconds"
   perf record -a -m 4096 -r 1 -g -c 99999999 --call-graph dwarf -- sleep $DURATION   # ==============> to be modified
   #perf record -e r20d1 -a -m 4096 -r 1 --call-graph dwarf -g -c 2000 -- sleep $DURATION   # ==============> to be modified
   #perf record -e r20d1 -a -m 4096 -r 1 -g -c 2000 -- sleep $DURATION   # ==============> to be modified
   #bash -x $PERF_MAP_DIR/bin/create-java-perf-map.sh $pid msig
   perf archive
   mv "/tmp/perf-$pid.map" .
   echo $'#!/bin/bash\ntar xvf perf.data.tar.bz2 -C ~/.debug;\n' > extract.sh
   echo "cp perf-${pid}.map /tmp/" >> extract.sh
   chmod a+x extract.sh
   ;;
esac

   echo "END PROFILING"
