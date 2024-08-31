unzip "FRC_roboRIO_$1.zip" -d unpack
unzip "unpack/FRC_roboRIO_$1/roboRIO_$1" -d unpack

docker import ./unpack/systemimage.tar.gz roborio:tmp
docker build -f ./Dockerfile -t roborio:local .
docker rmi roborio:tmp
rm unpack -rf
docker tag roborio:local "roborio:$1"
docker compose up
