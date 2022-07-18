#!/usr/bin/bash
webserver_container() {
  POD_NAME=WEB_POD
  CONTAINER_NAME=WEB_SERVER

  cd container_module
  tar -xf hello.tar && \
  tar -xf .m2.tar && \

  # 修改properties
  sed -i "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$ip/g" \
    ctbc_o360/etc/db.properties && \
  sed -i '37 s/49200/49201/' o360api/application.properties && \
  sed -i '39 s/true/false/' o360api/application.properties && \
  sed -i '71 s/49201/49200/' o360api/application.properties && \


  echo -e "\\033[33m===== 安裝Maven Container ======\\033[0m"
  [ "$(podman pod ps | grep $POD_NAME)" = "" ] && 
  podman pod create --name $POD_NAME -p 8080:8080
  podman build -f Dockerfile-Maven -t mvn-webserver && \
  podman run -d --pod $POD_NAME --name $CONTAINER_NAME --tz=Asia/Taipei $(podman images | grep mvn-webserver | awk '{print $3}')
  cd ..
}
