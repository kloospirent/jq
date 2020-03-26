#!/bin/bash
docker create -it --name dummy spirent-jq bash
docker cp dummy:/opt/jq/jq .
docker rm -f dummy
