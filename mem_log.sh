#!/bin/bash -e

#rm test1.txt
#echo "      date     time $(free -m | grep total | sed -E 's/^    (.*)/\1/g')"
while true; do
    #echo "$(date '+%Y-%m-%d %H:%M:%S') $(free -m | grep Mem: | sed 's/Mem://g')"
    echo "$(awk '/^Mem/ {print $3}' <(free -k))">>memory_consumed.txt
    sleep 0.001
done
