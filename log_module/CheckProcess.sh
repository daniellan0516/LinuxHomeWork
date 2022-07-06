#!/usr/bin/bash
# process_list=$(podman ps | grep -v pause | awk '{print $1}' | awk 'NR>1')
process_list=("APIServer.jar" "postgres" "hello")
loglocation=/home/$(whoami)/log/$(date +'%F')
logfile=$loglocation/crontab-$(date +'%F').log


# 檢查資料夾
[ ! -d $loglocation ] && mkdir -p $loglocation

for ((i=0;i<"${#process_list[@]}";i++));
do
  pid_file="/tmp/.${process_list[i]}.pid"
  if [ "$(ps aux | grep ${process_list[i]} | wc -l)" -gt 1 ];
  then
    cur_pid=$(ps aux | grep "${process_list[i]}" | awk -F" " '{print $2}' | awk '(NR==1)')
    if [ ! -f $pid_file ]; then echo "Start Scanning." > $pid_file && echo $cur_pid > $pid_file; fi
    if [ "$(cat $pid_file)" != "$cur_pid" ];
    then
      echo "[$(date +'%F %T')] ${process_list[i]} has restarted $(cat $pid_file) -> $cur_pid" >> $logfile
      echo $cur_pid > $pid_file
    else
      echo "nothing happend" >> $logfile
    fi
  fi
done
