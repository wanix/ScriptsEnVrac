#!/bin/bash
MYPATH=$(dirname $0)
unset RUNTPL
test -r ./run_from_inspect.tpl && export RUNTPL="./run_from_inspect.tpl"
test -r ${MYPATH}/../docker/run_from_inspect.tpl && export RUNTPL="${MYPATH}/../docker/run_from_inspect.tpl"
test -z "${RUNTPL}" && echo "Error: can't find run_from_inspect.tpl" && exit 1
docker inspect --format "$(<${RUNTPL})" $@
