#!/usr/bin/sh
loglocation=/home/$(whoami)/log/$(date +'%F')
logfile=$loglocation/crontab-$(date +'%F').log

# 檢查資料夾
[ ! -d $loglocation ] && mkdir -p $loglocation

# 檢查網際網路連線狀況
if ping -q -c 1 -W 1 google.com >/dev/null; then
  echo "Network is up"
else
  echo "Network is down @ $(date +'%F %T')" >> $logfile
  exit 1
fi

# 檢查是否輸入IP
if [ $1 ];
then
  ip=$1
else
  ip=$(ip addr | grep 192.168 | awk -F" " '{print $2}' | awk -F/ '{print $1}')
fi

# 檢查webserver
result="$(curl -o /dev/null -s -w "%{http_code}\n" http://$ip:8080)"
if [ "$result" != "200" ];
then
  echo "http://$ip:8080 -> $result @ $(date +'%F %T')" >> $logfile
else
  echo "http://$ip:8080 -> 連線成功 @ $(date +'%F %T')" >> $logfile
fi

# 檢查appserver
result="$(curl -X POST -o /dev/null -s -w "%{http_code}\n" http://$ip:49200/o360api/op/status/channel)"
if [ "$result" != "200" ];
then
  echo "http://$ip:49200/o360api/op/status/channel -> $result @ $(date +'%F %T')" >> $logfile
else
  echo "http://$ip:49200/o360api/op/status/channel -> 連線成功 @ $(date +'%F %T')" >> $logfile
fi

