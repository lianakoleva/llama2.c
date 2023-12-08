#!/bin/bash

total=0
exec=${1:-perf-run}
model=${2:-stories15M.bin}
n=${3:-10}

echo -e "\033[1m[ $exec performance testing ]\033[0m"

for ((i = 1; i <= $n; i++)); do
    $(make $exec MODEL=$model > /dev/null 2> perf.out)
    result=$(grep 'achieved tok/s:' perf.out | awk '{print $NF}')
    echo "run $i tok/s: $result"
    total=$(echo "$total + $result" | bc -l)
done

average=$(echo "scale=4; $total / $n" | bc -l)
echo -e "\033[1m\033[35maverage tok/s over $n runs: $average\033[0m"
rm perf.out