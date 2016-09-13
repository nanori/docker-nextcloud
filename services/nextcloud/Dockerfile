FROM alpine:3.4

ARG NEXTCLOUD_VERSION=10.0.0


RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U add \
    tar \
    nginx \
    supervisor \
    openssl \
    shadow@commuedge \
    ca-certificates \
    libsmbclient \
    tini@commuedge \
    php7@commuedge \
    php7-fpm@commuedge \
    php7-intl@commuedge \
    php7-mbstring@commuedge \
    php7-curl@commuedge \
    php7-gd@commuedge \
    php7-mcrypt@commuedge \
    php7-opcache@commuedge \
    php7-json@commuedge \
    php7-session@commuedge \
    php7-pdo@commuedge \
    php7-dom@commuedge \
    php7-ctype@commuedge \
    php7-iconv@commuedge \
    php7-pdo_mysql@commuedge \
    php7-pdo_pgsql@commuedge \
    php7-pgsql@commuedge \
    php7-pdo_sqlite@commuedge \
    php7-sqlite3@commuedge \
    php7-zlib@commuedge \
    php7-zip@commuedge \
    php7-xmlreader@commuedge \
    php7-posix@commuedge \
    php7-openssl@commuedge \
    php7-ldap@commuedge \
    php7-ftp@commuedge \
    php7-apcu@testing \
    php7-redis@testing \
 && mkdir /nextcloud \
 && addgroup nextcloud \
 && adduser -h /nextcloud -s /bin/sh -D -G nextcloud nextcloud \
 && touch /var/run/php-fpm.sock \
 && mkdir /tmp/fastcgi /tmp/client_body \
 && cd /tmp \
 && wget -q https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.zip \
 && cd / \
 && unzip /tmp/nextcloud-10.0.0.zip \
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
 && chown -R nextcloud:nextcloud /var/run/php-fpm.sock /var/lib/nginx

VOLUME /nextcloud/data /nextcloud/config /nextcloud/apps

EXPOSE 80

LABEL description="A server software for creating file hosting services" \
      nextcloud="Nextcloud daily build"

CMD ["/sbin/tini","--","run.sh"]
