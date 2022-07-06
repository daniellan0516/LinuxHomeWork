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
-  LinuxHomeWork           #專案目錄
 |-  container_module      #container相關檔案
 |-  log_module            #log相關檔案
    |-  CheckConnection.sh #檢查連線狀況的ShellScript
    |-  CheckProcess.sh    #檢查運行狀況的ShellScript
    |-  sendLog.sh         #備份log的ShellScript
    |-  zipLog.sh          #壓縮log的ShellScript
    |-  schedule_task      #crontab的腳本
 |-  UserAdd_Install.sh    #新增使用者及安裝套件的ShellScritp
 |-  CreateContainer.sh    #安裝Container的ShellScritp
 |-  fakeLog.sh            #產生假Log的



## .env
`updateVM`、`clearVM`都是寫在在`.env`檔內，若是沒有安裝`direnv`等類似套件，需執行`source .env`

## 容器
- DataBase : postgres(repository:docker.io)
- AppServer: o360 & o360api(tar)
- WebServer: hello(tar)


