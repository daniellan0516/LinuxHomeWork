#!/usr/bin/bash
FILE_SIZE=500

[ ! $1 ] && echo "至少一個檔案或路徑" && exit 1

if [ -f $1 ];
then
  [ "$(du -m $1)" -gt $FILE_SIZE ] && split -b "$FILE_SIZE"MB -d $1 $1.p
  gzip $(ls $1*)
  exit 0
fi

if [ -d $1 ];
then
  ls $1 | grep -v gz | while read line;
  do
    [ "$(du -m $1/$line)" -gt $FILE_SIZE ] && split -b "$FILE_SIZE"MB -d $1/$line $1/$line.p
    gzip $(ls $1/$line*)
  done
  exit 0
fi

echo "$1:無效的檔案或路徑"
exit 1
