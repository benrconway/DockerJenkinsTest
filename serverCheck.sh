#!/bin/bash

RUNNING=1
while [  $RUNNING -eq 1 ]; do
    docker container ls -f status=running | grep -q -e $1
    RUNNING=$?
    if [ $RUNNING -eq 1 ]; then
        echo "Waiting for container to run"
        sleep 1
    fi
done
