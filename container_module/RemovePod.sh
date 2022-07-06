#!/usr/bin/bash
echo -e "\\033[33m===== 關閉及刪除Pod(Container會一併執行) =====\\033[0m"
[ "$(ls ~/.config/systemd/user)" ] &&
ls ~/.config/systemd/user | grep pod- | awk -F. '{print  $1}' | while read line;
do
  systemctl --user disable --now $line
done && echo "停用/刪除$(whoami)所控管的container service"

[ "$(podman pod ps | awk 'NR>1')" ] &&
podman pod stop $(podman pod ps | awk '(NR>1)' | awk '{print $1}') && \
podman pod rm $(podman pod ps | awk '(NR>1)' | awk '{print $1}') && \
echo "刪除所有的container"
