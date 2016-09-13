# docker-nextcloud

docker-compose.yml example
```
version: '2'
services:
  web:
    build: services/nextcloud/
    image: nanori/nextcloud
    links:
      - db:mariadb
      - collabora:collabora
    networks:
      - reverseproxy
      - backend
    environment:
      - UID=10200
      - GID=10200
    volumes:
      - /data/nextcloud/data:/nextcloud/data:Z
      - /data/nextcloud/config:/nextcloud/config:Z
      - /data/nextcloud/apps:/nextcloud/apps:Z

  db:
    image: mariadb:10
    networks:
      - backend
    environment:
      - MYSQL_DATABASE=nextcloud
      - MYSQL_ROOT_PASSWORD=My_@wesome_password_f0r_rO0t_user
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=My_@wesome_password_f0r_nextcloud_user
    volumes:
      - /data/nextcloud/db:/var/lib/mysql:Z

  collabora:
    build: services/collabora/
    image: nanori/collabora
    networks:
      - reverseproxy

networks:
  backend:
  reverseproxy:
    external:
      name: reverseproxy_default


```
