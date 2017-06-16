#!/bin/bash

passwd="yjmt@tuyoo"
ip=10.2.12.2

expect <<EOF
set timeout -1
log_user 1

spawn ssh  -q root@$ip
expect "(yes/no)?" {
send "yes\r"
expect "*assword:"
send "$passwd\r"
} "*assword:" {send "$passwd\r"} 
expect "*#"
send "sh /usr/local/services/shell/test.sh $1 $2 $3 \r"
send "exit\r"
expect "logout" {puts "successful"}

expect eof
EOF

sleep 3
for apple in `ps axu | grep "ssh -q root@$ip"|grep -v grep |awk '{print $2}'`
do
kill -9 $apple
done
