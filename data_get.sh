#!/usr/bin/expect -f

#set ip passwd
set start_data [lindex $argv 0]
set end_data [lindex $argv 1]
set ip 10.142.33.84
set user app1000000129
set passwd Hoolai!#14
#ssh login
spawn ssh -p 36000 $user@$ip
expect {
"yes/no" { send "yes\r";exp_continue }
"Password:" {send "$passwd\r"}
}
expect "~>"
send "sudo su -\r"
expect "#"
send "/usr/local/services/shell/test.sh $start_data $end_data\r"
send "exit\r"
send "exit\r"
interact
