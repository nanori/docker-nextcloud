#!/bin/sh
set -x

[[ -n $UID ]]  && usermod -o -u $UID  nextcloud
[[ -n $GID ]] && groupmod -o -g $GID nextcloud

chown -R nextcloud:nextcloud /nextcloud /var/run/php-fpm.sock /var/lib/nginx 

# Setup config
if [ ! -f /config/config.php ]; then
  cp /config/config.php /nextcloud/config/config.php
fi

if [ "$(ls -A /nextcloud/apps/)" == "" ]; then
  cp -a /apps.tmp/* /nextcloud/apps/
fi


supervisord -c /etc/supervisor/supervisord.conf
