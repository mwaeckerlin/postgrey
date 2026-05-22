#!/bin/sh

echo | telnet 127.0.0.1 10025 2> /dev/null | grep -q 'Connected to 127.0.0.1.'
