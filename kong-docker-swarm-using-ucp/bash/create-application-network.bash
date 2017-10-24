#!/usr/bin/env bash

echo "create ${APP_NAME} network"
docker network create -d overlay ${APP_NAME} #> /dev/null #2>&1
