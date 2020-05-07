#!/bin/sh -ex

postgrey -i $PORT --dbdir=/data --user=$(id -u) --group=$(id -g) $OPTIONS
