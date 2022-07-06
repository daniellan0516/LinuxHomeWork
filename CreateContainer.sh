#!/usr/bin/bash
echo "export XDG_RUNTIME_DIR=/run/user/$(id -u)" > ~/.bashrc
username=vfepadm
XDG_RUNTIME_DIR=/run/user/$(id -u)
REMOVE_OLD_POD=true
INSTALL_DB=true
INSTALL_O360=true
INSTALL_WEBSERVER=true
CREATE_POD_SERVICE=true

ip=$(ip addr | grep 192.168 | awk -F" " '{print $2}' | awk -F/ '{print $1}')

# 修改檔案權限
sudo chown -R $username:$username *

# 刪除舊的pod
[ "$REMOVE_OLD_POD" == "true" ] && [ "$(podman pod ps | awk 'NR>1')" ] &&
echo -e "\\033[33m===== 刪除舊的Pod =====\\033[0m" && \
~/container_module/ClearPod.sh

# 建立DB COontainer
[ "$INSTALL_DB" = "true" ] &&
source ./container_module/db_container.sh && \
db_container && ANY_POD_INSTALLED=true

# 建立O360 Container
[ "$INSTALL_O360" = "true" ] &&
source container_module/o360_container.sh && \
o360_container && ANY_POD_INSTALLED=true


# 建立Maven Container
[ "$INSTALL_WEBSERVER" = "true" ] &&
source container_module/webserver_container.sh && \
webserver_container && ANY_POD_INSTALLED=true


# 建立Container的Systemclt service
[ "$CREATE_POD_SERVICE" = "true" ] && [ "$ANY_POD_INSTALLED" = "true" ] &&
source container_module/create_pod_service.sh && \
create_pod_service

# 設定使用者的crontab
echo -e "\\033[33m===== 設定Crontab ======\\033[0m"

if [ "$(crontab -l | wc -l)" -gt 0 ];
then
  echo rockylinux | su -c "echo \"===== $(whoami) crontab backup @$(date) =====\" >> /home/rockylinux/crontab_backup" rockylinux 1>>/dev/null
  echo "備份$username的crontab"
  echo rockylinux | su -c "sudo crontab -u $username -l >> /home/rockylinux/crontab_backup" rockylinux 1>/dev/null
fi

sudo crontab -u vfepadm $HOME/log_module/schedule_task  
echo "載入新的crontab"
cat $HOME/log_module/schedule_task && \
sudo -S systemctl start crond


echo -e "\\033[31m===== 安裝完成了 =====\\033[0m"