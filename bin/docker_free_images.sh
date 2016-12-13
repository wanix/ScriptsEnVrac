#!/bin/sh
# Author: Erwan SEITE
# Licence : GPLv3
# Source : https://github.com/wanix/ScriptsEnVrac/blob/master/bin/docker_rm_all.sh
# Delete all docker containers (forcing), then delete all images from the hardisk

# Delete all containers
myDockerContainers=$(docker ps -a -q | wc -l)
if [ $myDockerContainers -eq 0 ]; then
  echo "No instance to delete"
else
  echo "Deleting $myDockerContainers container(s)"
  docker rm -f $(docker ps -a -q)
fi
# Delete all images
myDockerImages=$(docker images -q | wc -l)
if [ $myDockerImages -eq 0 ]; then
  echo "No image to delete"
else
  echo "Deleting $myDockerImages image(s)"
  docker rmi $(docker images -q)
fi
