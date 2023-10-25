#!/bin/bash
# PLACE IN //sbin/setup-hostname.sh

set -e

HOST_NAME_SET_FILE=/root/host-name-is-set

if ! [ -f $HOST_NAME_SET_FILE ]; then
  HOST_NAME_PREFIX="prefix"
  HOST_NAME_LENGTH=40
  RANDOM_PART_LENGTH=$(( $HOST_NAME_LENGTH - ${#HOST_NAME_PREFIX} ))
  RANDOM_CHARS=$(tr -dc 'A-Z' </dev/urandom | head -c $RANDOM_PART_LENGTH)
  HOST_NAME="${HOST_NAME_PREFIX}${RANDOM_CHARS}"
  hostnamectl set-hostname "$HOST_NAME"
  echo "If tou delete this file, after reboot new host name id will be generated" > $HOST_NAME_SET_FILE
fi
exit 0
