#!/bin/bash -ex

# setup logging
! test -e /var/log/mail.log || rm /var/log/mail.log
ln -sf /proc/self/fd/1 /var/log/mail.log

service postgrey status && service postgrey restart || service postgrey start
sleep infinity
