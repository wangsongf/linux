#!/bin/sh
DIR="wang"
echo $DIR
ping -c 3 -i 0.2 -W 3 $1 &>/dev/null
if [ $? -eq 0 ] ; then
echo "host $1 is up"
else
echo "host $1 is down"
fi
