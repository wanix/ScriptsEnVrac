#!/bin/sh
# Author: Erwan SEITE
# Licence : GPLv3
# Source : https://github.com/wanix/ScriptsEnVrac/blob/master/bin/docker_rm_all.sh
# Delete all docker containers (forcing)

myDockerContainers=$(docker ps -a -q | wc -l)
if [ $myDockerContainers -eq 0 ]; then
  echo "No instance to delete"
else
  echo "Deleting $myDockerContainers container(s)"
  docker rm -f $(docker ps -a -q)
fi
