echo " - setting up security"
server="192.168.99.100"
password="blablabla"
curl -s 'http://'$server':8080/v1/localauthconfig' -X POST -H 'Accept: application/json' -H 'Content-Type: application/json; charset=UTF-8' --data '{"accessMode":"unrestricted","name":"admin","id":null,"type":"localAuthConfig","enabled":false,"password":"'$password'","username":"admin"}' > /dev/null 2>&1
curl -s 'http://'$server':8080/v1/token' -X POST -H 'Accept: application/json' -H 'Content-Type: application/json; charset=UTF-8' --data '{"code":"admin:'$password'","authProvider":"localauthconfig"}' > /dev/null 2>&1
curl -s 'http://'$server':8080/v1/localauthconfig' -X POST -H 'Accept: application/json' -H 'Content-Type: application/json; charset=UTF-8' --data '{"accessMode":"unrestricted","name":"admin","id":null,"type":"localAuthConfig","enabled":true,"password":"'$password'","username":"admin"}' > /dev/null 2>&1

