#!/usr/bin/env bash
set -uo pipefail

OPTS=`getopt -o edu:f:l:p:h --long enable,disable,username:,firstname:,lastname:,password:,help -n 'parse-options' -- "$@"`
if [ $? != 0 ] ; then
  echo "Failed parsing options." >&2
  exit 1
fi

ENV="./env.sh"
USERNAME=""
FIRSTNAME=""
LASTNAME=""
PASSWORD=""
HELP=false

eval set -- "$OPTS"

function print_usage() {
  echo "Usage: ./create_user.sh [OPTION]"
  echo
  echo "Create a user record, or change permissions for API-based user creation"
  echo
  echo "If no OPTION is specified, the current API User Creation settings are printed"
  echo
  echo "General options:"
  echo "  -h | --help             Print this Usage output"
  echo
  echo "Options for creating a user record:"
  echo "  -u | --username         Username for the user record to create"
  echo "  -p | --password         Password for the user record to create"
  echo "  -f | --firstname        (optional) First name for the user record to create"
  echo "  -l | --lastname         (optional) Last name for the user record to create"
  exit 1
}

while true; do
  case "$1" in
    -u | --username ) USERNAME="$2"; shift; shift ;;
    -p | --password ) PASSWORD="$2"; shift; shift ;;
    -f | --firstname ) FIRSTNAME="$2"; shift; shift ;;
    -l | --lastname ) LASTNAME="$2"; shift; shift ;;
    -h | --help ) HELP=true; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ $HELP = true ] ; then
  print_usage
fi

if [ $# -gt 0 ] ; then
  echo "Excess command-line arguments detected. Exiting."
  echo
  print_usage
fi

if [ -e "$ENV" ] ; then
  source "$ENV"
else
  echo "File not found: $ENV"
  echo "See the README for details on populating this file with your settings"
  echo "(https://github.com/draios/sysdig-cloud-scripts/blob/master/user_creation/README.md)"
  exit 1
fi

if [ -n "$USERNAME" ] ; then
  if [ -o -z "$PASSWORD" ] ; then
    print_usage
  else
    JSON='{"username": "'"${USERNAME}"'","password":"'"${PASSWORD}"'","customer":{"id":"'${CUSTOMER_ID}'"}'
    if [ -n "$FIRSTNAME" ] ; then
      JSON=${JSON}',"firstName": "'"${FIRSTNAME}"'"'
    fi
    if [ -n "$LASTNAME" ] ; then
      JSON=${JSON}',"lastName": "'"${LASTNAME}"'"'
    fi
    JSON=${JSON}'}'
    curl $CURL_OPTS \
      -H "Authorization: Bearer $API_TOKEN" \
      -H "Content-Type: application/json; charset=UTF-8" \
      -X POST \
      --data-binary "${JSON}" \
      $URL/api/admin/user
  fi

elif [ -n "$PASSWORD" -o -n "$FIRSTNAME" -o -n "$LASTNAME" ] ; then
  print_usage
  fi
