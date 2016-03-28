export server="192.168.99.100"
curl -s 'http://'$server':8080/v1/activesettings/1as!api.host' -X PUT -H 'Accept: application/json' -H 'Content-Type: application/json; charset=UTF-8' --data '{"id":"1as!api.host","type":"activeSetting","name":"api.host","activeValue":null,"inDb":false,"source":null,"value":"'$server':8080"}'
