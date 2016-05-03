# Switch back to stable once 3.4 is out
FROM alpine:edge

RUN apk update && \
    apk add --no-cache \
    	php-cli php-mysqli php-ctype php-xml php-gd php-zlib php-openssl php-curl php-opcache php-json php-mcrypt curl \
        nginx ca-certificates php-fpm; \
	apk add -u musl; \
    mkdir /www; curl --location https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz | tar xzf - -C /www \
        && mv /www/phpMyAdmin* /www/phpMyAdmin \
        && rm -rf /www/phpMyAdmin/js/jquery/src/ /www/phpMyAdmin/examples /www/phpMyAdmin/po/

COPY files/nginx.conf /etc/nginx/
COPY files/php-fpm.conf /etc/php/
COPY files/index.html /www
COPY config.inc.php /www/phpMyAdmin
COPY run.sh /run.sh
RUN chmod u+rwx /run.sh

EXPOSE 80

ENV PHP_UPLOAD_MAX_FILESIZE=64M \
    PHP_MAX_INPUT_VARS=2000

ENTRYPOINT [ "/run.sh" ]
