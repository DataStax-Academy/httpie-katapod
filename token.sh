#!/bin/bash
export AUTH_TOKEN=`curl -L -X POST 'http://localhost:8081/v1/auth' \
  -H 'Content-Type: application/json' \
  --data-raw '{
    "username": "cassandra",
    "password": "cassandra"
}'| cut -f4 -d'"'`
http -qqq --session=stargate http://localhost:8082/v2/schemas/keyspaces  X-Cassandra-Token:$AUTH_TOKEN
ln -s ~/.config/httpie/sessions/localhost_8082 ~/.config/httpie/sessions/localhost_8080 >&/dev/null
ln -s ~/.config/httpie/sessions/localhost_8082 ~/.config/httpie/sessions/localhost_8180 >&/dev/null
