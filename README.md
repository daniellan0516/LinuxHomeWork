# Linux 作業
- [x] 一、打包開發端 source 為 *.tar.gz 腳本
- [x] 二、自動建置 vm 上使用者腳本
- [x] 三、自動安裝 java 等開發用套件，並建置 db container 腳本
- [x] 四、腳本使用 cat < EOF 方式執行 db 資料建置
- [x] 五、自動編譯 source 為可執行 binary (jar/war/class 均可)腳本
- [x] 六、自動檢測連線狀況腳本
- [x] 七、使用 cron job 定時檢查 app server 通訊及 web server 程式存在 (含腳本及 cron)
- [X] 八、自動打包日誌腳本，檔案需有 2 G 大小，每 500 mb 切割壓縮備份回 pc 上
- [X] 九、以上設置清除用腳本
- [X] 十、以上全自動腳本

## 檔案架構
> 公司的產品檔案並沒有放上來

```
[  ]LinuxHomeWork/                         > 專案目錄
   [  ].env                                  # 環境設定檔
 [  ]container_module/                       > 容器相關目錄
   [  ]init.sql                                # 建立使用者及資料庫
   [  ]data.sql                                # 資料庫資料
   [  ]create_pod_service.sh                   # 建立systemclt *****.service檔
   [  ]db_container.sh                         # 建立資料庫容器
   [  ]o360_container.sh                       # 建立AppServer的容器
   [  ]webserver_container.sh                  # 建立WebServer容器
   [  ]RemovePod.sh                            # 刪除Pod的腳本
   [  ]ctbc_o360.tar                           # CTBC的SourceCode
   [  ]Dockerfile-Maven                        # WebServer的DockerFile
   [  ]Dockerfile-o360-o360api-Daniel          # O360的DockerFile
   [  ]hello.tar                               # WebServer的SourceCode
   [  ]o360api.tar                             # O360API的SourceCode
 [  ]log_module/                             > log相關目錄
   [  ]Backup_Del_Log.sh                       # 備份log
   [  ]CheckConnection.sh                      # 檢查連線
   [  ]CheckProcess.sh                         # 檢查程序
   [  ]ZipLog.sh                               # 壓縮log
   [  ]schedule_task                           # crontab
 [  ]CreateContainer.sh                      # 建立容器腳本
 [  ]fakeLog.sh                              # 假資料
 [  ]RemoveUser.sh                           # 刪除使用者
 [  ]UserAdd_Install.sh                      # 新增使用者及安裝套件
```

## 容器
- DataBase : postgres(repository:docker.io)
- AppServer: o360 & o360api(tar)
- WebServer: hello(tar)

## 使用方法
1. 進入專案目錄後，執行`source .env`(或利用direnv相關套件，修改.env檔名)
2. 修改*.sh檔案內變數
3. 執行`updateVM`或`clearVM`
