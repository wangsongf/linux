#! /bin/sh 
DCMLIST="reportlist"

declare -a IP 
declare -a PORT

total=0
ret=1
threshhold=20000000


function init()
{

	while read addr 
	do
	IP[$i]=`echo "$addr" | awk '{print $1}'`
	PORT[$i]=`echo "$addr" | awk '{print $2}'`
	let i++
	done < $DCMLIST
	
	
	total=$i
	echo "read $total dcm addr"
	
	
	i=0
	while [ $i -lt $total ]
    do
        echo "${IP[$i]}:${PORT[$i]}"
        let i++
    done

}

function report()
{
	i=0
	while [ $i -lt $total ]
    	do
		#echo "$i $total"
		ipStr=${IP[$i]};
		len=`echo "$ipStr"|wc -c`
		if [ $len -lt 8 ]
		then
			let i++
			continue
		fi
		retval=`./mytelnet ${IP[$i]} ${PORT[$i]} $1 0`
		#echo $retval
		let i++
    	done
}


function check()
{
	if [ ! -f $1 ]
	then
	return 0
	fi
	
	filesize=`ls $1 -l|grep ^- |awk '{print $5}'`
	#echo "PCmd=25&PIP=$localIP&Filename=$1&Filesize=$filesize"
	if [ $filesize -gt $threshhold ]
	then
	report "PCmd=25&PIP=$localIP&Filename=$1&Filesize=$filesize"
	fi
	
}

cd /usr/local/services/CloudDCAgent_L5-1.0/tool

init
localIP=`./getip`


check /data/dcagent/send.dat
check /data/dcagent/send.tmp
check /data/dcagent/msgdat.dat
check /data/dcagent/msgdat.tmp
check /data/dcagent/baselog.dat
check /data/dcagent/baselog.tmp
check /data/dcagent/sendmod.dat
check /data/dcagent/sendmod.tmp
check /data/dcagent/monitor.dat
check /data/dcagent/monitor.tmp


