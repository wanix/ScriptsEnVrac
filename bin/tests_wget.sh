#!/bin/bash
# Author: eseite@april.org
# Licence: GPL v2
# need time & wget (apt-get install time wget)
FILEURL="$1"
COOKIEFILE="$2"

printusage() {
  echo "Usage: $0 <file containing URLs> [cookiefile]"
}

DATETEST=$(date "+%Y%m%d-%H%M%S")
TESTDIR=$HOME/Tir-${DATETEST}

if [ ! -r "${FILEURL}" ];
then
  echo "Error: can't read file URL"
  printusage
  exit 1
fi

if [ -n "${COOKIEFILE}" ] && [ ! -r "${COOKIEFILE}" ];
then
  echo "Error: cookiefile must be readable"
  printusage
  exit 1
fi

mkdir $TESTDIR

TESTNUM=0
echo "Starting test $(date) ($(date '+%Y-%m-%d-%H:%M:%S'))" | tee -a ${TESTDIR}/test.log
while read line;
do
  TESTNUM=$(expr ${TESTNUM} + 1)
  echo "(${TESTNUM} [$(date '+%Y-%m-%d-%H:%M:%S')]) Testing URL $line" | tee -a ${TESTDIR}/test.log
  TMPDIRNAME=${TESTDIR}/$(printf 'TEST-%05d' "${TESTNUM}")
  mkdir ${TMPDIRNAME}
  if [ $? -ne 0 ];
  then
    echo "  Error creating ${TMPDIRNAME}, aborting this one" | tee -a ${TESTDIR}/test.log
    continue
  fi
  echo "$line" > ${TMPDIRNAME}/url.txt
  if [ -z "${COOKIEFILE}" ];
  then
    /usr/bin/time --verbose -o ${TMPDIRNAME}/time.log wget -d -P ${TMPDIRNAME} -o ${TMPDIRNAME}/wget.log -p $line 1>>${TESTDIR}/test.log 2>&1
  else
    /usr/bin/time --verbose -o ${TMPDIRNAME}/time.log wget -d -P ${TMPDIRNAME} --load-cookies ${COOKIEFILE} -o ${TMPDIRNAME}/wget.log -p $line 1>>${TESTDIR}/test.log 2>&1
  fi
done < ${FILEURL}

echo "End of test $(date) ($(date '+%Y-%m-%d-%H:%M:%S'))" | tee -a ${TESTDIR}/test.log
