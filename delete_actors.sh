#!/bin/sh
if [ $# -lt 1 ]
then
  echo "请输入参数，服务器id"
  exit
fi
MYSQL_USER=root
MYSQL_PWD=hoolai12
database=actor_$1
port=3306
##########################################
tables=("actors" "actorbagitem" "actorbinarydata" "actorconsignment" "actordepotitem" "actordmkjitem" "actorentrustitem" "actorequipitem" "actorguild" "actormail" "actormountitem" "actormsg" "actorvariable" "beastlog" "friends" "goingquest" "pet" "petskill" "petyhs" "pethistory" "repeatquest" "skill" "sysvar" "actoryiguiitem" "actormiji" "fightlog" )

mysql -u$MYSQL_USER -p"$MYSQL_PWD" -h"$2" -P"$port" -e "drop table if exists $database.cidx;"

mysql -u$MYSQL_USER -p"$MYSQL_PWD" -h"$2" -P"$port" -e "use $database; CREATE TABLE cidx( actorid int not null primary key);"

mysql -u$MYSQL_USER -p"$MYSQL_PWD" -h"$2" -P"$port" -e "insert into $database.cidx (select actorid from $database.actors where recharge=0 and level<=60 and updatetime<=subdate(now(),interval 30 day));"

for table in ${tables[@]}
 do
   #echo $table 
   mysql -u$MYSQL_USER -p"$MYSQL_PWD" -h"$2" -P"$port" -e "delete from $database.$table where actorid in (select actorid from $database.cidx);"
done

mysql -u$MYSQL_USER -p"$MYSQL_PWD" -h"$2" -P"$port" -e "delete from $database.actors where level = 0;"
mysql -u$MYSQL_USER -p"$MYSQL_PWD" -h"$2" -P"$port" -e "drop table if exists $database.cidx;"

echo "succ"