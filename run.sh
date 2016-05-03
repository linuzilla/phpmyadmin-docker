#!/bin/sh

set -x

mkdir -p /log
mkdir -p /tmp/nginx
chown nginx /tmp/nginx

php-fpm

if [ ! -f /www/phpMyAdmin/config.secret.inc.php ] ; then
    cat > /www/phpMyAdmin/config.secret.inc.php <<EOT
<?php
\$cfg['blowfish_secret'] = '`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`';
EOT
fi

for x in PMA_HOST PMA_ABSOLUTE_URI PMA_PORT; do
	eval "y=\$$x"
	if [ "$y" != "" ]; then
		sed -i "s/#fastcgi_param $x/fastcgi_param $x $y;/" /etc/nginx/nginx.conf 
	fi
done

exec nginx

#exec php -S 0.0.0.0:80 -t /www/ \
#    -d upload_max_filesize=$PHP_UPLOAD_MAX_FILESIZE \
#    -d post_max_size=$PHP_UPLOAD_MAX_FILESIZE \
#    -d max_input_vars=$PHP_MAX_INPUT_VARS
