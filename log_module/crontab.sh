#!/usr/bin/bash

# 設定使用者的crontab
echo -e "\\033[33m===== 設定Crontab ======\\033[0m"

{ crontab -l && \
  cat $HOME/log_module/schedule_task | while read line;do echo "$line #$1";done } | crontab
echo "載入新的crontab"
cat $HOME/log_module/schedule_task && \

echo "#!/usr/bin/bash" > RestoreCron.sh
echo "crotab -l | grep -v #$1 | crontab" >> RestoreCron.sh
chmod u+x ResotreCron.sh
