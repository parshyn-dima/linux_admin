#!/bin/sh
# This should result in very different completion times for the 2 runs.
# This script is useful to be sure that ionice works on your kernel since it's possible to have the
# ionice command yet using it has no effect
# you can check your scheduler with something like 
# cat /sys/block/sda1/queue/scheduler

me=$$
echo "Starting 2 IO ops at different priorities...."
ionice -c 2 -n 0 bash -c "dd if=/dev/urandom of=ionice-a.log bs=1M count=50 && rm ionice-a.log && echo 'a done'" &
a=$!
ionice -c 2 -n 7 bash -c "dd if=/dev/urandom of=ionice-b.log bs=1M count=50 && rm ionice-b.log && echo 'b done'" &
b=$!

# let things get forked? sometimes pstree is wrong otherwise
sleep 1

pstree -pal $me

echo "A [`ps xao ppid $a -o pid=`]: `ps xao ppid $a -o pid= | xargs ionice -p`"
echo "B [`ps xao ppid $b -o pid=`]: `ps xao ppid $b -o pid= | xargs ionice -p`"