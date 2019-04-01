#!/bin/sh

/usr/sbin/nginx -t && /usr/sbin/nginx || exit 1

/usr/bin/aria2c --conf-path="/usr/local/aria2/aria2.conf"
