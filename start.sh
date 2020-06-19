#!/bin/sh -ex

postgrey -i 0.0.0.0:$PORT --dbdir=/data --user=$(id -u) --group=$(id -g) $OPTIONS
