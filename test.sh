#!/bin/bash
a=`date +%Y-%m-%d`
b=`date +%H`
passwd="Hoolai!#14"
#第十大区
ip=$1
dir='apache-tomcat-BI'
if [[ "$ip" == "10.190.255.42" || "$ip" == "10.204.190.127" || "$ip" == "10.204.188.77" || "$ip" == "10.204.157.96" ]];then
	dir='apache-tomcat-6.0.35'
fi

expect <<EOF
set timeout -1
log_user 1

spawn ssh -o StrictHostKeyChecking=no -q -p 36000 app100634204@$ip
expect "Password:"
send "$passwd\r"
expect "*VM*"
send "tail -n1000 /usr/local/services/$dir/webapps/LoggerApp/zx/$a/$b.txt \r"
send "exit\r"
expect "logout" {puts "successful"}

expect eof
EOF

sleep 3
for apple in `ps axu | grep "ssh -q -p 36000 app100634204@$ip"|grep -v grep |awk '{print $2}'`
do
kill -9 $apple
done

