#!/bin/bash
DEFAULT_SDC_API_URL='https://app.sysdigcloud.com'

echo -n "Enter API URL [${DEFAULT_SDC_API_URL}]: "
read SDC_API_URL
if [ "z${SDC_API_URL}" = "z" ] ; then
  SDC_API_URL=${DEFAULT_SDC_API_URL}
fi

API_TOKEN=""
while [ "z${API_TOKEN}" = "z" ] ; do
  echo -n "Enter Admin API Token (required): "
  read API_TOKEN
done

set -x

curl -XGET -v -k ''"${SDC_API_URL}"'/api/admin/appAttribute/apiUserCreation' \
           -H 'Content-Type: application/json; charset=UTF-8' \
           -H 'Accept: application/json, text/javascript, */*; q=0.01' \
           -H 'Authorization: Bearer '"${API_TOKEN}"''