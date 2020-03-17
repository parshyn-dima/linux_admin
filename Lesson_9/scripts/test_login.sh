#!/bin/bash
GR=$(id -Gn $PAM_USER | grep -c admins)
if [ "$GR" -eq 1 ]; then
    exit 0
elif [ "$GR" -eq 0 -a $(date +%u) -le 5 ]; then
    exit 0
else
    exit 1
fi