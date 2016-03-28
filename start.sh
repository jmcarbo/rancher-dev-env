echo "Starting rancher server"
eval $(docker-machine env default)
docker pull rancher/server:latest >/dev/null 2>&1
docker run -d -p 8080:8080  --name rancher-server rancher/server:latest >/dev/null 2>&1
until curl $server:8080 > /dev/null 2>&1; do echo -n .; sleep 2; done
sleep 2
export server=$(docker-machine ip default)

echo "Registering node"
curl -s 'http://'$server':8080/v1/activesettings/1as!api.host' -X PUT -H 'Accept: application/json' -H 'Content-Type: application/json; charset=UTF-8' --data '{"id":"1as!api.host","type":"activeSetting","name":"api.host","activeValue":null,"inDb":false,"source":null,"value":"'$server':8080"}' >/dev/null 2>&1

curl -s 'http://'$server':8080/v1/registrationtokens?projectId=1a5' -X POST -H 'Accept: application/json' -H 'Content-Type: application/json; charset=UTF-8' -H 'Referer: http://'$server':8080/static/hosts/add/custom' >/dev/null 2>&1

until curl -s http://$server:8080/v1/registrationtokens|jq '.data[0].links.registrationUrl' > /dev/null 2>&1; do echo -n .; sleep 2; done
sleep 2
registration_url=$(curl -s http://$server:8080/v1/registrationtokens|jq '.data[0].links.registrationUrl')
temp="${registration_url%\"}"
temp="${temp#\"}"
export registration_url=$temp

registration_image=$(curl -s http://$server:8080/v1/registrationtokens|jq '.data[0].image')
temp="${registration_image%\"}"
temp="${temp#\"}"
export registration_image=$temp

docker run --name rancher-client -e CATTLE_AGENT_IP=$server -d --privileged -v /var/run/docker.sock:/var/run/docker.sock $registration_image $registration_url >/dev/null 2>&1

#curl -s http://$server:8080/v1/registrationtokens

echo "Getting api keys"
curl -s 'http://'$server':8080/v1/apikey?projectId=1a5' -X POST -H 'Accept: application/json' --data {"type":"apices"} | jq '.' > secretapi.txt
export rancher_url='http://'$server':8080/'
export rancher_access_key=$(cat secretapi.txt | jq '.publicValue')
export rancher_secret_key=$(cat secretapi.txt | jq '.secretValue')
echo export RANCHER_URL=${rancher_url} > credentials.env
echo export RANCHER_ACCESS_KEY=${rancher_access_key} >> credentials.env
echo export RANCHER_SECRET_KEY=${rancher_secret_key} >> credentials.env
echo export RANCHER_IP=$server >> credentials.env

echo "Done"
