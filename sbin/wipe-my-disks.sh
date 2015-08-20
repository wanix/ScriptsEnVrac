#!/bin/sh
#Auteur : Erwan SEITE
#Licence : GPLv3
#Source : https://github.com/wanix/ScriptsEnVrac/blob/master/sbin/wipe-my-disks.sh

#This script free your mounts in your virtual guest in order to compact its from your virtual hosts
FILESYSTEM_MASK="ext[2-4]"

if [ $(id -u) -ne 0 ];
then
  echo "This script must be used as root" >&2
  exit 1
fi

SFILL=$(which sfill)
if [ -z "${SFILL}" ];
then
  echo "Error: can't find sfill, you should install secure-delete" >&2
  exit 1
fi

TEMPODIR=".wipe$$"

for filesystem in $(grep "${FILESYSTEM_MASK}" /etc/fstab | sed -r 's/\s+/ /g' | cut -d ' ' -f 2); do
  echo "Wipping ${filesystem}"
  echo "${filesystem}" | grep -q '/$'
  if [ $? -eq 0 ];
  then
    WORKINGDIR="${filesystem}${TEMPODIR}"
  else
    WORKINGDIR="${filesystem}/${TEMPODIR}"
  fi
  echo "  - creating ${WORKINGDIR}"
  mkdir ${WORKINGDIR}
  echo "  - filling with zero : \"sfill -v -f -l -l -z ${WORKINGDIR}\""
  sfill -v -f -l -l -z ${WORKINGDIR}
  echo "  - deleting ${WORKINGDIR}"
  rmdir ${WORKINGDIR}
done

exit 0
