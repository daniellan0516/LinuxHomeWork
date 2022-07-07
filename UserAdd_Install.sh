#!/usr/bin/bash
USER=vfepadm
PASSWORD=s5640434
PORT_LIST="40000 5432 9876 49200 49201 8080"
INSTALL_PODMAN=true
INSTALL_TELNET=true
INSTALL_FIREWALLD=true
USER_ADD=true

# 安裝podman
if [ "$INSTALL_PODMAN" == "true" ];
then
echo -e "\\033[33m"===== Podman檢查 ====="\\033[0m"
if [ "$(dnf list --installed | grep podman.$(uname -m))" == "" ];
  then
    echo "正在安裝Podman"
    sudo dnf -y install podman podman-plugins 1>/dev/null && \
    sudo systemctl enable --now podman 1>/dev/null && \
    podInstall=true
  else
    echo "系統已安裝Pomdan"
  fi
fi

# 新增使用者
if [ "$USER_ADD" == "true" ];
then
  echo -e "\\033[33m"===== 使用者檢查 ====="\\033[0m"
  if [ "$(id $USER 2>/dev/null)" == "" ];
  then
    sudo useradd $USER && \
    echo $PASSWORD | sudo passwd --stdin $USER 1>/dev/null && \
    echo "使用者$USER不存在，新增使用者$USER:$PASSWORD。"
  else
    echo "$USER已建立"
  fi

  if [ "$(id $USER | grep wheel 2>/dev/null)" == "" ];
  then
    sudo usermod -G wheel -a $USER && \
    echo "使用者$USER不具有sudo權限，新增sudo權限"
  fi
fi

# 複製檔案
if [ -d "/home/$USER" ];
then
  sudo cp -r * /home/$USER && \
  echo "複製檔案到$USER家目錄"
  [ -f ~/.ssh/authorized_keys ] && sudo cp -r /home/rockylinux/.ssh /home/$USER/ && \
  echo "複製金鑰到$USRT家目錄"
  sudo chown -R $USER:$USER /home/$USER
fi

# 安裝防火牆
if [ "$INSTALL_FIREWALLD" == "true" ];
then
  echo -e "\\033[33m"===== 防火牆檢查 ====="\\033[0m" && \
  if [ "$(dnf list --installed | grep firewalld)" == "" ];
  then
    echo "正在安裝防火牆" && \
    sudo dnf install firewalld firewall-config 1>/dev/null && \
    sudo systemctl enable --now firewalld 1>/dev/null
  fi

  for portnum in $PORT_LIST;
  do
    if [ "$(sudo firewall-cmd --list-port | grep $portnum)" == "" ];
    then
      sudo firewall-cmd --zone=public --add-port=$portnum/tcp --permanent 1>/dev/null && \
      echo -e "開啟 \\033[34m$portnum\\033[0m Port" 
    fi
  done
fi

# 安裝telnet
[ "$INSTALL_TELNET" == "true" ] && sudo dnf -y install telnet 1>/dev/null 

[ $podInstall ] && sudo reboot
