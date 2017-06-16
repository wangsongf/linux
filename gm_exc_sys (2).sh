#!/bin/bash
declare -a sys
sysarr=( 'equip' 'pet' 'mount' 'wing' 'gem' 'root' )
srvstart=$1
srvend=$2
cmd="/usr/local/services/php/bin/php /usr/local/services/apache/htdocs/gameadmin/public/cross_api/get_sys_data.php"

for sys in ${sysarr[@]}
do
    for (( i = $srvstart; i <= $srvend; i+=100 ))
    do
        #echo "$cmd $sys $i $(($i+99))>> /tmp/get_sys_log.txt 2>&1 &"
        `$cmd $sys $i $(($i+99))>> /tmp/get_sys_log.txt 2>&1 &`
    done
done
