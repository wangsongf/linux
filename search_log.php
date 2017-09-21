
#!/bin/bash
logFile=bbb.log
filename=([0]="central_api"
        [1]="comeback"
        [2]="crossapi"
    [3]="idip_api"
    [4]="tw_api"
    [5]="tx_api"
    [6]="mobile_api"
    [7]="shell"
    [8]="vn_api"
    [9]="yt_api"
    [10]="idip_api_mobile"
        )
num=${#filename[@]}
for((i=0;i<num;i++)){
echo =====================${filename[$i]}==================
STARTTIME=`date "+%s"`
cat 'access_log.2017-09-14' 'access_log.2017-09-13' 'access_log.2017-09-12' 'access_log.2017-09-11' 'access_log.2017-09-10' 'access_log.2017-09-09' 'access_log.2017-09-08'|grep ${filename[$i]}
ENDTIME=`date "+%s"`
echo ${filename[$i]} "($[ $ENDTIME-$STARTTIME ] s)" >> $logFile
}

echo "==================end=======================" >> $logFile
