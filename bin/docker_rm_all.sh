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
myVolumes=$(docker volume ls -q | wc -l)
if [ $myVolumes -eq 0 ]; then
  echo "No volume to delete"
else
  echo "Deleting $myVolumes volume(s)"
  docker volume rm $(docker volume ls -q)
fi

