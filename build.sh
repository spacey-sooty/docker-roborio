docker import ./systemimage.tar.gz roborio:tmp
docker build -f ./Dockerfile -t roborio:local .
docker rmi roborio:tmp
docker tag roborio:local roborio:latest
docker compose up
