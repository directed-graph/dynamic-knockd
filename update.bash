#!/usr/bin/env bash

set -e

generator=${GENERATOR:-$(dirname $0)/generators/totp-base32.bash}
sequence_file=${SEQUENCE_FILE:-$(dirname $0)/etc/sequence}
sequence_repeat=${SEQUENCE_REPEAT:-30}

mkdir -p $(dirname $sequence_file)

sequence=( $($generator "$@") )
for ((i = 0; i < $sequence_repeat; ++i)); do
    (IFS=","; echo "${sequence[*]}")
done >$sequence_file

# SIGHUP to close all doors
systemctl kill -s SIGHUP knockd.service
# restart to reopen sequence file
systemctl restart knockd.service

