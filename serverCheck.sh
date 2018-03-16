#!/bin/bash

RUNNING=1
while [  $RUNNING -eq 1 ]; do
    ${DOCKER}/Contents/Resources/bin/docker container ls -f status=running | grep -q -e npm_script_test
    RUNNING=$?
    if [ $RUNNING -eq 1 ]; then
        echo "Waiting for container to run"
        sleep 1
    fi
done
