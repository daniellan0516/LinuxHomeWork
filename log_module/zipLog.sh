#!/usr/bin/bash
FILE_SIZE=500MB

[ ! $1 ] && echo "至少一個檔案或路徑" && exit 1
if [ -f $1 ];
then
  echo "壓縮$1"
  split -b $FILE_SIZE -d $1 $1.p && gzip $(ls $1.p*)
  exit 0
fi

if [ -d $1 ];
then
  ls $1 | grep -v gz | while read line;
  do
    echo "壓縮$1/$line"
    split -b $FILE_SIZE -d $1/$line $1/$line.p && gzip $(ls $1/$line.p*) && \
    rm $1/$line
  done
  exit 0
fi

echo "無效的檔案或路徑"
exit 1
