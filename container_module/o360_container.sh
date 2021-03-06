o360_container() {
  POD_NAME=o360_uapc1
  CONTAINER_NAME=o360

  cd container_module
  tar -xf ctbc_o360.tar && \
  tar -xf o360api.tar && \
  tar -xf o360_fix_package.tar && \
  sudo chown -R "$(whoami):$(whoami)" * && \

  # echo "修改properties"
  sed -i "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$ip/g" ctbc_o360/etc/db.properties
  sed -i '37 s/49200/49201/' o360api/application.properties
  sed -i '39 s/true/false/' o360api/application.properties
  sed -i '71 s/49201/49200/' o360api/application.properties


  echo -e "\\033[33m===== 建立o360 Container =====\\033[0m"
  [ "$(podman pod ps | grep $POD_NAME)" = "" ] &&
  podman pod create --name $POD_NAME --network podman \
    -p 40000:40000/tcp -p 49200:49200/tcp -p 49201:49201/tcp
  podman build -f Dockerfile-o360-o360api-Daniel -t ctbc_test:v1 . && \
  podman run -d --pod $POD_NAME --name $CONTAINER_NAME --tz=Asia/Taipei $(podman images | grep v1 | awk '{print $3}')
  cd ..
}
