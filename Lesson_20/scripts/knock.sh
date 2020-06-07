#!/bin/bash
if [[ $1 = open ]]; 
then
    nmap -p 5040 192.168.255.1 >/dev/null
    nmap -p 6010 192.168.255.1 >/dev/null
    nmap -p 6500 192.168.255.1 >/dev/null
    echo "ssh port was opened"
elif [[ $1 = close ]]; 
then
    nmap -p 4040 192.168.255.1 >/dev/null
    nmap -p 5050 192.168.255.1 >/dev/null
    nmap -p 8080 192.168.255.1 >/dev/null
    echo "ssh port was closed"
else
    echo "Unknown command (please run knock.sh open|clouse)" >&2 && exit 1
fi