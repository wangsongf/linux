#!/usr/bash
for UNAME in $(cat users.txt); do
echo $UNAME
done
for test in $(ls *.sh);do
echo $test
done
