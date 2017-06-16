#!/bin/sh
date=`date -d "-1 day" +%Y-%m-%d`
date_old=`date -d "-7 day" +%Y-%m-%d`

#echo $date
#echo $date_old
cd /data/nginx_logs
cp -fr access_80.log access_80.log_$date
cat /dev/dull > access_80.log
rm access_80.log_$date_old
