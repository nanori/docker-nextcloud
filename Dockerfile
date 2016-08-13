FROM alpine:3.4

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U add \
    tar \
    nginx \
    supervisor \
    openssl \
    shadow@testing \
    ca-certificates \
    libsmbclient \
    tini@commuedge \
    php7@testing \
    php7-fpm@testing \
    php7-intl@testing \
    php7-mbstring@testing \
    php7-curl@testing \
    php7-gd@testing \
    php7-mcrypt@testing \
    php7-opcache@testing \
    php7-json@testing \
    php7-session@testing \
    php7-pdo@testing \
    php7-dom@testing \
    php7-ctype@testing \
    php7-iconv@testing \
    php7-pdo_mysql@testing \
    php7-pdo_pgsql@testing \
    php7-pgsql@testing \
    php7-pdo_sqlite@testing \
    php7-sqlite3@testing \
    php7-zlib@testing \
    php7-zip@testing \
    php7-xmlreader@testing \
    php7-posix@testing \
    php7-openssl@testing \
    php7-ldap@testing \
    php7-ftp@testing \
    php7-apcu@testing \
    php7-redis@testing \
 && mkdir /nextcloud \
 && addgroup nextcloud \
 && adduser -h /nextcloud -s /bin/sh -D -G nextcloud nextcloud \
 && touch /var/run/php-fpm.sock \
 && mkdir /tmp/fastcgi /tmp/client_body \
 && cd /tmp \
 && wget -q https://download.nextcloud.com/server/daily/latest.tar.bz2 \
 && tar xjf latest.tar.bz2 --strip 1 -C /nextcloud \
 && mv /nextcloud/apps /apps.tmp \
 && apk del tar \
 && rm -rf /var/cache/apk/* /tmp/*

COPY nginx.conf        /etc/nginx/nginx.conf
COPY php-fpm.conf      /etc/php7/php-fpm.conf
COPY opcache.ini       /etc/php7/conf.d/00_opcache.ini
COPY apcu.ini          /etc/php7/conf.d/apcu.ini
COPY supervisord.conf  /etc/supervisor/supervisord.conf
COPY run.sh            /usr/local/bin/run.sh
COPY cron              /etc/periodic/15min/nextcloud

RUN chmod +x /usr/local/bin/run.sh /etc/periodic/15min/nextcloud \
 && chown -R /var/run/php-fpm.sock /var/lib/nginx

VOLUME /nextcloud/data /nextcloud/config /nextcloud/apps

EXPOSE 80

LABEL description="A server software for creating file hosting services" \
      nextcloud="Nextcloud daily build"

CMD ["/sbin/tini","--","run.sh"]
