#!/usr/bin/bash

echo -e "\\033[33m"===== 設定時間+1天 ====="\\033[0m"
echo $PASSWD | sudo -S timedatectl set-ntp yes && \
echo $PASSWD | sudo -S timedatectl set-timezone "Asia/Taipei" && \
echo $PASSWD | sudo -S timedatectl set-ntp no && \
echo $PASSWD | sudo -S timedatectl set-time "$(date -d "$(date)+1 days" +'%F %T')" && \
date +'%F %T'

ssh daniel@$current_ip "mkdir -p ~/log"
scp -r $HOME/log/$(date -d "$(date)-1 days" +'%F') \
  daniel@$current_ip:log


echo -e "\\033[33m"===== 還原時間 ====="\\033[0m"
echo $PASSWD | sudo -S timedatectl set-time "$(date -d "$(date)-1 days" +'%F %T')" && \
date +'%F %T'
