#!/bin/bash

set -x
until mysql -h"$WORDPRESS_DB_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1"; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done

cd /var/www/html/wordpress/

if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    wp config create \
    --allow-root \
    --dbname=$MYSQL_DATABASE \
    --dbuser=$MYSQL_USER \
    --dbpass=$MYSQL_PASSWORD \
    --dbhost=$WORDPRESS_DB_HOST \
    --path=/var/www/html/wordpress \
    --skip-check
fi

# wordpress 설치
wp core install \
    --allow-root \
    --url=$DOMAIN \
    --title=$TITLE \
    --admin_user=$WORDPRESS_ADMIN_USER \
    --admin_password=$WORDPRESS_ADMIN_PASSWORD \
    --admin_email=$WORDPRESS_ADMIN_EMAIL \
    --locale=ko_KR

# 사용자 생성
wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --user_pass=$WORDPRESS_USER_PASSWORD --allow-root

# 포그라운드로 php-fpm 실행
exec php-fpm7.4 -F