# 이미지
FROM debian:bullseye

# 패키지 설치
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    wget \
    unzip \
    curl \
    mariadb-client \
    && apt-get clean

COPY ./tools/init-wordpress.sh /init-wordpress.sh

# wordpress cli 설치
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /bin/wp

WORKDIR /var/www/html

# wordpress 다운로드
RUN mkdir -p /var/www/html && \
    wget https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz -C /var/www/html && \
    rm -rf latest.tar.gz && \
    chown -R www-data:www-data /var/www/html/wordpress && \
    chmod -R 755 /var/www/html/wordpress && \
    sed -i "s/listen = .*/listen = 9000/" /etc/php/7.4/fpm/pool.d/www.conf



RUN mkdir -p /var/run/php && \
    chown -R www-data:www-data /var/run/php && \
    chmod +x /init-wordpress.sh

WORKDIR /var/www/html/wordpress

ENTRYPOINT ["/init-wordpress.sh" ]

