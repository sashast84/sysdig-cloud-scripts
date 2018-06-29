#!/bin/bash
#Set (if not yet present) a server-wise attribute that allow creation of users via API
DEFAULT_SDC_API_URL='https://app.sysdigcloud.com'
DEFAULT_API_USER_CREATION_ENABLE='true'

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

echo -n "Allow user creation via API [${DEFAULT_API_USER_CREATION_ENABLE}]: "
read API_USER_CREATION_ENABLE
if [ "z${API_USER_CREATION_ENABLE}" = "z" ]; then
  API_USER_CREATION_ENABLE="${DEFAULT_API_USER_CREATION_ENABLE}"
fi

set -x

curl -XPOST -v -k ''"${SDC_API_URL}"'/api/admin/appAttribute/' \
           -H 'Content-Type: application/json; charset=UTF-8' \
           -H 'Accept: application/json, text/javascript, */*; q=0.01' \
           -H 'Authorization: Bearer '"${API_TOKEN}"'' \
           --data-binary '{"id": "apiUserCreation", "value": "'"${API_USER_CREATION_ENABLE}"'" }' --compressed
