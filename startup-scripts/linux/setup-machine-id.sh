#!/bin/bash

# PLACE IN /sbin/setup-machine-id.sh

set -e

MACHINE_ID_SET_FILE=/root/machine-id-is-set

if ! [ -f $MACHINE_ID_SET_FILE ]; then
  rm -f /etc/machine-id /var/lib/dbus/machine-id
  dbus-uuidgen --ensure=/etc/machine-id
  dbus-uuidgen --ensure
  systemd-machine-id-setup
  echo "If tou delete this file, after reboot new machine id will be generated" > $MACHINE_ID_SET_FILE
fi
exit 0
