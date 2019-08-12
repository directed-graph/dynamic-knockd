#!/usr/bin/env bash

set -e

generator=${GENERATOR:-$(dirname $0)/generators/totp-base32.bash}
sequence_file=${SEQUENCE_FILE:-/opt/dynamic-knockd/etc/sequence}
sequence_repeat=${SEQUENCE_REPEAT:-30}

mkdir -p $(dirname $sequence_file)

systemctl stop knockd.service
sequence=( $($generator "$@") )
for ((i = 0; i < $sequence_repeat; ++i)); do
    (IFS=","; echo "${sequence[*]}")
done >$sequence_file
systemctl start knockd.service

