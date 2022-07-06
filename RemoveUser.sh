#!/usr/bin/bash
[ "$(ps aux | grep -e ^$1 | awk '{print $2}')" ] && 
sudo kill -9 $(ps aux | grep -e ^$1 | awk '{print $2}') && \
echo -e "\\033[33m===== 關閉 $1 使用中的程序 =====\\033[0m"

[ "$(cat /etc/passwd | grep $1)" ] &&
sudo userdel -rf $1 1>/dev/null && \
echo 刪除使用者
