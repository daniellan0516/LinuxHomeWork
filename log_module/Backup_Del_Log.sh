#!/usr/bin/bash

# 為了模擬  先修改時間
sudo timedatectl set-ntp yes && \
sudo timedatectl set-timezone "Asia/Taipei" && \
sudo timedatectl set-ntp no && \
sudo timedatectl set-time "$(date -d "$(date)+1 days" +'%F %T')" && \
date +'%F %T'

# 備份份log
ssh daniel@$CURRENT_IP "IF not exist log ( mkdir log)" && \
scp -r $HOME/log/$(date -d "$(date)-1 days" +'%F') \
  daniel@$CURRENT_IP:log

# 保留最後五天的log
find $HOME/log/* -type d | sort -nr | awk 'NR>5' | while read line;
do 
  rm -rf $line
done

# 復原時間
echo $PASSWD | sudo -S timedatectl set-time "$(date -d "$(date)-1 days" +'%F %T')" && \
date +'%F %T'
