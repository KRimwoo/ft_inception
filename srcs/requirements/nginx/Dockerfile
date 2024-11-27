# 이미지
FROM debian:bullseye

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# 패키지, Nginx, OpenSSL 설치
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nginx openssl \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"


# 디렉토리 생성 + 권한설정
RUN mkdir -p /var/www/html/wordpress && \
    chown -R www-data:www-data /var/www/html && \
    chmod 755 /var/www/html && \
    mkdir -p /var/run/nginx && \
    chown -R www-data:www-data /var/run/nginx && \
    chmod 755 /var/run/nginx && \
    mkdir -p /var/log/nginx && \
    chown -R www-data:www-data /var/log/nginx && \
    chmod 755 /var/log/nginx

# SSL 인증서 생성 및 Nginx 시작 스크립트
COPY ./tools/init-nginx.sh /init-nginx.sh
RUN chmod +x /init-nginx.sh

ENTRYPOINT ["/init-nginx.sh"]
