#!/usr/bin/bash
PORCESS_LIST=("APIServer.jar" "postgres" "hello")
LOG_DIR=/home/$(whoami)/log/$(date +'%F')
LOG_FILE=$LOG_DIR/process-$(date +'%F').log


# 檢查資料夾
[ ! -d $LOG_DIR ] && mkdir -p $LOG_DIR

for ((i=0;i<"${#PORCESS_LIST[@]}";i++));
do
  pid_file="/tmp/.${PORCESS_LIST[i]}.pid"
  if [ "$(ps aux | grep ${PORCESS_LIST[i]} | wc -l)" -gt 1 ];
  then
    cur_pid=$(ps aux | grep "${PORCESS_LIST[i]}" | awk -F" " '{print $2}' | awk '(NR==1)')
    if [ ! -f $pid_file ]; then echo "Start Scanning." > $pid_file && echo $cur_pid > $pid_file; fi
    if [ "$(cat $pid_file)" != "$cur_pid" ];
    then
      echo "[$(date +'%F %T')] ${PORCESS_LIST[i]} has restarted $(cat $pid_file) -> $cur_pid" >> $LOG_FILE
      echo $cur_pid > $pid_file
    else
      echo "nothing happend" >> $LOG_FILE
    fi
  fi
done
