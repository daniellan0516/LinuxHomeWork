db_container() {
  cd container_module
  echo -e "\\033[33m===== 建立DB Container =====\\033[0m" && \
  podman pod create --name postgresql -p 5432:5432 -p 9187:9187 && \
  podman run -d --pod postgresql --name db -e POSTGRES_PASSWORD=1234 docker.io/library/postgres:latest && \
  podman cp data.sql \
    $(podman ps | grep postgres:latest | awk '{print $1}'):/var/lib/postgresql && \

  podman exec -ti $(podman ps | grep postgres:latest | awk '{print $1}') su postgres -c \
  "psql << EOF
CREATE USER o360 WITH PASSWORD '1234'; 
CREATE DATABASE ctbcdb TEMPLATE template0 ENCODING 'UTF-8';
ALTER DATABASE ctbcdb OWNER TO o360;
GRANT ALL PRIVILEGES ON DATABASE ctbcdb TO o360;
EOF
  " && \
  podman exec -ti $(podman ps | grep postgres:latest | awk '{print $1}') \
    su postgres -c "psql -U o360 -d ctbcdb -a -f /var/lib/postgresql/data.sql 1>/dev/null"
  cd ..
}
