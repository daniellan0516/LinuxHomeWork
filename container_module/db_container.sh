db_container() {
  POD_NAME=DB_POD
  CONTAINER_NAME=postgres

  echo -e "\\033[33m===== 建立DB Container =====\\033[0m"
  cd container_module

  [ "$(podman pod ps | grep $POD_NAME)" = "" ] && 
  podman pod create --name $POD_NAME -p 5432:5432 -p 9187:9187

  podman run -d --pod $POD_NAME --name $CONTAINER_NAME -e POSTGRES_PASSWORD=1234 --tz=Asia/Taipei docker.io/library/postgres:latest && \

  podman cp init.sql \
    $(podman ps | grep postgres:latest | awk '{print $1}'):/var/lib/postgresql && \

  podman cp data.sql \
    $(podman ps | grep postgres:latest | awk '{print $1}'):/var/lib/postgresql && \

  podman exec -ti $(podman ps | grep postgres:latest | awk '{print $1}') \
    su postgres -c "psql -a -f /var/lib/postgresql/init.sql 1>/dev/null"

  podman exec -ti $(podman ps | grep postgres:latest | awk '{print $1}') \
    su postgres -c "psql -U o360 -d ctbcdb -a -f /var/lib/postgresql/data.sql 1>/dev/null"

  cd ..
}
