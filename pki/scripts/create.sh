#! /bin/bash

ca=root.crt
ca_key=root.key

server=CluedIn.Dev.server.crt
server_key=CluedIn.Dev.server.key

website=CluedIn.Dev.website.crt
website_key=CluedIn.Dev.website.key

[[ ! -f $ca || ! -f $ca_key ]] && step certificate create "Cluedin Dev Root CA" $ca $ca_key --profile root-ca --no-password --insecure -f

step certificate create --san *.127.0.0.1.xip.io --san *.cluedin.test --san localhost --san host.docker.internal --san server --ca-key $ca_key --ca $ca --no-password --insecure -f --not-after 2160h --not-before -24h Cluedin.Dev.server $server $server_key
step certificate create --san *.127.0.0.1.xip.io --san *.cluedin.test --san localhost --ca-key $ca_key --ca $ca --no-password --insecure -f --not-after 2160h --not-before -24h Cluedin.Dev.website $website $website_key
