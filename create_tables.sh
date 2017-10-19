#!/bin/sh
#遇到问题：写法正常，但是运行报语法错误
#解决方案：在linux重新复制编辑保存，是因为windows编辑器编码异常导致
MYSQL_USER=root
MYSQL_PWD=
database=bi
port=3306
cdate=`date -d "6 month" +"%Y%m"`
year=${cdate:0:4}
month=${cdate:4:2}
start_date=`date +"%Y%m01"` #当月第一天
end_date=`date -d"$(date -d"1 month" +"%Y%m01") -1 day" +"%Y%m%d"` #当月最后一天
ts=$((`cal $month $year|xargs |awk '{print NF}'`-9))
echo $ts
##########################################
tables=("log_milestone_" "log_chat_" "log_economy_" "log_dau_" "log_install_" "log_counter_" "log_online_" )
for table in ${tables[@]}; do
	for((i=1;i<=$ts;i++)); do
		ts_num=`printf "%02d\n" $i`
		cdate=$year$month$ts_num
		table_name=$table$cdate
		case $table in
		    log_economy_)  mysql -uroot -pfnaU2lQw -h127.0.0.1 -P3306 -e "use bi;CREATE TABLE If Not Exists $table_name(logdate datetime NOT NULL,accountname varchar(80) DEFAULT NULL,currency varchar(32) DEFAULT NULL,amount varchar(32) DEFAULT NULL,value varchar(32) DEFAULT NULL,kingdom varchar(32) DEFAULT NULL,phylum varchar(32) DEFAULT NULL,classfield varchar(32) DEFAULT NULL,family varchar(32) DEFAULT NULL,genus varchar(32) DEFAULT NULL,extra varchar(32) DEFAULT NULL,pf varchar(32) DEFAULT NULL,actorid int(11) DEFAULT '0',ispay varchar(32) DEFAULT NULL,openkey varchar(32) DEFAULT NULL,pfkey varchar(32) DEFAULT NULL,channelid varchar(32) DEFAULT NULL,deviceid varchar(32) DEFAULT NULL,serverid int(11) DEFAULT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8;"
		    ;;
		    log_milestone_) mysql -uroot -pfnaU2lQw -h127.0.0.1 -P3306 -e "use bi;CREATE TABLE If Not Exists $table_name(logdate datetime NOT NULL,accountname varchar(80) DEFAULT NULL,milestone varchar(32) DEFAULT NULL,amount varchar(32) DEFAULT NULL,value varchar(32) DEFAULT NULL,extra varchar(32) DEFAULT NULL,serverid int(11) DEFAULT NULL,actorid bigint(10) DEFAULT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8;"
		    ;;
		    log_chat_)   mysql -uroot -pfnaU2lQw -h127.0.0.1 -P3306 -e "use bi;CREATE TABLE If Not Exists $table_name(logdate datetime NOT NULL,qid varchar(32) DEFAULT NULL,name varchar(32) DEFAULT NULL,chattype int(8) DEFAULT NULL,toqid varchar(32) DEFAULT NULL,toname varchar(80) DEFAULT NULL,content varchar(255) DEFAULT NULL,ip varchar(80) DEFAULT NULL,pf varchar(80) DEFAULT NULL,serverid int(11) DEFAULT NULL,actorid bigint(10) DEFAULT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8;"
		    ;;
		    log_dau_)   mysql -uroot -pfnaU2lQw -h127.0.0.1 -P3306 -e "use bi;CREATE TABLE If Not Exists $table_name(logdate datetime NOT NULL,accountname varchar(80) DEFAULT NULL,source varchar(32) DEFAULT NULL,affiliate varchar(32) DEFAULT NULL,creative varchar(32) DEFAULT NULL,family varchar(32) DEFAULT NULL,genus varchar(32) DEFAULT NULL,ip varchar(50) DEFAULT NULL,from_uid varchar(32) DEFAULT NULL,extra varchar(255) DEFAULT NULL,deviceid varchar(32) DEFAULT NULL,channelid varchar(32) DEFAULT NULL,serverid int(11) DEFAULT NULL,actorid bigint(10) DEFAULT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8;"
		    ;;
		    log_install_)  mysql -uroot -pfnaU2lQw -h127.0.0.1 -P3306 -e "use bi;CREATE TABLE If Not Exists $table_name(logdate datetime NOT NULL,accountname varchar(80) DEFAULT NULL,source varchar(32) DEFAULT NULL,affiliate varchar(32) DEFAULT NULL,creative varchar(32) DEFAULT NULL,family varchar(32) DEFAULT NULL,genus varchar(32) DEFAULT NULL,from_uid varchar(32) DEFAULT NULL,extra varchar(32) DEFAULT NULL,deviceid varchar(32) DEFAULT NULL,channelid varchar(32) DEFAULT NULL,serverid int(11) DEFAULT NULL,actorid bigint(10) DEFAULT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8;"
		    ;;
		    log_counter_)   mysql -uroot -pfnaU2lQw -h127.0.0.1 -P3306 -e "use bi;CREATE TABLE If Not Exists $table_name(logdate datetime NOT NULL,accountname varchar(80) DEFAULT NULL,user_level varchar(32) DEFAULT NULL,counter varchar(255) DEFAULT NULL,value varchar(255) DEFAULT NULL,extra varchar(255) DEFAULT NULL,classfield varchar(255) DEFAULT NULL,kingdom varchar(255) DEFAULT NULL,phylum varchar(255) DEFAULT NULL,family varchar(255) DEFAULT NULL,genus varchar(255) DEFAULT NULL,deviceid varchar(32) DEFAULT NULL,channelid varchar(32) DEFAULT NULL,serverid int(11) DEFAULT NULL,actorid bigint(10) DEFAULT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8;"
		    ;;
		    log_online_)  mysql -uroot -pfnaU2lQw -h127.0.0.1 -P3306 -e "use bi;CREATE TABLE If Not Exists $table_name(logdate datetime NOT NULL,count int(11) DEFAULT NULL,serverid int(11) DEFAULT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8;"
		    ;;
		    *)  echo 'error param'
		    ;;
		esac
	done
done
echo "suc"
