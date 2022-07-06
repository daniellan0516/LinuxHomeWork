#!/usr/bin/bash
create_pod_service() {
  echo -e "\\033[33m===== 設定Container Service ======\\033[0m" && \
  mkdir -p ~/.config/systemd/user/ && \
  loginctl enable-linger $username && \
  podman pod ps | awk 'NR>1' | while read line;
  do
    podname=$(echo $line | awk -F' ' '{print $2}')
    podman generate systemd --restart-policy always --restart-sec 30 --name --files $podname 
  done && \

  [ "$(ls *.service 2>/dev/null)" ] &&
  ls *.service | awk -F' ' '{print $1}' | while read line;
  do
    systemctl disable --user --now $line 1>/dev/null 2>/dev/null
  done

  mv *.service ~/.config/systemd/user/
  ls ~/.config/systemd/user/pod*.service | while read line; 
  do 
    systemctl enable --user --now $line 1>/dev/null 2>/dev/null
  done
}
