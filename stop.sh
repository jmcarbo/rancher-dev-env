docker rm -f rancher-server
docker rm -f rancher-client
docker ps -a | awk '{ print $1; }'|xargs docker rm -f
docker volume ls | awk '{ print $2; }' |xargs docker volume rm
