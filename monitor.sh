#! /bin/sh

###file_ver=2.0.3

PATH=$PATH:.

#monitor the application
#create by leonlaili,2006-12-6

####### Custom variables begin  ########
##todo: add custom variables here
#get script path
dir_pre=$(dirname $(which $0))
####### Custom variables end    ########

#load common functions
load_lib()
{
    common_file=$dir_pre/common.sh
    if [ -f $common_file ];then
        . $common_file
    fi
}

#check current user
check_user()
{
    if [ "$user" != "`whoami`" ];then
        echo "Only $user can execute this script"
        exit 1
    fi
}

#print help information
print_help()
{
    ##todo: output help information here
    # echo ....
    return 
}

#check script parameters
check_params()
{
    ok="true"
    ##todo: add addition parameters checking statement here...
    
    if [ "$ok" != "true" ];then
        echo "Some of the parameters are invalid. "
        print_help
        exit 1
    fi
}

get_app_num()
{
    numbers=`echo $app_name | sed -e "s:[ \t]:\n:g" | grep "^$1[:$]" | awk -F: '{print $2}'`
    num1=`echo $numbers|awk -F, '{print $1}'`
    num2=`echo $numbers|awk -F, '{print $2}'`

    if [ "${num1}" = "" ];then
        num1=1
    fi

    if [ "${num2}" = "" ];then
        num2=999999999
    fi
    
}

#check port
check_port()
{
    nc_cmd="/usr/bin/nc"
    if [ ! -f $nc_cmd ];then
        nc_cmd="/usr/bin/netcat"
    fi

    $nc_cmd -zn -w4 $1 $2
    if [ $? -ne 0 ];then
        for (( i=0 ; i<5 ; i++ ))
        do
            $nc_cmd -zn -w4 $1 $2
            if [ $? -eq 0 ];then return 0;fi
            sleep 1
        done
        #check VIP again
        if [ "$vip" != "" ];then
            for (( i=0 ; i<5 ; i++ ))
            do
                $nc_cmd -zn -w4 $vip $2
                if [ $? -eq 0 ];then return 0;fi
                sleep 1
            done
        fi
        err_port="$err_port $p"
        return 1 
    fi
    return 0
}

#check process
check_process()
{
    get_app_num $1
    app=`echo $1 | awk -F: '{print $1}'`
    #num=`ps -C $app | sed -e "1d" | wc -l`
	num=`ps -f -C $app | fgrep -w $app | wc -l`
    if [ $num -lt $num1 -o $num -gt $num2 ];then
        err_app="$err_app $app"
        return 1
    fi
    return 0
}

#check if application is ok
check_app()
{
    if [ ! -f $runing_file ];then
        return 0
    fi

    if [ "$ip_type" = "0" ];then
        bind_ip=$ip_inner
    elif [ "$ip_type" = "1" ];then
        bind_ip=$ip_outer
    elif [ "$ip_type" = "2" ];then
        bind_ip="0.0.0.0"
    elif [ "$ip_type" = "3" ];then
        bind_ip=$vip
    elif [ "$ip_type" = "4" ];then
        bind_ip=127.0.0.1
    fi 
 
    ##todo: add application checking statement here
    err_app=""
    err_port=""

    run_config "monitor"

}

#resolve the problems of application
resolve_app()
{

    #发送告警信息
    #report "Monitor: restart [process:${err_app}][port:${err_port}]"

    ##todo: add custom statement here

    run_config "resolve"

    return
}

#report monitor result infomation
rpt_info()
{
    local rtype="$1"
    local elem="$2"
    local action="$3"
    report_ip=172.16.211.50
    url_head="http://$report_ip/pkg/monitor_rpt.php"
    response_file="/tmp/.monitor_report.tmp"
    wget_options="-T5 -t1 -O $response_file --connect-timeout=5"
    
    wget $wget_options "${url_head}?ip=${ip_inner}&install_path=${install_path}&type=${rtype}&elem=${elem}&action=${action}" > /dev/null 2>&1
        
    rm $response_file 2>/dev/null
}


###### Main Begin ########
if [ "$1" = "--help" ];then
    print_help
    exit 0
fi

load_lib
check_user
check_params
check_app
if [ "$err_app" != "" -o "$err_port" != "" ];then
    resolve_app
fi

if [ "$err_app" != "" ];then
    err_app_list=`echo "$err_app" | sed -e 's/ /,/g' -e 's/^,//' -e 's/,$//'`
    #rpt_info 'app' "$err_app_list" "restart"
fi

if [ "$err_port" != "" ];then
    err_port_list=`echo "$err_port" | sed -e 's/ /,/g' -e 's/^,//' -e 's/,$//'`
    #rpt_info 'port' "$err_port_list" "restart"
fi
###### Main End   ########
