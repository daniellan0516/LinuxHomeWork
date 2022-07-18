#!/usr/bin/bash
echo -e "\\033[33m===== 刪除使用者$1 =====\\033[0m"
[ "$(ps aux | grep -e ^$1 | awk '{print $2}')" ] && 
sudo kill -9 $(ps aux | grep -e ^$1 | awk '{print $2}') && \
echo "關閉$1使用中的程序"

[ "$(cat /etc/passwd | grep $1)" ] &&
sudo userdel -rf $1 1>/dev/null && \
echo 使用者已刪除
