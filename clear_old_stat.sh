timestamp=`date -d "$day $hms" +%s`
timestamp=`expr $timestamp - 2592000`
day=`date -d "1970-01-01 $timestamp sec utc" +%Y%m%d`
dataFile=`echo "/data/dcagent/stat/agentstat_$day"`
rm $dataFile; 
