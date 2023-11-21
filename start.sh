docker container run --name ocdb -d -v ocdb-data:/var/lib/postgresql/data \
 -v $PWD/init-db.sh:/docker-entrypoint-initdb.d/init-db.sh \
 -p 5432:5432 \
 -e POSTGRES_INITDB_ARGS="-E 'UTF-8' --locale=POSIX" \
 -e POSTGRES_PASSWORD=postgres123 \
 postgres:9.5

 docker container run --name oc -h oc -d -v oc-data:/usr/local/tomcat/openclinica.data \
 -p 80:8080 \
 -e LOG_LEVEL=INFO \
 -e TZ=UTC-1 \
 -e DB_TYPE=postgres \
 -e DB_HOST=192.168.99.100 \
 -e DB_NAME=openclinica \
 -e DB_USER=clinica \
 -e DB_PASS=clinica \
 -e DB_PORT=5432 \
 -e SUPPORT_URL="https://www.openclinica.com/community-edition-open-source-edc/" \
 piegsaj/openclinica:oc-3.17

 docker container run --rm \
 -v oc-data:/tomcat/openclinica.data \
 -v $PWD:/tmp \
 piegsaj/openclinica:oc-3.13 \
 tar cvf /tmp/oc_data_backup_$(date +%Y-%m-%d_%H-%M-%S).tar /tomcat/openclinica.data